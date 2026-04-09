
// lib/data/operasi/pelanggan_aktif_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/pelanggan_aktif.dart';

class PelangganAktifOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPelangganAktif(PelangganAktif pelanggan) async {
    final db = await dbHelper.database;
    await db.insert('pelanggan_aktif', pelanggan.toMap());
  }

  Future<List<PelangganAktif>> getPelangganAktif() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan_aktif');

    return List.generate(maps.length, (i) {
      return PelangganAktif.fromMap(maps[i]);
    });
  }

  Future<void> updatePelangganAktif(PelangganAktif pelanggan) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan_aktif',
      pelanggan.toMap(),
      where: 'id = ?',
      whereArgs: [pelanggan.id],
    );
  }

  Future<void> deletePelangganAktif(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'pelanggan_aktif',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> hapusSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif');
  }
}
