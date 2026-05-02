import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'dart:developer' as developer;

class SinkronisasiDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();

  Future<void> sinkronisasiData() async {
    developer.log(
      'Memulai sinkronisasi data dari Firebase.',
      name: 'SinkronisasiDatabase',
    );
    try {
      await _sinkronisasiPelanggan();
      await _sinkronisasiKategori();
      await _sinkronisasiTransaksi();
      await _sinkronisasiPelangganAktif();
      developer.log(
        'Sinkronisasi data berhasil.',
        name: 'SinkronisasiDatabase',
      );
    } catch (e, s) {
      developer.log(
        'Gagal melakukan sinkronisasi data.',
        name: 'SinkronisasiDatabase.Error',
        error: e,
        stackTrace: s,
      );
      // Rethrow the exception to be handled by the caller if needed
      rethrow;
    }
  }

  Future<void> _sinkronisasiPelanggan() async {
    final snapshot = await _firestore.collection('pelanggan').get();
    final List<Pelanggan> pelanggans = snapshot.docs
        .map((doc) => Pelanggan.fromMap(doc.data()))
        .toList();
    for (final pelanggan in pelanggans) {
      await _pelangganOperasi.createPelanggan(pelanggan);
    }
    developer.log(
      '${pelanggans.length} pelanggan disinkronkan.',
      name: 'SinkronisasiDatabase',
    );
  }

  Future<void> _sinkronisasiKategori() async {
    final snapshot = await _firestore.collection('kategori').get();
    final List<Kategori> kategoris = snapshot.docs
        .map((doc) => Kategori.fromMap(doc.data()))
        .toList();
    for (final kategori in kategoris) {
      await _kategoriOperasi.create(kategori);
    }
    developer.log(
      '${kategoris.length} kategori disinkronkan.',
      name: 'SinkronisasiDatabase',
    );
  }

  Future<void> _sinkronisasiTransaksi() async {
    final snapshot = await _firestore.collection('transaksi').get();
    final List<TransaksiModel> transaksis = snapshot.docs
        .map((doc) => TransaksiModel.fromMap(doc.data()))
        .toList();
    for (final transaksi in transaksis) {
      await _transaksiOperasi.tambahTransaksi(transaksi);
    }
    developer.log(
      '${transaksis.length} transaksi disinkronkan.',
      name: 'SinkronisasiDatabase',
    );
  }

  Future<void> _sinkronisasiPelangganAktif() async {
    final snapshot = await _firestore.collection('pelanggan_aktif').get();
    final List<PelangganAktif> pelangganAktifs = snapshot.docs
        .map((doc) => PelangganAktif.fromMap(doc.data()))
        .toList();
    for (final pelangganAktif in pelangganAktifs) {
      await _pelangganAktifOperasi.createPelangganAktif(pelangganAktif);
    }
    developer.log(
      '${pelangganAktifs.length} pelanggan aktif disinkronkan.',
      name: 'SinkronisasiDatabase',
    );
  }
}
