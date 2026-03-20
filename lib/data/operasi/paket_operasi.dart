
// lib/data/operasi/paket_operasi.dart
import 'package:myapp/data/sqlite.dart';
import 'package:myapp/model/paket.dart';

class PaketOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPaket(Paket paket) async {
    final db = await dbHelper.database;
    await db.insert('paket', {
      'nama': paket.nama,
      'harga': paket.harga,
      'durasi': paket.durasi,
      'tipe': paket.tipe.toString().split('.').last,
    });
  }

  Future<List<Paket>> getPaket() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('paket');

    return List.generate(maps.length, (i) {
      return Paket(
        nama: maps[i]['nama'],
        harga: maps[i]['harga'],
        durasi: maps[i]['durasi'],
        tipe: TipeDurasi.values.firstWhere((e) => e.toString().split('.').last == maps[i]['tipe']),
      );
    });
  }

  Future<void> updatePaket(Paket paket) async {
    final db = await dbHelper.database;
    await db.update(
      'paket',
      {
        'nama': paket.nama,
        'harga': paket.harga,
        'durasi': paket.durasi,
        'tipe': paket.tipe.toString().split('.').last,
      },
      where: 'nama = ?',
      whereArgs: [paket.nama],
    );
  }

  Future<void> deletePaket(String nama) async {
    final db = await dbHelper.database;
    await db.delete(
      'paket',
      where: 'nama = ?',
      whereArgs: [nama],
    );
  }
}
