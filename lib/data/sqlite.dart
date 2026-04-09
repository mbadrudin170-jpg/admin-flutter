// lib/data/sqlite.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mydatabase.db');
    return await openDatabase(
      path,
      version: 2, // <-- Versi database dinaikkan
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // <-- Menambahkan handler untuk upgrade
    );
  }

  // Dijalankan saat database dibuat untuk pertama kalinya
  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  // Dijalankan saat versi database berubah
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Untuk kesederhanaan, kita hapus tabel lama dan buat yang baru.
    // Peringatan: Ini akan menghapus semua data yang ada!
    await db.execute('DROP TABLE IF EXISTS sub_kategori');
    await db.execute('DROP TABLE IF EXISTS kategori');
    await db.execute('DROP TABLE IF EXISTS paket');
    await db.execute('DROP TABLE IF EXISTS pelanggan');
    await db.execute('DROP TABLE IF EXISTS pelanggan_aktif');
    await db.execute('DROP TABLE IF EXISTS transaksi');
    await db.execute('DROP TABLE IF EXISTS dompet');
    await _createTables(db);
  }

  // Fungsi terpusat untuk membuat semua tabel
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE kategori(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        tipe TEXT NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_kategori(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        id_kategori TEXT NOT NULL,
        diperbarui TEXT NOT NULL,
        FOREIGN KEY (id_kategori) REFERENCES kategori (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE paket(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        harga INTEGER NOT NULL,
        durasi INTEGER NOT NULL,
        tipe TEXT NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pelanggan(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        telepon TEXT NOT NULL,
        alamat TEXT NOT NULL,
        password TEXT NOT NULL,
        mac_address TEXT NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pelanggan_aktif(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        paket TEXT NOT NULL,
        tanggalBerakhir TEXT NOT NULL,
        status TEXT NOT NULL,
        avatar TEXT,
        diperbarui TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transaksi(
        id TEXT PRIMARY KEY,
        keterangan TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        jumlah REAL NOT NULL,
        tipe TEXT NOT NULL,
        namaDompet TEXT NOT NULL,
        id_kategori TEXT NOT NULL,
        id_sub_kategori TEXT NOT NULL,
        diperbarui TEXT NOT NULL,
        FOREIGN KEY (id_kategori) REFERENCES kategori (id),
        FOREIGN KEY (id_sub_kategori) REFERENCES sub_kategori (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE dompet(
        id TEXT PRIMARY KEY,
        namaDompet TEXT NOT NULL,
        saldo REAL NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');
  }
}