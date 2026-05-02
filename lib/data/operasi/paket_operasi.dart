// path: lib/data/operasi/paket_operasi.dart
// Mengelola operasi CRUD untuk data paket di database lokal.

import 'dart:developer' as developer;
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:sqflite/sqflite.dart';

class PaketOperasi {
  final dbHelper = DatabaseHelper.instance;

  // Fungsi untuk membuat atau memperbarui paket di database (Upsert)
  Future<int> createPaket(Paket paket) async {
    try {
      developer.log("Mencoba mendapatkan database...");
      final db = await dbHelper.database;
      developer.log("Database didapatkan. Menyiapkan data...");

      final data = paket.toMap();

      // PERBAIKAN: Hanya set 'diperbarui' jika belum ada (data baru lokal).
      // Jika data dari sinkronisasi, timestamp asli akan dipertahankan.
      if (paket.diperbarui == null) {
        data['diperbarui'] = DateTime.now().toIso8601String();
      }

      developer.log("Data yang akan di-insert/update: $data");

      developer.log("Melakukan insert/update ke tabel 'paket'...");
      final result = await db.insert(
        'paket',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      developer.log("Insert/update berhasil dengan ID: $result");

      return result;
    } catch (e, stacktrace) {
      developer.log(
        "TERJADI ERROR di createPaket",
        error: e,
        stackTrace: stacktrace,
      );
      return -1;
    }
  }

  Future<List<Paket>> getPaket() async {
    final db = await dbHelper.database;
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

  Future<Paket?> getPaketById(String id) async {
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
