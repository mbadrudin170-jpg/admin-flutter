// lib/data/operasi/transaksi_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiOperasi {
  final dbHelper = DatabaseHelper.instance;

  Future<int> tambahTransaksi(TransaksiModel transaksi) async {
    final db = await dbHelper.database;
    return await db.insert(
      'transaksi',
      transaksi.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransaksiModel>> ambilSemuaTransaksi() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi');
    return List.generate(maps.length, (i) {
      return TransaksiModel.fromMap(maps[i]);
    });
  }

  Future<void> updateTransaksi(TransaksiModel transaksi) async {
    final db = await dbHelper.database;
    await db.update(
      'transaksi',
      transaksi.toMap(),
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }

  Future<void> deleteTransaksi(String id) async {
    final db = await dbHelper.database;
    await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }

  // == FUNGSI AGREGASI SALDO TRANSAKSI ==

  /// Menghitung total dari semua transaksi bertipe 'Pemasukan'.
  Future<double> getTotalPemasukan() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      "SELECT SUM(jumlah) as total FROM transaksi WHERE tipe = 'Pemasukan'",
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['jumlah'] as num).toDouble();
    }
    return 0.0;
  }

  /// Menghitung total dari semua transaksi bertipe 'Pengeluaran'.
  Future<double> getTotalPengeluaran() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      "SELECT SUM(jumlah) as total FROM transaksi WHERE tipe = 'Pengeluaran'",
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['jumlah'] as num).toDouble();
    }
    return 0.0;
  }

  /// Menghitung selisih antara total pemasukan dan pengeluaran.
  Future<double> getNetTotal() async {
    final pemasukan = await getTotalPemasukan();
    final pengeluaran = await getTotalPengeluaran();
    return pemasukan - pengeluaran;
  }

  Future<List<TransaksiModel>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => TransaksiModel.fromMap(maps[i]));
  }

  Future<void> sisipkanAtauPerbaruiBatch(List<TransaksiModel> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'transaksi',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
