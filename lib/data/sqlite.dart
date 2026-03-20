
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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kategori(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        tipe TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_kategori(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        id_kategori TEXT NOT NULL,
        FOREIGN KEY (id_kategori) REFERENCES kategori (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE paket(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        harga INTEGER NOT NULL,
        durasi INTEGER NOT NULL,
        tipe TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pelanggan(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        telepon TEXT NOT NULL,
        alamat TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pelanggan_aktif(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        paket TEXT NOT NULL,
        tanggalBerakhir TEXT NOT NULL,
        status TEXT NOT NULL,
        avatar TEXT
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
        FOREIGN KEY (id_kategori) REFERENCES kategori (id),
        FOREIGN KEY (id_sub_kategori) REFERENCES sub_kategori (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE dompet(
        id TEXT PRIMARY KEY,
        namaDompet TEXT NOT NULL,
        saldo REAL NOT NULL
      )
    ''');
  }
}
