// path: lib/data/repositori/pelanggan_aktif_repositori.dart
// Repositori ini bertanggung jawab untuk operasi data pelanggan aktif
// yang berinteraksi langsung dengan sumber data eksternal seperti Firebase.

// ditambah: Impor pustaka developer untuk logging.
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';

// Repositori untuk mengelola data pelanggan aktif di Firebase.
class PelangganAktifRepositori {
  // Mendapatkan instance dari Cloud Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Koleksi pelanggan aktif di Firestore.
  final String _collectionPath = 'pelanggan_aktif';

  // Menghapus pelanggan aktif dari Firestore berdasarkan ID.
  Future<void> hapusPelangganAktif(String id) async {
    try {
      // ditambah: Log aksi penghapusan.
      developer.log(
        'Menghapus pelanggan aktif dari Firestore dengan ID: $id',
        name: 'admin_wifi.repositori.pelanggan_aktif',
      );
      // Menghapus dokumen dari koleksi 'pelanggan_aktif' berdasarkan ID.
      await _firestore.collection(_collectionPath).doc(id).delete();
      developer.log(
        'Pelanggan aktif dengan ID: $id berhasil dihapus dari Firestore',
        name: 'admin_wifi.repositori.pelanggan_aktif',
      );
    } catch (e, s) {
      // ditambah: Log jika terjadi error saat penghapusan.
      developer.log(
        'Gagal menghapus pelanggan aktif dari Firestore',
        name: 'admin_wifi.repositori.pelanggan_aktif',
        error: e,
        stackTrace: s,
      );
      // Melempar kembali error agar bisa ditangani oleh lapisan di atasnya.
      rethrow;
    }
  }
}
