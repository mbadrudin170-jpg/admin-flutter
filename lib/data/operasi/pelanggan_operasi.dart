// lib/data/operasi/pelanggan_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/pelanggan_model.dart';

class PelangganOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPelanggan(Pelanggan pelanggan) async {
    final db = await dbHelper.database;
    await db.insert('pelanggan', pelanggan.toMap());
  }

  Future<List<Pelanggan>> getPelanggan() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan');

    return List.generate(maps.length, (i) {
      return Pelanggan.fromMap(maps[i]);
    });
  }

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
    final dataToUpdate = pelanggan.toMap();
    dataToUpdate['diperbarui'] = DateTime.now().toIso8601String();

    await db.update(
      'pelanggan',
      dataToUpdate,
      where: 'id = ?',
      whereArgs: [pelanggan.id],
    );
  }

  Future<void> deletePelanggan(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'pelanggan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> hapusSemuaPelanggan() async {
    final db = await dbHelper.database;
    await db.delete('pelanggan');
  }
}
