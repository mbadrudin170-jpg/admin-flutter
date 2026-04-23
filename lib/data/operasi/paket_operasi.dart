// path: lib/data/operasi/paket_operasi.dart
// Mengelola operasi CRUD untuk data paket di database lokal.

import 'dart:developer' as developer;
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:sqflite/sqflite.dart';

class PaketOperasi {
  // Perbaikan: Gunakan instance singleton
  final dbHelper = DatabaseHelper.instance;

  // Fungsi untuk membuat paket baru di database
  Future<int> createPaket(Paket paket) async {
    try {
      developer.log("Mencoba mendapatkan database...");
      final db = await dbHelper.database;
      developer.log("Database didapatkan. Menyiapkan data...");

      final now = DateTime.now();
      final data = paket.toMap()..['diperbarui'] = now.toIso8601String();

      // Cetak data untuk memastikan isinya benar
      developer.log("Data yang akan di-insert: $data");

      developer.log("Melakukan insert ke tabel 'paket'...");
      // Perbaikan: Menggunakan ID String dari model
      final result = await db.insert('paket', data);
      developer.log("Insert berhasil dengan ID: $result");

      return result;
    } catch (e, stacktrace) {
      // Ini akan mencetak error apa pun yang terjadi di dalam blok try
      developer.log(
        "TERJADI ERROR di createPaket",
        error: e,
        stackTrace: stacktrace,
      );

      // Kembalikan nilai yang menandakan kegagalan, misalnya -1
      return -1;
    }
  }

  // diubah: Mengubah query untuk mengurutkan berdasarkan masa aktif paket dari yang terpendek ke terlama.
  Future<List<Paket>> getPaket() async {
    final db = await dbHelper.database;
    // diubah: Menggunakan rawQuery untuk menambahkan logika sorting custom berdasarkan durasi.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT *,
        CASE tipe
          WHEN 'jam' THEN durasi
          WHEN 'hari' THEN durasi * 24
          WHEN 'bulan' THEN durasi * 24 * 30
          ELSE 999999
        END as urutan
      FROM paket
      ORDER BY urutan ASC
    ''');
    return List.generate(maps.length, (i) {
      return Paket.fromMap(maps[i]);
    });
  }

  // PERBAIKAN: Mengubah parameter 'id' menjadi String
  Future<Paket?> ambilSatuPaket(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'paket',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Paket.fromMap(maps.first);
    }
    return null;
  }

  // Perbaikan: Menambahkan kembali metode updatePaket yang hilang
  Future<void> updatePaket(Paket paket) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final data = paket.toMap()..['diperbarui'] = now.toIso8601String();
    await db.update('paket', data, where: 'id = ?', whereArgs: [paket.id]);
  }

  Future<void> hapusPaket(String id) async {
    final db = await dbHelper.database;
    await db.delete('paket', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> hapusSemuaPaket() async {
    final db = await dbHelper.database;
    await db.delete('paket');
  }
  // == METODE BARU UNTUK SINKRONISASI INKREMENTAL ==

  Future<List<Paket>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'paket',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Paket.fromMap(maps[i]));
  }

  Future<void> sisipkanAtauPerbaruiBatch(List<Paket> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'paket',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
