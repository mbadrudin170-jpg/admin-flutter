// lib/data/servis/firebase_servis.dart
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/operasi/kategori_operasi.dart';
import 'package:myapp/model/kategori.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();

  // Mengunduh semua data dari koleksi 'kategori'
  Future<List<Kategori>> unduhKategori() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('kategori').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Set ID dokumen dari Firestore ke objek Kategori
        data['id'] = doc.id;
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
      // Jika ID ada, gunakan, jika tidak, biarkan Firestore membuatnya
      DocumentReference docRef = _firestore.collection('kategori').doc(kategori.id);
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
      // Menggunakan nama metode yang benar dari KategoriOperasi
      List<Kategori> allKategori = await _kategoriOperasi.getKategori();
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
      // Menggunakan metode baru hapusSemuaKategori
      await _kategoriOperasi.hapusSemuaKategori();
      for (var kategori in kategoriFirebase) {
        // Menggunakan nama metode yang benar dari KategoriOperasi
        await _kategoriOperasi.createKategori(kategori);
      }
      developer.log('SQLite diperbarui dengan data dari Firebase.', name: 'myapp.firebase');
    }
  }
}
