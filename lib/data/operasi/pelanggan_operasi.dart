// lib/data/operasi/pelanggan_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:sqflite/sqflite.dart';

class PelangganOperasi {
  final dbHelper = DatabaseHelper.instance;

  Future<void> createPelanggan(Pelanggan pelanggan) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final data = pelanggan.toMap()..['diperbarui'] = now.toIso8601String();

    await db.insert(
      'pelanggan',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pelanggan>> getPelanggan() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan');
    return List.generate(maps.length, (i) {
      return Pelanggan.fromMap(maps[i]);
    });
  }

  Future<Pelanggan?> getPelangganById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Pelanggan.fromMap(maps.first);
    }
    return null;
  }

  // Perbaikan: Mengganti nama metode agar sesuai dengan panggilan dari UI
  Future<Pelanggan?> ambilSatuPelangganById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Pelanggan.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updatePelanggan(Pelanggan pelanggan) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan',
      pelanggan.toMap(),
      where: 'id = ?',
      whereArgs: [pelanggan.id],
    );
  }

  Future<void> deletePelanggan(String id) async {
    final db = await dbHelper.database;
    await db.delete('pelanggan', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Pelanggan>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Pelanggan.fromMap(maps[i]));
  }

  Future<void> sisipkanAtauPerbaruiBatch(List<Pelanggan> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'pelanggan',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
