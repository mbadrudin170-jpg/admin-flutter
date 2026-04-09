// lib/data/operasi/dompet_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/dompet_model.dart';

class DompetOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createDompet(Dompet dompet) async {
    final db = await dbHelper.database;
    await db.insert('dompet', {
      'id': dompet.id,
      'namaDompet': dompet.namaDompet,
      'saldo': dompet.saldo,
      'diperbarui': dompet.diperbarui,
    });
  }

  Future<List<Dompet>> getDompet() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('dompet');

    return List.generate(maps.length, (i) {
      return Dompet(
        id: maps[i]['id'],
        namaDompet: maps[i]['namaDompet'],
        saldo: maps[i]['saldo'],
        diperbarui: maps[i]['diperbarui'],
      );
    });
  }

  Future<void> updateDompet(Dompet dompet) async {
    final db = await dbHelper.database;
    await db.update(
      'dompet',
      {
        'namaDompet': dompet.namaDompet,
        'saldo': dompet.saldo,
        'diperbarui': dompet.diperbarui,
      },
      where: 'id = ?',
      whereArgs: [dompet.id],
    );
  }

  Future<void> deleteDompet(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'dompet',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> hapusSemuaDompet() async {
    final db = await dbHelper.database;
    await db.delete('dompet');
  }
}
