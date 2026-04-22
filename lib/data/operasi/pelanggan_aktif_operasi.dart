// lib/data/operasi/pelanggan_aktif_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:sqflite/sqflite.dart';

class PelangganAktifOperasi {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createPelangganAktif(PelangganAktif pelangganAktif) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final data = pelangganAktif.toMap()..['diperbarui'] = now.toIso8601String();
    return await db.insert(
      'pelanggan_aktif',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PelangganAktif>> ambilSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan_aktif');
    return List.generate(maps.length, (i) {
      return PelangganAktif.fromMap(maps[i]);
    });
  }

  Future<PelangganAktif?> ambilSatuPelangganAktif(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PelangganAktif.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updatePelangganAktif(PelangganAktif pelangganAktif) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final data = pelangganAktif.toMap()..['diperbarui'] = now.toIso8601String();
    await db.update(
      'pelanggan_aktif',
      data,
      where: 'id = ?',
      whereArgs: [pelangganAktif.id],
    );
  }

  Future<void> hapusPelangganAktif(int id) async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> hapusSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif');
  }

  Future<int> hapusPelangganKadaluarsa() async {
    final db = await dbHelper.database;
    return await db.delete(
      'pelanggan_aktif',
      where: 'tanggalBerakhir < ?',
      whereArgs: [DateTime.now().toIso8601String()],
    );
  }

  Future<List<PelangganAktif>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => PelangganAktif.fromMap(maps[i]));
  }

  Future<void> sisipkanAtauPerbaruiBatch(List<PelangganAktif> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'pelanggan_aktif',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
