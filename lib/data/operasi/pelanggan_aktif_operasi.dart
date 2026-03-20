
// lib/data/operasi/pelanggan_aktif_operasi.dart
import 'package:myapp/data/sqlite.dart';
import 'package:myapp/model/pelanggan_aktif.dart';

class PelangganAktifOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPelangganAktif(PelangganAktif pelanggan) async {
    final db = await dbHelper.database;
    await db.insert('pelanggan_aktif', {
      'nama': pelanggan.nama,
      'paket': pelanggan.paket,
      'tanggalBerakhir': pelanggan.tanggalBerakhir,
      'status': pelanggan.status.toString().split('.').last,
      'avatar': pelanggan.avatar,
    });
  }

  Future<List<PelangganAktif>> getPelangganAktif() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan_aktif');

    return List.generate(maps.length, (i) {
      return PelangganAktif(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
        paket: maps[i]['paket'],
        tanggalBerakhir: maps[i]['tanggalBerakhir'],
        status: StatusMasaAktif.values.firstWhere((e) => e.toString().split('.').last == maps[i]['status']),
        avatar: maps[i]['avatar'] ?? '',
      );
    });
  }

  Future<void> updatePelangganAktif(PelangganAktif pelanggan) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan_aktif',
      {
        'nama': pelanggan.nama,
        'paket': pelanggan.paket,
        'tanggalBerakhir': pelanggan.tanggalBerakhir,
        'status': pelanggan.status.toString().split('.').last,
        'avatar': pelanggan.avatar,
      },
      where: 'id = ?',
      whereArgs: [pelanggan.id],
    );
  }

  Future<void> deletePelangganAktif(int id) async {
    final db = await dbHelper.database;
    await db.delete(
      'pelanggan_aktif',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
