// lib/data/servis/firebase_servis.dart
// File ini bertanggung jawab untuk sinkronisasi data antara database lokal (SQLite)
// dan Firestore. Ini termasuk mengunggah perubahan lokal ke Firebase dan
// mengunduh perubahan dari Firebase ke database lokal.

import 'dart:async';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:admin_wifi/utils/sync_manager.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SyncManager _syncManager = SyncManager();
  Timer? _timer;

  void startSync() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      developer.log('Memulai sinkronisasi periodik...', name: 'FirebaseService');
      sinkronkanSemuaData();
    });
    // Jalankan sinkronisasi segera saat aplikasi dimulai
    sinkronkanSemuaData();
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<void> sinkronkanSemuaData() async {
    developer.log('Memulai sinkronisasi data inkremental...', name: 'FirebaseService');
    final lastSync = await _syncManager.getLastSyncTimestamp();
    final now = DateTime.now();

    final dompetOperasi = DompetOperasi();
    final kategoriOperasi = KategoriOperasi();
    final transaksiOperasi = TransaksiOperasi();
    final pelangganOperasi = PelangganOperasi();
    final paketOperasi = PaketOperasi();
    final pelangganAktifOperasi = PelangganAktifOperasi();

    try {
      // 1. Unggah perubahan lokal ke Firebase
      await _unggahPerubahan(lastSync, {
        'kategori': (await kategoriOperasi.getPerubahan(lastSync)),
        'dompet': (await dompetOperasi.getPerubahan(lastSync)),
        'transaksi': (await transaksiOperasi.getPerubahan(lastSync)),
        'pelanggan': (await pelangganOperasi.getPerubahan(lastSync)),
        'paket': (await paketOperasi.getPerubahan(lastSync)),
        'pelanggan_aktif': (await pelangganAktifOperasi.getPerubahan(lastSync)),
      });

      // 2. Unduh perubahan dari Firebase ke lokal
      await _unduhPerubahan(lastSync, {
        'kategori': kategoriOperasi,
        'dompet': dompetOperasi,
        'transaksi': transaksiOperasi,
        'pelanggan': pelangganOperasi,
        'paket': paketOperasi,
        'pelanggan_aktif': pelangganAktifOperasi,
      });

      // 3. Simpan waktu sinkronisasi yang berhasil
      await _syncManager.setLastSyncTimestamp(now);
      developer.log('Sinkronisasi inkremental berhasil diselesaikan.', name: 'FirebaseService');

    } catch (e, s) {
      developer.log(
        'Kesalahan besar saat sinkronisasi inkremental',
        error: e,
        stackTrace: s,
        name: 'FirebaseService',
      );
    }
  }

  Future<void> _unggahPerubahan(DateTime lastSync, Map<String, List<dynamic>> dataPerubahan) async {
    developer.log('Mengunggah perubahan sejak $lastSync', name: 'FirebaseService');
    final batch = _firestore.batch();

    dataPerubahan.forEach((collectionName, items) {
      if (items.isNotEmpty) {
        developer.log('  - Menemukan ${items.length} perubahan di koleksi $collectionName', name: 'FirebaseService');
        for (var item in items) {
          final docRef = _firestore.collection(collectionName).doc(item.id.toString());
          batch.set(docRef, item.toMap());
        }
      }
    });

    await batch.commit();
    developer.log('Pengunggahan batch selesai.', name: 'FirebaseService');
  }

 Future<void> _unduhPerubahan(DateTime lastSync, Map<String, dynamic> operasiMap) async {
    developer.log('Mengunduh perubahan sejak $lastSync', name: 'FirebaseService');

    for (var collectionName in operasiMap.keys) {
        final querySnapshot = await _firestore
            .collection(collectionName)
            .where('diperbarui', isGreaterThan: lastSync.toIso8601String())
            .get();

        if (querySnapshot.docs.isNotEmpty) {
            developer.log('  - Menemukan ${querySnapshot.docs.length} perubahan di koleksi $collectionName dari Firebase', name: 'FirebaseService');
            final op = operasiMap[collectionName];
            final items = querySnapshot.docs.map((doc) {
                final data = doc.data();
                // Pastikan ID disetel dari ID dokumen Firebase
                data['id'] ??= int.tryParse(doc.id) ?? doc.id; 
                if (op is KategoriOperasi) {
                  return Kategori.fromMap(data);
                }
                if (op is DompetOperasi) {
                  return Dompet.fromMap(data);
                }
                if (op is TransaksiOperasi) {
                  return Transaksi.fromMap(data);
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
                return null;
            }).where((item) => item != null).toList();

            // --- PERBAIKAN: Cast list ke tipe yang benar ---
            if (op is KategoriOperasi) {
              await op.sisipkanAtauPerbaruiBatch(items.cast<Kategori>());
            } else if (op is DompetOperasi) {
              await op.sisipkanAtauPerbaruiBatch(items.cast<Dompet>());
            } else if (op is TransaksiOperasi) {
              await op.sisipkanAtauPerbaruiBatch(items.cast<Transaksi>());
            } else if (op is PelangganOperasi) {
              await op.sisipkanAtauPerbaruiBatch(items.cast<Pelanggan>());
            } else if (op is PaketOperasi) {
              await op.sisipkanAtauPerbaruiBatch(items.cast<Paket>());
            } else if (op is PelangganAktifOperasi) {
              await op.sisipkanAtauPerbaruiBatch(items.cast<PelangganAktif>());
            }
        }
    }
    developer.log('Pengunduhan perubahan selesai.', name: 'FirebaseService');
}


  Future<void> hapusPelangganAktif(String id) async {
    try {
      await _firestore.collection('pelanggan_aktif').doc(id).delete();
      developer.log(
        'Pelanggan aktif dengan ID: $id berhasil dihapus dari Firebase.',
        name: 'FirebaseService',
      );
    } catch (e, s) {
      developer.log(
        'Gagal menghapus pelanggan aktif dari Firebase.',
        error: e,
        stackTrace: s,
        name: 'FirebaseService',
      );
      rethrow;
    }
  }
}
