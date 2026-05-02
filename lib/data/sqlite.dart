// path: lib/data/sqlite.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Kelas ini berfungsi sebagai pusat pengelolaan koneksi dan skema database SQLite.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
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
      version: 16, // diubah: Versi dinaikkan untuk memicu migrasi
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Blok migrasi yang sudah ada
    if (oldVersion < 14) {
      // ... logika migrasi sebelumnya tetap ada ...
      await db.execute(
        'UPDATE pelanggan_aktif SET sync_status = \'synced\' WHERE sync_status IS NULL',
      );
    }

    // MIGRASI BARU UNTUK VERSI 15
    if (oldVersion < 15) {
      // 1. Tambah kolom 'status' dan 'diarsipkan' ke tabel pelanggan
      await db.execute(
        "ALTER TABLE pelanggan ADD COLUMN status TEXT NOT NULL DEFAULT 'aktif'",
      );
      await db.execute("ALTER TABLE pelanggan ADD COLUMN diarsipkan TEXT");
    }

    // diubah/ditambah: Migrasi untuk memastikan skema tabel transaksi benar (snake_case)
    if (oldVersion < 16) {
      await db.execute("DROP TABLE IF EXISTS transaksi");
      await _createTransaksiTable(db);
    }
  }

  Future<void> _createTables(Database db) async {
    await _createKategoriTable(db);
    await _createSubKategoriTable(db);
    await _createPaketTable(db);
    await _createPelangganTable(db); // Diperbarui
    await _createPelangganAktifTable(db);
    await _createTransaksiTable(db); // Diperbarui
    await _createDompetTable(db);
    await _createKritikSaranTable(db);
    await _createRiwayatLanggananTable(db);
    await _createPesananTable(db);
  }

  // Metode pembuatan tabel dipisahkan agar lebih rapi

  Future<void> _createKategoriTable(Database db) async {
    await db.execute('''
      CREATE TABLE kategori(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        tipe TEXT NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createSubKategoriTable(Database db) async {
    await db.execute('''
      CREATE TABLE sub_kategori(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        id_kategori TEXT NOT NULL,
        diperbarui TEXT NOT NULL,
        FOREIGN KEY (id_kategori) REFERENCES kategori (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createPaketTable(Database db) async {
    await db.execute('''
      CREATE TABLE paket(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        harga INTEGER NOT NULL,
        durasi INTEGER NOT NULL,
        tipe TEXT NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createPelangganTable(Database db) async {
    await db.execute('''
      CREATE TABLE pelanggan(
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        telepon TEXT NOT NULL,
        alamat TEXT NOT NULL,
        password TEXT NOT NULL,
        mac_address TEXT NOT NULL,
        status TEXT NOT NULL,          -- DITAMBAHKAN
        diperbarui TEXT,               -- DIBUAT NULLABLE
        diarsipkan TEXT                -- DITAMBAHKAN
      )
    ''');
  }

  Future<void> _createPelangganAktifTable(Database db) async {
    await db.execute('''
      CREATE TABLE pelanggan_aktif(
        id TEXT PRIMARY KEY,
        id_pelanggan TEXT NOT NULL,
        id_paket TEXT NOT NULL,
        tanggalMulai TEXT NOT NULL,
        tanggalBerakhir TEXT NOT NULL,
        status TEXT NOT NULL,
        diperbarui TEXT NOT NULL,
        status_sinkronisasi TEXT NOT NULL DEFAULT 'SINKRON',
        sync_status TEXT NOT NULL DEFAULT 'synced',
        FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (id_paket) REFERENCES paket (id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
  }

  // diubah/ditambah: Menyesuaikan nama kolom dengan TransaksiModel (snake_case)
  Future<void> _createTransaksiTable(Database db) async {
    await db.execute('''
      CREATE TABLE transaksi(
        id TEXT PRIMARY KEY,
        keterangan TEXT NOT NULL,
        jumlah REAL NOT NULL,
        tanggal TEXT NOT NULL,
        tipe TEXT NOT NULL,

        id_dompet TEXT,
        nama_dompet TEXT,

        id_kategori TEXT,
        nama_kategori TEXT,
        id_sub_kategori TEXT,
        nama_sub_kategori TEXT,

        id_pelanggan TEXT,
        nama_pelanggan TEXT,
        id_paket TEXT,
        nama_paket TEXT,

        diperbarui TEXT,
        diarsipkan TEXT
      )
    ''');
  }

  Future<void> _createDompetTable(Database db) async {
    await db.execute('''
      CREATE TABLE dompet(
        id TEXT PRIMARY KEY,
        namaDompet TEXT NOT NULL,
        saldo REAL NOT NULL,
        diperbarui TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createKritikSaranTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS kritik_saran(
        id TEXT PRIMARY KEY,
        isi TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        userId TEXT NOT NULL,
        diperbarui TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES pelanggan (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createRiwayatLanggananTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS riwayat_langganan(
          id TEXT PRIMARY KEY,
          id_pelanggan TEXT NOT NULL,
          id_paket TEXT NOT NULL,
          nama_paket TEXT NOT NULL,
          harga_paket INTEGER NOT NULL,
          durasi_paket INTEGER NOT NULL,
          tipe_durasi_paket TEXT NOT NULL,
          tanggal_mulai TEXT NOT NULL,
          tanggal_berakhir TEXT NOT NULL,
          status TEXT NOT NULL,
          diperbarui TEXT,
          diarsipkan TEXT,
          FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id) ON DELETE CASCADE
        )
    ''');
  }

  Future<void> _createPesananTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pesanan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_pelanggan TEXT NOT NULL,
        id_paket TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id) ON DELETE CASCADE,
        FOREIGN KEY (id_paket) REFERENCES paket (id) ON DELETE CASCADE
      )
    ''');
  }
}
