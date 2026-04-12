// lib/data/operasi/paket_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/paket_model.dart';

class PaketOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPaket(Paket paket) async {
    final db = await dbHelper.database;
    await db.insert('paket', {
      'nama': paket.nama,
      'harga': paket.harga,
      'durasi': paket.durasi,
      'tipe': paket.tipe.toString().split('.').last,
      'diperbarui': DateTime.now().toIso8601String(), // Menambahkan timestamp
    });
  }

  Future<List<Paket>> getPaket() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('paket');

    return List.generate(maps.length, (i) {
      return Paket(
        id: maps[i]['id'].toString(), // Membaca ID dari database
        nama: maps[i]['nama'],
        harga: maps[i]['harga'],
        durasi: maps[i]['durasi'],
        tipe: TipeDurasi.values.firstWhere(
            (e) => e.toString().split('.').last == maps[i]['tipe']),
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
        'diperbarui': DateTime.now().toIso8601String(), // Menambahkan timestamp
      },
      where: 'id = ?', // Menggunakan ID untuk update
      whereArgs: [paket.id],
    );
  }

  Future<void> deletePaket(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'paket',
      where: 'id = ?', // Menggunakan ID untuk delete
      whereArgs: [id],
    );
  }

  Future<void> hapusSemuaPaket() async {
    final db = await dbHelper.database;
    await db.delete('paket');
  }
}
