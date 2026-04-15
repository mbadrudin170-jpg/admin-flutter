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
  final DompetOperasi _dompetOperasi = DompetOperasi();
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  final PaketOperasi _paketOperasi = PaketOperasi();
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
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

    try {
      final List<Future> futures = [
        _syncKategori(),
        _syncTransaksi(),
        _syncDompet(),
        _syncPelanggan(),
        _syncPaket(),
        _syncPelangganAktif(),
      ];

      final results = await Future.wait(
        futures.map(
          (f) => f.catchError((e, s) {
            developer.log(
              'Error dalam salah satu future sinkronisasi',
              error: e,
              stackTrace: s,
              name: 'FirebaseService',
            );
            return null; // Return null on error to not break Future.wait
          }),
        ),
      );

      // Log hasil untuk setiap sinkronisasi
      developer.log(
        'Sinkronisasi Kategori selesai: ${results[0]}',
        name: 'FirebaseService',
      );
      developer.log(
        'Sinkronisasi Transaksi selesai: ${results[1]}',
        name: 'FirebaseService',
      );
      developer.log(
        'Sinkronisasi Dompet selesai: ${results[2]}',
        name: 'FirebaseService',
      );
      developer.log(
        'Sinkronisasi Pelanggan selesai: ${results[3]}',
        name: 'FirebaseService',
      );
      developer.log(
        'Sinkronisasi Paket selesai: ${results[4]}',
        name: 'FirebaseService',
      );
      developer.log(
        'Sinkronisasi Pelanggan Aktif selesai: ${results[5]}',
        name: 'FirebaseService',
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

  // =========================================================================
  // Sinkronisasi Spesifik
  // =========================================================================

  Future<String> _syncKategori() async {
    final items = await _kategoriOperasi.getKategori();
    await _unggahKategori(items);
    return '${items.length} item Kategori disinkronkan.';
  }

  Future<String> _syncDompet() async {
    final items = await _dompetOperasi.getDompet();
    await _unggahDompet(items);
    return '${items.length} item Dompet disinkronkan.';
  }

  Future<String> _syncTransaksi() async {
    final items = await _transaksiOperasi.getTransaksi();
    await _unggahTransaksi(items);
    return '${items.length} item Transaksi disinkronkan.';
  }

  Future<String> _syncPelanggan() async {
    final items = await _pelangganOperasi.getPelanggan();
    await _unggahPelanggan(items);
    return '${items.length} item Pelanggan disinkronkan.';
  }

  Future<String> _syncPaket() async {
    final items = await _paketOperasi.getPaket();
    await _unggahPaket(items);
    return '${items.length} item Paket disinkronkan.';
  }

  Future<String> _syncPelangganAktif() async {
    final items = await _pelangganAktifOperasi.ambilSemuaPelangganAktif();
    await _unggahPelangganAktif(items);
    return '${items.length} item Pelanggan Aktif disinkronkan.';
  }

  // =========================================================================
  // Logika Unggah (Upload)
  // =========================================================================

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
        // Pastikan ID tidak null
        // PERBAIKAN: Konversi id (int?) ke String
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
        // Pastikan ID tidak null
        batch.set(
          _firestore.collection('pelanggan_aktif').doc(item.id.toString()),
          item.toMap(),
        );
      }
    }
    await batch.commit();
  }
}
