// lib/data/servis/firebase_servis.dart
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/operasi/kategori_operasi.dart';
import 'package:myapp/model/kategori.dart'; // <--- PERBAIKAN: Menggunakan path yang benar

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();

  // Mengunduh semua data dari koleksi 'kategori'
  Future<List<Kategori>> unduhKategori() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('kategori').get();
      return snapshot.docs.map((doc) {
        // Pastikan untuk menangani kemungkinan ID yang tidak ada atau salah
        final data = doc.data() as Map<String, dynamic>;
        return Kategori.fromMap(data);
      }).toList();
    } catch (e, s) {
      developer.log('Error mengunduh kategori', name: 'myapp.firebase', error: e, stackTrace: s);
      return [];
    }
  }

  // Mengunggah daftar kategori ke Firestore
  Future<void> unggahKategori(List<Kategori> kategoriList) async {
    final WriteBatch batch = _firestore.batch();
    for (var kategori in kategoriList) {
      // Gunakan ID unik dari objek kategori jika tersedia, jika tidak, biarkan Firestore yang membuatnya
      DocumentReference docRef = _firestore.collection('kategori').doc(kategori.id?.toString());
      batch.set(docRef, kategori.toMap());
    }
    try {
      await batch.commit();
    } catch (e, s) {
      developer.log('Error mengunggah kategori', name: 'myapp.firebase', error: e, stackTrace: s);
    }
  }

  // Membaca semua kategori dari SQLite dan mengunggahnya ke Firebase
  Future<void> sinkronkanKategoriKeFirebase() async {
    try {
      List<Kategori> allKategori = await _kategoriOperasi.ambilSemuaKategori(); // <--- PERBAIKAN: Nama metode yang benar
      await unggahKategori(allKategori);
      developer.log('Sinkronisasi kategori ke Firebase berhasil.', name: 'myapp.firebase');
    } catch (e, s) {
      developer.log('Gagal melakukan sinkronisasi kategori', name: 'myapp.firebase', error: e, stackTrace: s);
    }
  }

  // Sinkronisasi data antara Firebase dan SQLite
  Future<void> sinkronkanKategori() async {
    developer.log('Memulai sinkronisasi kategori...', name: 'myapp.firebase');
    List<Kategori> kategoriFirebase = await unduhKategori();

    if (kategoriFirebase.isEmpty) {
      developer.log('Tidak ada data kategori di Firebase. Mengunggah dari SQLite...', name: 'myapp.firebase');
      await sinkronkanKategoriKeFirebase();
    } else {
      developer.log('Data kategori ditemukan di Firebase. Memperbarui SQLite...', name: 'myapp.firebase');
      await _kategoriOperasi.hapusSemuaKategori(); // <--- PERBAIKAN: Nama metode yang benar
      for (var kategori in kategoriFirebase) {
        await _kategoriOperasi.buatKategori(kategori);
      }
      developer.log('SQLite diperbarui dengan data dari Firebase.', name: 'myapp.firebase');
    }
  }
}
