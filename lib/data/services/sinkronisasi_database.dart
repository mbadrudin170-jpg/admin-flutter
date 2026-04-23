// Path: lib/data/services/sinkronisasi_database.dart

// File ini bertanggung jawab untuk sinkronisasi data antara database lokal (SQLite)
// dan Firestore. Ini termasuk mengunggah perubahan lokal ke Firebase dan
// mengunduh perubahan dari Firebase ke database lokal.

import 'dart:async';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:admin_wifi/utils/sync_manager.dart';

// diubah: Nama kelas diubah dari FirebaseService menjadi SinkronisasiService.
class SinkronisasiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SyncManager _syncManager = SyncManager();
  Timer? _timer;

  // Fungsi untuk memulai sinkronisasi periodik setiap 5 menit.
  void startSync() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      developer.log(
        'Memulai sinkronisasi periodik...',
        name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
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

  // dihapus: Fungsi hapusPelangganAktif telah dihapus dari kelas ini.
  // Tanggung jawabnya akan dipindahkan ke lapisan Repository untuk pemisahan
  // antara logika bisnis langsung (seperti penghapusan) dan sinkronisasi latar belakang.

  // Fungsi utama untuk sinkronisasi data dua arah.
  Future<void> sinkronkanSemuaData() async {
    developer.log(
      'Memulai sinkronisasi data inkremental...',
      name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
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
      });

      // 3. Simpan waktu sinkronisasi yang berhasil
      await _syncManager.setLastSyncTimestamp(now);
      developer.log(
        'Sinkronisasi inkremental berhasil diselesaikan.',
        name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
      );
    } catch (e, s) {
      developer.log(
        'Kesalahan besar saat sinkronisasi inkremental',
        error: e,
        stackTrace: s,
        name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
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
      name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
    );
    final batch = _firestore.batch();

    dataPerubahan.forEach((collectionName, items) {
      if (items.isNotEmpty) {
        developer.log(
          '  - Menemukan ${items.length} perubahan di koleksi $collectionName',
          name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
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
    developer.log(
      'Pengunggahan batch selesai.',
      name: 'SinkronisasiService',
    ); // diubah: Nama log disesuaikan.
  }

  // Fungsi internal untuk mengunduh perubahan dari Firebase ke lokal.
  Future<void> _unduhPerubahan(
    DateTime lastSync,
    Map<String, dynamic> operasiMap,
  ) async {
    developer.log(
      'Mengunduh perubahan sejak $lastSync',
      name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
    );

    for (var collectionName in operasiMap.keys) {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('diperbarui', isGreaterThan: lastSync.toIso8601String())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        developer.log(
          '  - Menemukan ${querySnapshot.docs.length} perubahan di koleksi $collectionName dari Firebase',
          name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
        );
        final op = operasiMap[collectionName];

        final items = querySnapshot.docs
            .map((doc) {
              try {
                final data = doc.data();
                data['id'] ??= int.tryParse(doc.id) ?? doc.id;
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is KategoriOperasi) {
                  return Kategori.fromMap(data);
                }
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is DompetOperasi) {
                  return Dompet.fromMap(data);
                }
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is TransaksiOperasi) {
                  return Transaksi.fromMap(data);
                }
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is PelangganOperasi) {
                  return Pelanggan.fromMap(data);
                }
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is PaketOperasi) {
                  return Paket.fromMap(data);
                }
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is PelangganAktifOperasi) {
                  return PelangganAktif.fromMap(data);
                }
                // diubah: Menggunakan kurung kurawal untuk blok if.
                if (op is KritikSaranOperasi) {
                  return KritikSaran.fromMap(data);
                }
              } catch (e, s) {
                developer.log(
                  'Gagal mem-parsing dokumen ${doc.id} dari koleksi $collectionName',
                  error: e,
                  stackTrace: s,
                  name: 'SinkronisasiService', // diubah: Nama log disesuaikan.
                );
              }
              return null;
            })
            .where((item) => item != null)
            .toList();

        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is KategoriOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Kategori>());
        }
        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is DompetOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Dompet>());
        }
        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is TransaksiOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Transaksi>());
        }
        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is PelangganOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Pelanggan>());
        }
        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is PaketOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<Paket>());
        }
        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is PelangganAktifOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<PelangganAktif>());
        }
        // diubah: Menggunakan kurung kurawal untuk blok if.
        if (op is KritikSaranOperasi) {
          await op.sisipkanAtauPerbaruiBatch(items.cast<KritikSaran>());
        }
      }
    }
    developer.log(
      'Pengunduhan perubahan selesai.',
      name: 'SinkronisasiService',
    ); // diubah: Nama log disesuaikan.
  }
}