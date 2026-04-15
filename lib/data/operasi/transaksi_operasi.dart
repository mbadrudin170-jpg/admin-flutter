// lib/data/operasi/transaksi_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/transaksi_model.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiOperasi {
  // Perbaikan: Gunakan instance singleton
  final dbHelper = DatabaseHelper.instance;

  Future<void> createTransaksi(Transaksi transaksi) async {
    final db = await dbHelper.database;
    await db.insert(
      'transaksi',
      transaksi.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Transaksi>> getTransaksi() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi');
    return List.generate(maps.length, (i) {
      return Transaksi.fromMap(maps[i]);
    });
  }

  Future<void> updateTransaksi(Transaksi transaksi) async {
    final db = await dbHelper.database;
    await db.update(
      'transaksi',
      transaksi.toMap(),
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }

  Future<void> deleteTransaksi(String id) async {
    final db = await dbHelper.database;
    await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }

  // == METODE BARU UNTUK SINKRONISASI INKREMENTAL ==

  Future<List<Transaksi>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Transaksi.fromMap(maps[i]));
  }

  Future<void> sisipkanAtauPerbaruiBatch(List<Transaksi> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'transaksi',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
