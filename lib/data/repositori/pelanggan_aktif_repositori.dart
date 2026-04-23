// path: lib/data/repositori/pelanggan_aktif_repositori.dart

// File ini bertanggung jawab untuk operasi CRUD (Create, Read, Update, Delete)
// yang berhubungan dengan data pelanggan aktif di Firebase Firestore.

import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';

// Kelas untuk mengelola operasi data pelanggan aktif dengan Firestore.
class PelangganAktifRepositori {
  // Mendapatkan instance dari Cloud Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Menentukan nama koleksi di Firestore.
  final String _collectionName = 'pelanggan_aktif';

  /// Menghapus data pelanggan aktif dari Firestore berdasarkan ID.
  ///
  /// [id] adalah ID unik dari dokumen pelanggan aktif yang akan dihapus.
  /// Fungsi ini akan mencoba menghapus dokumen dan mencatat hasilnya.
  Future<void> hapusPelangganAktif(String id) async {
    try {
      // Membuat referensi ke dokumen yang akan dihapus.
      final docRef = _firestore.collection(_collectionName).doc(id);
      // Menghapus dokumen dari Firestore.
      await docRef.delete();
      // Mencatat log keberhasilan.
      developer.log(
        'Pelanggan aktif dengan ID: $id berhasil dihapus dari Firestore.',
        name: 'PelangganAktifRepositori',
      );
    } catch (e, s) {
      // Mencatat log jika terjadi error saat penghapusan.
      developer.log(
        'Gagal menghapus pelanggan aktif dengan ID: $id dari Firestore.',
        error: e,
        stackTrace: s,
        name: 'PelangganAktifRepositori',
      );
      // Melemparkan kembali error untuk ditangani oleh pemanggil.
      rethrow;
    }
  }
}
