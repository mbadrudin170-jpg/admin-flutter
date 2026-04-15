// lib/data/operasi/paket_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/paket_model.dart';

class PaketOperasi {
  final dbHelper = DatabaseHelper();

  Future<int> createPaket(Paket paket) async {
    final db = await dbHelper.database;
    return await db.insert('paket', paket.toMap());
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

  Future<int> updatePaket(Paket paket) async {
    final db = await dbHelper.database;
    return await db.update(
      'paket',
      paket.toMap(),
      where: 'id = ?',
      whereArgs: [paket.id],
    );
  }

  Future<int> deletePaket(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'paket',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> hapusSemuaPaket() async {
    final db = await dbHelper.database;
    await db.delete('paket');
  }
}
