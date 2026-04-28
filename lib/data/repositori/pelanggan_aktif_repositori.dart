// path: lib/data/repositori/pelanggan_aktif_repositori.dart
// Repositori ini bertanggung jawab untuk operasi data pelanggan aktif
// yang berinteraksi langsung dengan sumber data eksternal seperti Firebase.

import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';

// Repositori untuk mengelola data pelanggan aktif di Firebase.
class PelangganAktifRepositori {
  // Mendapatkan instance dari Cloud Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Koleksi pelanggan aktif di Firestore.
  final String _collectionPath = 'pelanggan_aktif';

  // Menambah atau memperbarui pelanggan aktif di Firestore.
  Future<void> simpanPelangganAktif(PelangganAktif pelanggan) async {
    try {
      developer.log(
        'Menyimpan pelanggan aktif ke Firestore dengan ID: ${pelanggan.id}',
        name: 'admin_wifi.repositori.pelanggan_aktif',
      );
      // Menggunakan set dengan merge:true agar bisa untuk menambah dan update.
      await _firestore
          .collection(_collectionPath)
          .doc(pelanggan.id)
          .set(pelanggan.toMap(), SetOptions(merge: true));
      developer.log(
        'Pelanggan aktif dengan ID: ${pelanggan.id} berhasil disimpan di Firestore',
        name: 'admin_wifi.repositori.pelanggan_aktif',
      );
    } catch (e, s) {
      developer.log(
        'Gagal menyimpan pelanggan aktif ke Firestore',
        name: 'admin_wifi.repositori.pelanggan_aktif',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  // Menghapus pelanggan aktif dari Firestore berdasarkan ID.
  Future<void> hapusPelangganAktif(String id) async {
    try {
      developer.log(
        'Menghapus pelanggan aktif dari Firestore dengan ID: $id',
        name: 'admin_wifi.repositori.pelanggan_aktif',
      );
      await _firestore.collection(_collectionPath).doc(id).delete();
      developer.log(
        'Pelanggan aktif dengan ID: $id berhasil dihapus dari Firestore',
        name: 'admin_wifi.repositori.pelanggan_aktif',
      );
    } catch (e, s) {
      developer.log(
        'Gagal menghapus pelanggan aktif dari Firestore',
        name: 'admin_wifi.repositori.pelanggan_aktif',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
