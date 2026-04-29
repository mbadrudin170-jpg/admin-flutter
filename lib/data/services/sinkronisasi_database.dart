// Path: lib/data/services/sinkronisasi_database.dart

// File ini bertanggung jawab untuk sinkronisasi data antara database lokal (SQLite)
// dan Firestore. Ini termasuk mengunggah perubahan lokal ke Firebase dan
// mengunduh perubahan dari Firebase ke database lokal.

import 'dart:async';
import 'dart:developer' as developer;
import 'package:admin_wifi/utils/format_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/operasi/riwayat_langganan_operasi.dart'; // ditambah
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart'; // ditambah
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:admin_wifi/utils/sync_manager.dart';

class SinkronisasiDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SyncManager _syncManager = SyncManager();
  Timer? _timer;

  // Fungsi untuk memulai sinkronisasi periodik setiap 5 menit.
  void startSync() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      developer.log(
        'Memulai sinkronisasi periodik...',
        name: 'SinkronisasiService',
      );
      sinkronkanSemuaData();
    });
    // Jalankan sinkronisasi segera saat aplikasi dimulai.
    sinkronkanSemuaData();
  }

  // Fungsi untuk menghentikan timer sinkronisasi.
  void dispose() {
    _timer?.cancel();
  }

  // Fungsi utama untuk sinkronisasi data dua arah.
  Future<void> sinkronkanSemuaData() async {
    developer.log(
      'Memulai sinkronisasi data inkremental...',
      name: 'SinkronisasiService',
    );
    final lastSync = await _syncManager.getLastSyncTimestamp();
    final now = DateTime.now();

    final dompetOperasi = DompetOperasi();
    final kategoriOperasi = KategoriOperasi();
    final transaksiOperasi = TransaksiOperasi();
    final pelangganOperasi = PelangganOperasi();
    final paketOperasi = PaketOperasi();
    final pelangganAktifOperasi = PelangganAktifOperasi();
    final kritikSaranOperasi = KritikSaranOperasi();
    final riwayatLanggananOperasi = RiwayatLanggananOperasi(); // ditambah

    try {
      // 1. Unggah perubahan lokal ke Firebase
      await _unggahPerubahan(lastSync, {
        'kategori': (await kategoriOperasi.getPerubahan(lastSync)),
        'dompet': (await dompetOperasi.getPerubahan(lastSync)),
        'transaksi': (await transaksiOperasi.getPerubahan(lastSync)),
        'pelanggan': (await pelangganOperasi.getPerubahan(lastSync)),
        'paket': (await paketOperasi.getPerubahan(lastSync)),
        'pelanggan_aktif': (await pelangganAktifOperasi.getPerubahan(lastSync)),
        'kritik_saran': (await kritikSaranOperasi.getPerubahan(lastSync)),
        'riwayat_langganan': (await riwayatLanggananOperasi.getPerubahan(
          lastSync,
        )), // ditambah
      });

      // 2. Unduh perubahan dari Firebase ke lokal
      await _unduhPerubahan(lastSync, {
        'kategori': kategoriOperasi,
        'dompet': dompetOperasi,
        'transaksi': transaksiOperasi,
        'pelanggan': pelangganOperasi,
        'paket': paketOperasi,
        'pelanggan_aktif': pelangganAktifOperasi,
        'kritik_saran': kritikSaranOperasi,
        'riwayat_langganan': riwayatLanggananOperasi, // ditambah
      });

      // 3. Simpan waktu sinkronisasi yang berhasil
      await _syncManager.setLastSyncTimestamp(now);
      developer.log(
        'Sinkronisasi inkremental berhasil diselesaikan.',
        name: 'SinkronisasiService',
      );

      // 4. Jadwalkan notifikasi setelah sinkronisasi
      await _jadwalkanNotifikasiUntukPelangganAktif();
    } catch (e, s) {
      developer.log(
        'Kesalahan besar saat sinkronisasi inkremental',
        error: e,
        stackTrace: s,
        name: 'SinkronisasiService',
      );
    }
  }

  // Fungsi internal untuk mengunggah perubahan lokal ke Firebase.
  Future<void> _unggahPerubahan(
    DateTime lastSync,
    Map<String, List<dynamic>> dataPerubahan,
  ) async {
    developer.log(
      'Mengunggah perubahan sejak $lastSync',
      name: 'SinkronisasiService',
    );
    final batch = _firestore.batch();

    dataPerubahan.forEach((collectionName, items) {
      if (items.isNotEmpty) {
        developer.log(
          '  - Menemukan ${items.length} perubahan di koleksi $collectionName',
          name: 'SinkronisasiService',
        );
        for (var item in items) {
          final docRef = _firestore
              .collection(collectionName)
              .doc(item.id.toString());
          batch.set(docRef, item.toMap());
        }
      }
    });

    await batch.commit();
    developer.log('Pengunggahan batch selesai.', name: 'SinkronisasiService');
  }

  // Fungsi internal untuk mengunduh perubahan dari Firebase ke lokal.
  Future<void> _unduhPerubahan(
    DateTime lastSync,
    Map<String, dynamic> operasiMap,
  ) async {
    developer.log(
      'Mengunduh perubahan sejak $lastSync',
      name: 'SinkronisasiService',
    );

    for (var collectionName in operasiMap.keys) {
      developer.log(
        '🔍 Mencoba akses koleksi: $collectionName',
        name: 'SinkronisasiService',
      );

      final querySnapshot = await _firestore.collection(collectionName).get();

      developer.log(
        '✅ Koleksi $collectionName: ${querySnapshot.docs.length} dokumen',
        name: 'SinkronisasiService',
      );

      if (querySnapshot.docs.isNotEmpty) {
        developer.log(
          '  - Menemukan ${querySnapshot.docs.length} perubahan di koleksi $collectionName dari Firebase',
          name: 'SinkronisasiService',
        );
        final op = operasiMap[collectionName];

        final items = querySnapshot.docs
            .map((doc) {
              try {
                final data = doc.data();
                data['id'] ??= int.tryParse(doc.id) ?? doc.id;
                data['diperbarui'] ??= DateTime.now().toIso8601String();
                if (op is KategoriOperasi) {
                  return Kategori.fromMap(data);
                }
                if (op is DompetOperasi) {
                  return Dompet.fromMap(data);
                }
                if (op is TransaksiOperasi) {
                  return TransaksiModel.fromMap(data);
                }
                if (op is PelangganOperasi) {
                  return Pelanggan.fromMap(data);
                }
                if (op is PaketOperasi) {
                  return Paket.fromMap(data);
                }
                if (op is PelangganAktifOperasi) {
                  return PelangganAktif.fromMap(data);
                }
                if (op is KritikSaranOperasi) {
                  return KritikSaranModel.fromMap(data);
                }
                if (op is RiwayatLanggananOperasi) {
                  // ditambah
                  return RiwayatLanggananModel.fromMap(data);
                }
              } catch (e) {
                developer.log(
                  '❌ Gagal akses $collectionName: $e',
                  name: 'SinkronisasiService',
                );
              }
              return null;
            })
            .where((item) => item != null)
            .toList();

        if (op is KategoriOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Kategori>());
        }
        if (op is DompetOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Dompet>());
        }
        if (op is TransaksiOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<TransaksiModel>());
        }
        if (op is PelangganOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Pelanggan>());
        }
        if (op is PaketOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Paket>());
        }
        if (op is PelangganAktifOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<PelangganAktif>());
        }
        if (op is KritikSaranOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<KritikSaranModel>());
        }
        if (op is RiwayatLanggananOperasi) {
          // ditambah
          await op.sisipkanAtauPerbaruiBatch(
            items.cast<RiwayatLanggananModel>(),
          );
        }
      }
    }
    developer.log(
      'Pengunduhan perubahan selesai.',
      name: 'SinkronisasiService',
    );
  }

  // Fungsi untuk memeriksa dan menjadwalkan notifikasi untuk semua pelanggan aktif.
  Future<void> _jadwalkanNotifikasiUntukPelangganAktif() async {
    developer.log(
      'Memeriksa dan menjadwalkan notifikasi untuk pelanggan aktif...',
      name: 'SinkronisasiService',
    );
    final pelangganAktifOperasi = PelangganAktifOperasi();
    final pelangganOperasi = PelangganOperasi();
    final notifikasiServis = NotifikasiServis();

    final semuaPelangganAktif = await pelangganAktifOperasi
        .ambilSemuaPelangganAktif();
    final sekarang = DateTime.now();

    for (var p in semuaPelangganAktif) {
      if (p.id == null) continue;

      final dataPelanggan = await pelangganOperasi.getPelangganById(
        p.idPelanggan,
      );
      final namaPelanggan = dataPelanggan?.nama ?? 'Pelanggan';

      // Notifikasi H-3
      final tigaHariSebelumKadaluarsa = p.tanggalBerakhir.subtract(
        const Duration(days: 3),
      );

      // Jadwalkan hanya jika waktu notifikasi masih di masa depan
      if (tigaHariSebelumKadaluarsa.isAfter(sekarang)) {
        await notifikasiServis.jadwalNotifikasi(
          id: (p.id.hashCode.abs() + 1),
          title: '⏰ Paket Akan Berakhir',
          body:
              'Paket $namaPelanggan akan berakhir dalam 3 hari (${FormatTanggal.formatTanggalBasic(p.tanggalBerakhir)})',
          jadwal: tigaHariSebelumKadaluarsa,
        );
      } else {
        // Jika waktu notifikasi sudah lewat, batalkan notifikasi yang mungkin sudah ada.
        await notifikasiServis.batalNotifikasi((p.id.hashCode.abs() + 1));
      }

      // Notifikasi Hari H
      final waktuKadaluarsa = p.tanggalBerakhir;

      if (waktuKadaluarsa.isAfter(sekarang)) {
        await notifikasiServis.jadwalNotifikasi(
          id: (p.id.hashCode.abs() + 2),
          title: '🔔 Paket Berakhir Sekarang',
          body:
              'Paket $namaPelanggan telah berakhir hari ini (${FormatTanggal.formatTanggalBasic(waktuKadaluarsa)}). Harap perbarui paket.',
          jadwal: waktuKadaluarsa,
        );
      } else {
        // Jika sudah kadaluarsa, batalkan notifikasi hari H.
        await notifikasiServis.batalNotifikasi((p.id.hashCode.abs() + 2));
      }
    }
    developer.log(
      'Pemeriksaan dan penjadwalan notifikasi selesai.',
      name: 'SinkronisasiService',
    );
  }
}
