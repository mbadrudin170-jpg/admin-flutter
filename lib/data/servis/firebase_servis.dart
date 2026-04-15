// lib/data/servis/firebase_servis.dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/data/operasi/dompet_operasi.dart';
import 'package:admin/data/operasi/kategori_operasi.dart';
import 'package:admin/data/operasi/paket_operasi.dart';
import 'package:admin/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin/data/operasi/pelanggan_operasi.dart';
import 'package:admin/data/operasi/transaksi_operasi.dart';
import 'package:admin/model/dompet_model.dart';
import 'package:admin/model/kategori_model.dart';
import 'package:admin/model/paket_model.dart';
import 'package:admin/model/pelanggan_model.dart';
import 'package:admin/model/pelanggan_aktif_model.dart';
import 'package:admin/model/transaksi_model.dart';
import 'package:admin/utils/sync_manager.dart';

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
        // Perbaikan: Gunakan 'diperbarui'
        final querySnapshot = await _firestore
            .collection(collectionName)
            .where('diperbarui', isGreaterThan: lastSync.toIso8601String())
            .get();

        if (querySnapshot.docs.isNotEmpty) {
            developer.log('  - Menemukan ${querySnapshot.docs.length} perubahan di koleksi $collectionName dari Firebase', name: 'FirebaseService');
            final op = operasiMap[collectionName];
            final items = querySnapshot.docs.map((doc) {
                if (op is KategoriOperasi) return Kategori.fromMap(doc.data());
                if (op is DompetOperasi) return Dompet.fromMap(doc.data());
                if (op is TransaksiOperasi) return Transaksi.fromMap(doc.data());
                if (op is PelangganOperasi) return Pelanggan.fromMap(doc.data());
                if (op is PaketOperasi) return Paket.fromMap(doc.data());
                if (op is PelangganAktifOperasi) return PelangganAktif.fromMap(doc.data());
                return null;
            }).where((item) => item != null).toList();

            await op.sisipkanAtauPerbaruiBatch(items);
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
