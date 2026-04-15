// lib/data/operasi/dompet_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/dompet_model.dart';
import 'package:sqflite/sqflite.dart';

class DompetOperasi {
  // Perbaikan: Gunakan instance singleton yang benar
  final dbHelper = DatabaseHelper.instance;

  Future<void> createDompet(Dompet dompet) async {
    final db = await dbHelper.database;
    await db.insert('dompet', dompet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Dompet>> getDompet() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('dompet');

    return List.generate(maps.length, (i) {
      return Dompet.fromMap(maps[i]);
    });
  }

  Future<void> updateDompet(Dompet dompet) async {
    final db = await dbHelper.database;
    await db.update(
      'dompet',
      dompet.toMap(),
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
  
  // == METODE BARU UNTUK SINKRONISASI INKREMENTAL ==

  /// Mengambil record yang berubah (dibuat atau diperbarui) setelah waktu [since].
  Future<List<Dompet>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    // Perbaikan: Gunakan kolom 'diperbarui' yang sudah ada
    final List<Map<String, dynamic>> maps = await db.query(
      'dompet',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Dompet.fromMap(maps[i]));
  }

  /// Menyisipkan atau memperbarui batch data dari Firebase.
  Future<void> sisipkanAtauPerbaruiBatch(List<Dompet> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'dompet',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
