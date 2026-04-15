// lib/data/operasi/paket_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/paket_model.dart';
import 'package:sqflite/sqflite.dart';

class PaketOperasi {
  // Perbaikan: Gunakan instance singleton
  final dbHelper = DatabaseHelper.instance;

  Future<int> createPaket(Paket paket) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final data = paket.toMap()..['diperbarui'] = now.toIso8601String();
    return await db.insert('paket', data);
  }

  Future<List<Paket>> getPaket() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('paket');
    return List.generate(maps.length, (i) {
      return Paket.fromMap(maps[i]);
    });
  }

  Future<Paket?> ambilSatuPaket(int id) async {
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
