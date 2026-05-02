// Path: lib/data/services/sinkronisasi_database.dart
import 'dart:async';
import 'dart:developer' as developer;

import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/operasi/riwayat_langganan_operasi.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/model/enum/sync_status.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';

class SinkronisasiDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  final PelangganAktifOperasi _pelangganAktifOp = PelangganAktifOperasi();
  final DompetOperasi _dompetOp = DompetOperasi();
  final KategoriOperasi _kategoriOp = KategoriOperasi();
  final KritikSaranOperasi _kritikSaranOp = KritikSaranOperasi();
  final PaketOperasi _paketOp = PaketOperasi();
  final PelangganOperasi _pelangganOp = PelangganOperasi();
  final RiwayatLanggananOperasi _riwayatLanggananOp = RiwayatLanggananOperasi();
  final TransaksiOperasi _transaksiOp = TransaksiOperasi();

  static const String _lastSyncKey = 'last_sync_timestamp';

  void startSync() {
    developer.log(
      '▶️ Memulai Layanan Sinkronisasi Hibrida...',
      name: 'SyncService',
    );
    sinkronkanData();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (!results.contains(ConnectivityResult.none)) {
        developer.log(
          '🔗 Koneksi internet terdeteksi. Memulai sinkronisasi...',
          name: 'SyncService',
        );
        sinkronkanData();
      }
    });
  }

  void dispose() {
    developer.log('⏹️ Menghentikan Layanan Sinkronisasi.', name: 'SyncService');
    _connectivitySubscription?.cancel();
  }

  Future<void> sinkronkanData() async {
    if (_isSyncing) {
      developer.log(
        '🔄 Sinkronisasi sedang berjalan, permintaan baru diabaikan.',
        name: 'SyncService',
      );
      return;
    }
    if (!(await _pelangganAktifOp.isDeviceConnected())) {
      developer.log(
        '🔌 Tidak ada koneksi internet. Sinkronisasi ditunda.',
        name: 'SyncService',
      );
      return;
    }

    _isSyncing = true;
    developer.log(
      '🚀 Memulai proses sinkronisasi hibrida...',
      name: 'SyncService',
    );
    try {
      final lastSync = await _getLastSyncTimestamp();
      await _unggahPerubahan(lastSync);
      await _unduhPerubahan(lastSync);
      await _setLastSyncTimestamp(DateTime.now());
      developer.log(
        '✅ Sinkronisasi hibrida berhasil diselesaikan.',
        name: 'SyncService',
      );
    } catch (e, s) {
      developer.log(
        '❌ Kesalahan besar saat sinkronisasi!',
        error: e,
        stackTrace: s,
        name: 'SyncService',
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _unggahPerubahan(DateTime lastSync) async {
    developer.log(
      '📤 Mengumpulkan semua data lokal untuk diunggah...',
      name: 'SyncService.Upload',
    );
    final batch = _firestore.batch();
    int totalChanges = 0;

    final pelangganAktifChanges = await _pelangganAktifOp
        .ambilDataUntukSinkronisasi();
    for (final item in pelangganAktifChanges) {
      final docRef = _firestore.collection('pelanggan_aktif').doc(item.id);
      if (item.syncStatus == SyncStatus.deleted) {
        batch.delete(docRef);
      } else {
        batch.set(docRef, item.toMap());
      }
    }
    totalChanges += pelangganAktifChanges.length;

    final Map<String, List<dynamic>> otherChanges = {
      'dompet': await _dompetOp.getPerubahan(lastSync),
      'kategori': await _kategoriOp.getPerubahan(lastSync),
      'kritik_saran': await _kritikSaranOp.getPerubahan(lastSync),
      'paket': await _paketOp.getPerubahan(lastSync),
      'pelanggan': await _pelangganOp.getPerubahan(lastSync),
      'riwayat_langganan': await _riwayatLanggananOp.getPerubahan(lastSync),
      'transaksi': await _transaksiOp.getPerubahan(lastSync),
    };

    otherChanges.forEach((collectionName, items) {
      for (var item in items) {
        final docRef = _firestore
            .collection(collectionName)
            .doc(item.id.toString());
        batch.set(docRef, item.toMap());
        totalChanges++;
      }
    });

    if (totalChanges == 0) {
      developer.log(
        '📤 Tidak ada data lokal untuk diunggah.',
        name: 'SyncService.Upload',
      );
      return;
    }
    try {
      developer.log(
        '📤 Mengunggah total $totalChanges perubahan ke Firebase...',
        name: 'SyncService.Upload',
      );
      await batch.commit();

      developer.log(
        '✅ UNGGAH SUKSES: Perubahan berhasil dikirim ke Firebase.',
        name: 'SyncService.Upload',
      );
    } catch (e, s) {
      // Jika batch.commit() gagal, kode ini akan dijalankan
      developer.log(
        '❌ GAGAL MENGUNGGAH: Terjadi error saat mengirim data ke Firebase.',
        name: 'SyncService.Error',
        error: e, // Ini akan menampilkan pesan error (mis: "PERMISSION_DENIED")
        stackTrace: s, // Ini menunjukkan di mana error terjadi
      );
      return; // HENTIKAN proses jika upload gagal!
    }

    for (final item in pelangganAktifChanges) {
      if (item.syncStatus == SyncStatus.deleted) {
        await _pelangganAktifOp.hapusLokalPermanen(item.id);
      } else {
        await _pelangganAktifOp.tandaiSudahSinkron(item.id);
      }
    }
    developer.log('📤 Pengunggahan selesai.', name: 'SyncService.Upload');
  }

  Future<void> _unduhPerubahan(DateTime lastSync) async {
    developer.log(
      '📥 Mengunduh data dari semua koleksi sejak $lastSync',
      name: 'SyncService.Download',
    );

    final Map<String, dynamic> collections = {
      'pelanggan_aktif': _pelangganAktifOp,
      'dompet': _dompetOp,
      'kategori': _kategoriOp,
      'kritik_saran': _kritikSaranOp,
      'paket': _paketOp,
      'pelanggan': _pelangganOp,
      'riwayat_langganan': _riwayatLanggananOp,
      'transaksi': _transaksiOp,
    };
    final firestoreTimestamp = Timestamp.fromDate(lastSync);
    for (final collectionName in collections.keys) {
      final query = _firestore
          .collection(collectionName)
          .where('diperbarui', isGreaterThan: firestoreTimestamp);

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) continue;

      developer.log(
        '📥 Menemukan ${snapshot.docs.length} item baru di $collectionName.',
        name: 'SyncService.Download',
      );
      final op = collections[collectionName];

      final List<dynamic> items = snapshot.docs
          .map((doc) {
            final data = doc.data();
            switch (collectionName) {
              case 'pelanggan_aktif':
                return PelangganAktif.fromMap(data);
              case 'dompet':
                return Dompet.fromMap(data);
              case 'kategori':
                return Kategori.fromMap(data);
              case 'kritik_saran':
                return KritikSaranModel.fromMap(data);
              case 'paket':
                return Paket.fromMap(data);
              case 'pelanggan':
                return Pelanggan.fromMap(data);
              case 'riwayat_langganan':
                return RiwayatLanggananModel.fromMap(data);
              case 'transaksi':
                return TransaksiModel.fromMap(data);
              default:
                return null;
            }
          })
          .where((item) => item != null)
          .toList();

      switch (collectionName) {
        case 'pelanggan_aktif':
          await op.sisipkanAtauPerbaruiBatch(items.cast<PelangganAktif>());
          break;
        case 'dompet':
          await op.sisipkanAtauPerbaruiBatch(items.cast<Dompet>());
          break;
        case 'kategori':
          await op.sisipkanAtauPerbaruiBatch(items.cast<Kategori>());
          break;
        case 'kritik_saran':
          await op.sisipkanAtauPerbaruiBatch(items.cast<KritikSaranModel>());
          break;
        case 'paket':
          await op.sisipkanAtauPerbaruiBatch(items.cast<Paket>());
          break;
        case 'pelanggan':
          await op.sisipkanAtauPerbaruiBatch(items.cast<Pelanggan>());
          break;
        case 'riwayat_langganan':
          await op.sisipkanAtauPerbaruiBatch(
            items.cast<RiwayatLanggananModel>(),
          );
          break;
        case 'transaksi':
          await op.sisipkanAtauPerbaruiBatch(items.cast<TransaksiModel>());
          break;
      }
    }
    developer.log(
      '📥 Proses pengunduhan selesai.',
      name: 'SyncService.Download',
    );
  }

  // [FIXED] Fungsi ini sekarang tahan terhadap tipe data lama (int).
  Future<DateTime> _getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    // Baca sebagai Object untuk memeriksa tipe datanya terlebih dahulu
    final dynamic timestampValue = prefs.get(_lastSyncKey);

    if (timestampValue is String) {
      // Format baru (String ISO 8601)
      return DateTime.parse(timestampValue);
    } else if (timestampValue is int) {
      // Format lama (int, millisecondsSinceEpoch)
      return DateTime.fromMillisecondsSinceEpoch(timestampValue);
    } else {
      // Jika tidak ada atau format tidak dikenal, mulai dari awal.
      return DateTime(1970);
    }
  }

  Future<void> _setLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    // Selalu simpan dalam format string baru yang konsisten.
    await prefs.setString(_lastSyncKey, timestamp.toIso8601String());
  }
}
