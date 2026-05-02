// Path: lib/data/services/pengecekan_tabel.dart

import 'package:sqflite/sqflite.dart';
import 'package:admin_wifi/data/sqlite.dart';

// Kelas ini berfungsi untuk menyediakan layanan pengecekan terkait kondisi tabel di database.
class PengecekanTabelService {
  final dbHelper = DatabaseHelper.instance;

  /// Memeriksa apakah tabel `pelanggan_aktif` kosong atau tidak.
  ///
  /// Mengembalikan `true` jika tidak ada satu pun baris data di dalam tabel,
  /// dan `false` jika sebaliknya.
  Future<bool> isPelangganAktifEmpty() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM pelanggan_aktif');
    // Mengambil nilai integer pertama dari hasil query. Jika null, anggap 0.
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<bool> isKategoriEmpty() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM kategori');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<bool> isSubKategoriEmpty() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM sub_kategori');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<bool> isPelangganEmpty() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM pelanggan');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<bool> isTransaksiEmpty() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM transaksi');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<bool> isPaketEmpty() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM paket');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }
}
