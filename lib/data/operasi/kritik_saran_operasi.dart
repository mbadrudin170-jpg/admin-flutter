// path: lib/data/operasi/kritik_saran_operasi.dart
import 'dart:developer' as developer;
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

// Kelas ini menangani semua operasi database untuk entitas KritikSaran.
class KritikSaranOperasi {
  final dbHelper = DatabaseHelper.instance;

  // Fungsi untuk menyisipkan data kritik dan saran baru ke dalam database lokal.
  Future<void> createKritikSaran(KritikSaranModel kritikSaran) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    // ditambah: Menambahkan timestamp 'diperbarui' sebelum menyimpan.
    final data = kritikSaran.toMap()..['diperbarui'] = now.toIso8601String();

    await db.insert(
      'kritik_saran',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi untuk mengambil semua data kritik dan saran dari database lokal.
  Future<List<KritikSaranModel>> getKritikSaran() async {
    final db = await dbHelper.database;
    // ditambah: Mengurutkan hasil berdasarkan tanggal terbaru.
    final List<Map<String, dynamic>> maps = await db.query(
      'kritik_saran',
      orderBy: 'tanggal DESC',
    );
    return List.generate(maps.length, (i) {
      return KritikSaranModel.fromMap(maps[i]);
    });
  }

  // Fungsi untuk mengambil satu data kritik dan saran berdasarkan ID.
  Future<KritikSaranModel> getKritikSaranById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kritik_saran',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KritikSaranModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id tidak ditemukan');
    }
  }

  // ditambah: Fungsi untuk mendapatkan perubahan data sejak sinkronisasi terakhir.
  Future<List<KritikSaranModel>> getPerubahan(DateTime lastSync) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kritik_saran',
      where: 'diperbarui > ?',
      whereArgs: [lastSync.toIso8601String()],
    );
    return List.generate(maps.length, (i) {
      return KritikSaranModel.fromMap(maps[i]);
    });
  }

  // ditambah: Fungsi untuk menyisipkan atau memperbarui data secara batch.
  Future<void> sisipkanAtauPerbaruiBatch(
    List<KritikSaranModel> daftarKritikSaran,
  ) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var kritikSaranModel in daftarKritikSaran) {
      batch.insert(
        'kritik_saran',
        kritikSaranModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // ditambah: Fungsi untuk menghapus kritik saran berdasarkan ID
  Future<void> hapusKritikSaran(String id) async {
    try {
      final db = await dbHelper.database;

      // Cek apakah data ada sebelum dihapus
      final data = await db.query(
        'kritik_saran',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (data.isEmpty) {
        throw Exception('Data dengan ID $id tidak ditemukan');
      }

      // Hapus data
      await db.delete('kritik_saran', where: 'id = ?', whereArgs: [id]);

      developer.log('✅ Berhasil menghapus kritik saran dengan ID: $id');
    } catch (e) {
      developer.log('❌ Gagal menghapus kritik saran: $e');
      rethrow; // Melempar ulang error untuk ditangani di UI
    }
  }

  // ditambah: Fungsi untuk menghapus semua kritik saran
  Future<void> hapusSemuaKritikSaran() async {
    try {
      final db = await dbHelper.database;

      await db.delete('kritik_saran');

      developer.log('✅ Berhasil menghapus semua kritik saran');
    } catch (e) {
      developer.log('❌ Gagal menghapus semua kritik saran: $e');
      rethrow;
    }
  }

  // ditambah: Fungsi untuk menghapus kritik saran berdasarkan userId
  Future<void> hapusByUserId(String userId) async {
    try {
      final db = await dbHelper.database;

      final deletedCount = await db.delete(
        'kritik_saran',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      developer.log(
        '✅ Berhasil menghapus $deletedCount kritik saran dari user: $userId',
      );
    } catch (e) {
      developer.log('❌ Gagal menghapus kritik saran by userId: $e');
      rethrow;
    }
  }

  // Di file: lib/data/operasi/kritik_saran_operasi.dart
  // TAMBAHKAN method ini:

  Future<void> debugCekTabel() async {
    try {
      final db = await dbHelper.database;

      // Cek apakah tabel ada
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='kritik_saran'",
      );
      developer.log('📋 Tabel kritik_saran ada: ${result.isNotEmpty}');

      // Cek jumlah data
      final count = await db.rawQuery(
        'SELECT COUNT(*) as count FROM kritik_saran',
      );
      developer.log('📊 Jumlah data: ${count.first['count']}');

      // Lihat struktur tabel
      final tableInfo = await db.rawQuery('PRAGMA table_info(kritik_saran)');
      developer.log('🏗️ Struktur tabel:');
      for (var col in tableInfo) {
        developer.log('  - ${col['name']} (${col['type']})');
      }

      // Lihat semua data
      final allData = await db.query('kritik_saran');
      developer.log('📦 Semua data:');
      for (var data in allData) {
        developer.log('  $data');
      }
    } catch (e) {
      developer.log('❌ Error debug: $e');
    }
  }

  // ditambah: Fungsi untuk mengunduh semua data dari koleksi 'kritik_saran' di Firebase.
  static Future<List<KritikSaranModel>> unduhDataDariFirebase() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('kritik_saran')
          .get();
      final List<KritikSaranModel> data = snapshot.docs
          .map(
            (doc) =>
                KritikSaranModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();

      developer.log(
        'Berhasil mengunduh ${data.length} data kritik dan saran dari Firebase.',
        name: 'KritikSaranOperasi.unduh',
      );
      return data;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal mengunduh data kritik dan saran dari Firebase.',
        name: 'KritikSaranOperasi.unduh',
        error: e,
        stackTrace: stackTrace,
      );
      // Mengembalikan list kosong jika terjadi error.
      return [];
    }
  }
}
