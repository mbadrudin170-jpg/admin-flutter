
// lib/data/operasi/pelanggan_operasi.dart
import 'package:myapp/data/sqlite.dart';
import 'package:myapp/model/pelanggan.dart';

class PelangganOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPelanggan(Pelanggan pelanggan) async {
    final db = await dbHelper.database;
    await db.insert('pelanggan', {
      'id': pelanggan.id,
      'nama': pelanggan.nama,
      'telepon': pelanggan.telepon,
      'alamat': pelanggan.alamat,
    });
  }

  Future<List<Pelanggan>> getPelanggan() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan');

    return List.generate(maps.length, (i) {
      return Pelanggan(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
        telepon: maps[i]['telepon'],
        alamat: maps[i]['alamat'],
      );
    });
  }

  Future<void> updatePelanggan(Pelanggan pelanggan) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan',
      {
        'nama': pelanggan.nama,
        'telepon': pelanggan.telepon,
        'alamat': pelanggan.alamat,
      },
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
}
