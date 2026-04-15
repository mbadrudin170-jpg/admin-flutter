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

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;

  void startSync() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      developer.log(
        'Memulai sinkronisasi periodic...',
        name: 'FirebaseService',
      );
      sinkronkanSemuaData();
    });
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<void> sinkronkanSemuaData() async {
    developer.log('Sinkronisasi semua data dimulai', name: 'FirebaseService');

    // Pindahkan inisialisasi ke sini untuk memutus circular dependency
    final dompetOperasi = DompetOperasi();
    final kategoriOperasi = KategoriOperasi();
    final transaksiOperasi = TransaksiOperasi();
    final pelangganOperasi = PelangganOperasi();
    final paketOperasi = PaketOperasi();
    final pelangganAktifOperasi = PelangganAktifOperasi();

    try {
      final List<Future> futures = [
        _syncKategori(kategoriOperasi),
        _syncTransaksi(transaksiOperasi),
        _syncDompet(dompetOperasi),
        _syncPelanggan(pelangganOperasi),
        _syncPaket(paketOperasi),
        _syncPelangganAktif(pelangganAktifOperasi),
      ];

      await Future.wait(
        futures.map(
          (f) => f.catchError((e, s) {
            developer.log(
              'Error dalam salah satu future sinkronisasi',
              error: e,
              stackTrace: s,
              name: 'FirebaseService',
            );
            return null;
          }),
        ),
      );
      developer.log('Sinkronisasi semua data selesai', name: 'FirebaseService');
    } catch (e, s) {
      developer.log(
        'Kesalahan besar saat sinkronisasi',
        error: e,
        stackTrace: s,
        name: 'FirebaseService',
      );
    }
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

  // ... (sisa metode sinkronisasi diubah untuk menerima operasi sebagai parameter)

  Future<String> _syncKategori(KategoriOperasi op) async {
    final items = await op.getKategori();
    await _unggahKategori(items);
    return '${items.length} item Kategori disinkronkan.';
  }

  Future<String> _syncDompet(DompetOperasi op) async {
    final items = await op.getDompet();
    await _unggahDompet(items);
    return '${items.length} item Dompet disinkronkan.';
  }

  Future<String> _syncTransaksi(TransaksiOperasi op) async {
    final items = await op.getTransaksi();
    await _unggahTransaksi(items);
    return '${items.length} item Transaksi disinkronkan.';
  }

  Future<String> _syncPelanggan(PelangganOperasi op) async {
    final items = await op.getPelanggan();
    await _unggahPelanggan(items);
    return '${items.length} item Pelanggan disinkronkan.';
  }

  Future<String> _syncPaket(PaketOperasi op) async {
    final items = await op.getPaket();
    await _unggahPaket(items);
    return '${items.length} item Paket disinkronkan.';
  }

  Future<String> _syncPelangganAktif(PelangganAktifOperasi op) async {
    final items = await op.ambilSemuaPelangganAktif();
    await _unggahPelangganAktif(items);
    return '${items.length} item Pelanggan Aktif disinkronkan.';
  }

  // ... (metode unggah tetap sama)

  Future<void> _unggahKategori(List<Kategori> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('kategori').doc(item.nama), item.toMap());
    }
    await batch.commit();
  }

  Future<void> _unggahDompet(List<Dompet> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(
        _firestore.collection('dompet').doc(item.namaDompet),
        item.toMap(),
      );
    }
    await batch.commit();
  }

  Future<void> _unggahTransaksi(List<Transaksi> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(
        _firestore.collection('transaksi').doc(item.id.toString()),
        item.toMap(),
      );
    }
    await batch.commit();
  }

  Future<void> _unggahPelanggan(List<Pelanggan> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('pelanggan').doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  Future<void> _unggahPaket(List<Paket> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      if (item.id != null) {
        batch.set(
          _firestore.collection('paket').doc(item.id.toString()),
          item.toMap(),
        );
      }
    }
    await batch.commit();
  }

  Future<void> _unggahPelangganAktif(List<PelangganAktif> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      if (item.id != null) {
        batch.set(
          _firestore.collection('pelanggan_aktif').doc(item.id.toString()),
          item.toMap(),
        );
      }
    }
    await batch.commit();
  }
}
