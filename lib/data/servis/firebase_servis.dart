
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

  // Operasi Lokal
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();
  final DompetOperasi _dompetOperasi = DompetOperasi();
  final PaketOperasi _paketOperasi = PaketOperasi();
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();

  // =========================================================================
  // Generic Sync Logic
  // =========================================================================

  Future<void> _sinkronkan<T>({
    required String namaKoleksi,
    required Future<List<T>> Function() unduhDariFirebase,
    required Future<void> Function(List<T>) unggahKeFirebase,
    required Future<List<T>> Function() getDariLokal,
    required Future<void> Function() hapusLokal,
    required Future<void> Function(T) createLokal,
  }) async {
    developer.log('Memulai sinkronisasi untuk: $namaKoleksi...', name: 'admin.firebase');
    try {
      List<T> dataFirebase = await unduhDariFirebase();

      if (dataFirebase.isEmpty) {
        developer.log('Tidak ada data di Firebase untuk $namaKoleksi. Mengunggah dari SQLite...', name: 'admin.firebase');
        List<T> dataLokal = await getDariLokal();
        if (dataLokal.isNotEmpty) {
          await unggahKeFirebase(dataLokal);
          developer.log('Berhasil mengunggah $namaKoleksi ke Firebase.', name: 'admin.firebase');
        } else {
          developer.log('Tidak ada data $namaKoleksi di lokal untuk diunggah.', name: 'admin.firebase');
        }
      } else {
        developer.log('Data $namaKoleksi ditemukan di Firebase. Memperbarui SQLite...', name: 'admin.firebase');
        await hapusLokal();
        for (var item in dataFirebase) {
          await createLokal(item);
        }
        developer.log('SQLite untuk $namaKoleksi diperbarui dari Firebase.', name: 'admin.firebase');
      }
    } catch (e, s) {
      developer.log('Error saat sinkronisasi $namaKoleksi', name: 'admin.firebase', error: e, stackTrace: s);
    }
  }

  // =========================================================================
  // Kategori
  // =========================================================================

  Future<List<Kategori>> _unduhKategori() async {
    QuerySnapshot snapshot = await _firestore.collection('kategori').get();
    return snapshot.docs.map((doc) => Kategori.fromMap(doc.data() as Map<String, dynamic>..['id'] = doc.id)).toList();
  }

  Future<void> _unggahKategori(List<Kategori> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('kategori').doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  // =========================================================================
  // Dompet
  // =========================================================================

  Future<List<Dompet>> _unduhDompet() async {
    QuerySnapshot snapshot = await _firestore.collection('dompet').get();
    return snapshot.docs.map((doc) => Dompet.fromMap(doc.data() as Map<String, dynamic>..['id'] = doc.id)).toList();
  }

  Future<void> _unggahDompet(List<Dompet> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('dompet').doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  // =========================================================================
  // Paket
  // =========================================================================

  Future<List<Paket>> _unduhPaket() async {
    QuerySnapshot snapshot = await _firestore.collection('paket').get();
    return snapshot.docs.map((doc) => Paket.fromMap(doc.data() as Map<String, dynamic>..['id'] = doc.id)).toList();
  }

  Future<void> _unggahPaket(List<Paket> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('paket').doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  // =========================================================================
  // Pelanggan
  // =========================================================================

  Future<List<Pelanggan>> _unduhPelanggan() async {
    QuerySnapshot snapshot = await _firestore.collection('pelanggan').get();
    return snapshot.docs.map((doc) => Pelanggan.fromMap(doc.data() as Map<String, dynamic>..['id'] = doc.id)).toList();
  }

  Future<void> _unggahPelanggan(List<Pelanggan> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('pelanggan').doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  // =========================================================================
  // Pelanggan Aktif
  // =========================================================================

  Future<List<PelangganAktif>> _unduhPelangganAktif() async {
    QuerySnapshot snapshot = await _firestore.collection('pelanggan_aktif').get();
    return snapshot.docs.map((doc) => PelangganAktif.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> _unggahPelangganAktif(List<PelangganAktif> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('pelanggan_aktif').doc(item.id.toString()), item.toMap());
    }
    await batch.commit();
  }

  // =========================================================================
  // Transaksi
  // =========================================================================

  Future<List<Transaksi>> _unduhTransaksi() async {
    QuerySnapshot snapshot = await _firestore.collection('transaksi').get();
    return snapshot.docs.map((doc) => Transaksi.fromMap(doc.data() as Map<String, dynamic>..['id'] = doc.id)).toList();
  }

  Future<void> _unggahTransaksi(List<Transaksi> items) async {
    final batch = _firestore.batch();
    for (var item in items) {
      batch.set(_firestore.collection('transaksi').doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  // =========================================================================
  // Main Public Sync Method
  // =========================================================================

  Future<void> sinkronkanSemuaData() async {
    developer.log('MEMULAI SINKRONISASI DATA GLOBAL', name: 'admin.firebase');
    
    await _sinkronkan<Kategori>(
      namaKoleksi: 'Kategori',
      unduhDariFirebase: _unduhKategori,
      unggahKeFirebase: _unggahKategori,
      getDariLokal: _kategoriOperasi.getKategori,
      hapusLokal: _kategoriOperasi.hapusSemuaKategori,
      createLokal: _kategoriOperasi.createKategori,
    );

    await _sinkronkan<Dompet>(
      namaKoleksi: 'Dompet',
      unduhDariFirebase: _unduhDompet,
      unggahKeFirebase: _unggahDompet,
      getDariLokal: _dompetOperasi.getDompet,
      hapusLokal: _dompetOperasi.hapusSemuaDompet,
      createLokal: _dompetOperasi.createDompet,
    );

    await _sinkronkan<Paket>(
      namaKoleksi: 'Paket',
      unduhDariFirebase: _unduhPaket,
      unggahKeFirebase: _unggahPaket,
      getDariLokal: _paketOperasi.getPaket,
      hapusLokal: _paketOperasi.hapusSemuaPaket,
      createLokal: _paketOperasi.createPaket,
    );

    await _sinkronkan<Pelanggan>(
      namaKoleksi: 'Pelanggan',
      unduhDariFirebase: _unduhPelanggan,
      unggahKeFirebase: _unggahPelanggan,
      getDariLokal: _pelangganOperasi.getPelanggan,
      hapusLokal: _pelangganOperasi.hapusSemuaPelanggan,
      createLokal: _pelangganOperasi.createPelanggan,
    );
    
    await _sinkronkan<PelangganAktif>(
      namaKoleksi: 'PelangganAktif',
      unduhDariFirebase: _unduhPelangganAktif,
      unggahKeFirebase: _unggahPelangganAktif,
      getDariLokal: _pelangganAktifOperasi.getPelangganAktif,
      hapusLokal: _pelangganAktifOperasi.hapusSemuaPelangganAktif,
      createLokal: _pelangganAktifOperasi.createPelangganAktif,
    );

    await _sinkronkan<Transaksi>(
      namaKoleksi: 'Transaksi',
      unduhDariFirebase: _unduhTransaksi,
      unggahKeFirebase: _unggahTransaksi,
      getDariLokal: _transaksiOperasi.getTransaksi,
      hapusLokal: _transaksiOperasi.hapusSemuaTransaksi,
      createLokal: _transaksiOperasi.createTransaksi,
    );

    developer.log('SINKRONISASI DATA GLOBAL SELESAI', name: 'admin.firebase');
  }
}
