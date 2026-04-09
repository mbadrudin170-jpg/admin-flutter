// lib/data/operasi/transaksi_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/transaksi.dart';

class TransaksiOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createTransaksi(Transaksi transaksi) async {
    final db = await dbHelper.database;
    await db.insert('transaksi', transaksi.toMap());
  }

  Future<List<Transaksi>> getTransaksi() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi');

    return List.generate(maps.length, (i) {
      return Transaksi.fromMap(maps[i]);
    });
  }

  Future<void> deleteTransaksi(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'transaksi',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> hapusSemuaTransaksi() async {
    final db = await dbHelper.database;
    await db.delete('transaksi');
  }
}
