// path : lib/data/operasi/transaksi_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiOperasi {
  final dbHelper = DatabaseHelper.instance;

  // ===================================================================
  // -- OPERASI DASAR CRUD (Create, Read, Update, Delete) --
  // ===================================================================

  /// (Create) Menambahkan satu transaksi baru ke dalam database.
  Future<int> tambahTransaksi(TransaksiModel transaksi) async {
    final db = await dbHelper.database;
    return await db.insert(
      'transaksi',
      transaksi.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// (Read) Mengambil semua data transaksi dari database.
  Future<List<TransaksiModel>> ambilSemuaTransaksi() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      orderBy: 'tanggal DESC',
    );
    return List.generate(maps.length, (i) {
      return TransaksiModel.fromMap(maps[i]);
    });
  }

  /// (Update) Memperbarui data satu transaksi yang ada di database.
  Future<void> updateTransaksi(TransaksiModel transaksi) async {
    final db = await dbHelper.database;
    await db.update(
      'transaksi',
      transaksi.toMap(),
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }

  /// (Delete) Menghapus satu transaksi dari database berdasarkan ID.
  Future<void> deleteTransaksi(String id) async {
    final db = await dbHelper.database;
    await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }

  // ===================================================================
  // -- FUNGSI AGREGASI SALDO (Penjumlahan & Perhitungan) --
  // ===================================================================

  /// Menghitung total dari semua transaksi bertipe 'Pemasukan'.
  Future<double> getTotalPemasukan() async {
    final db = await dbHelper.database;
    // diubah: Menggunakan 'pemasukan' (huruf kecil) untuk mencocokkan data di database.
    final result = await db.rawQuery(
      "SELECT SUM(jumlah) as jumlah FROM transaksi WHERE tipe = 'pemasukan'",
    );
    if (result.isNotEmpty && result.first['jumlah'] != null) {
      return (result.first['jumlah'] as num).toDouble();
    }
    return 0.0;
  }

  /// Menghitung total dari semua transaksi bertipe 'Pengeluaran'.
  Future<double> getTotalPengeluaran() async {
    final db = await dbHelper.database;
    // diubah: Menggunakan 'pengeluaran' (huruf kecil) untuk mencocokkan data di database.
    final result = await db.rawQuery(
      "SELECT SUM(jumlah) as jumlah FROM transaksi WHERE tipe = 'pengeluaran'",
    );
    if (result.isNotEmpty && result.first['jumlah'] != null) {
      return (result.first['jumlah'] as num).toDouble();
    }
    return 0.0;
  }

  /// Menghitung selisih bersih antara total pemasukan dan pengeluaran.
  Future<double> getNetTotal() async {
    final pemasukan = await getTotalPemasukan();
    final pengeluaran = await getTotalPengeluaran();
    return pemasukan - pengeluaran;
  }

  // ===================================================================
  // -- FUNGSI SINKRONISASI (Untuk Firebase, dll) --
  // ===================================================================

  /// Mengambil semua record yang berubah (dibuat/diperbarui) sejak waktu tertentu.
  Future<List<TransaksiModel>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => TransaksiModel.fromMap(maps[i]));
  }

  /// Menyisipkan atau memperbarui beberapa item sekaligus secara efisien (batch).
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
