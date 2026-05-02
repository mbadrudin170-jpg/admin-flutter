// lib/data/operasi/dompet_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:sqflite/sqflite.dart';

class DompetOperasi {
  // Perbaikan: Gunakan instance singleton yang benar
  final dbHelper = DatabaseHelper.instance;

  /* OPERASI CRUD KE SQLITE */

  Future<void> createDompet(Dompet dompet) async {
    final db = await dbHelper.database;
    await db.insert(
      'dompet',
      dompet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dompet>> getDompet() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('dompet');

    return List.generate(maps.length, (i) {
      return Dompet.fromMap(maps[i]);
    });
  }
   /// Mengambil satu dompet berdasarkan ID.
  Future<Dompet?> getDompetById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dompet',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Dompet.fromMap(maps.first);
    }
    return null; // Kembalikan null jika tidak ditemukan
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
    await db.delete('dompet', where: 'id = ?', whereArgs: [id]);
  }

  // == FUNGSI PENGHITUNGAN SALDO ==

  /// Menghitung dan mengembalikan total saldo dari semua dompet.
  /// Ini menjumlahkan saldo positif dan negatif.
  Future<double> getTotalSaldo() async {
    final db = await dbHelper.database;
    // Menggunakan rawQuery untuk menjumlahkan kolom saldo. 'total' adalah alias untuk hasilnya.
    final result = await db.rawQuery('SELECT SUM(saldo) as total FROM dompet');
    if (result.isNotEmpty && result.first['total'] != null) {
      // Hasilnya adalah num, jadi konversikan ke double.
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  /// Menghitung dan mengembalikan total saldo dari dompet yang saldonya POSITIF (> 0).
  Future<double> getTotalSaldoPositif() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(saldo) as total FROM dompet WHERE saldo > 0',
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  /// Menghitung dan mengembalikan total saldo dari dompet yang saldonya NEGATIF (< 0).
  Future<double> getTotalSaldoNegatif() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(saldo) as total FROM dompet WHERE saldo < 0',
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
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
