// path: lib/data/operasi/pelanggan_aktif_operasi.dart
// File ini menangani semua operasi Create, Read, Update, Delete (CRUD) untuk tabel 'pelanggan_aktif' di database SQLite lokal.
import 'package:sqflite/sqflite.dart';

import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';

class PelangganAktifOperasi {
  final dbHelper = DatabaseHelper.instance;
  final NotifikasiServis _notifikasiServis = NotifikasiServis();
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();

  // Fungsi untuk menambahkan pelanggan aktif baru ke database lokal.
  Future<int> createPelangganAktif(PelangganAktif pelangganAktif) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    // ditambah: Menyertakan timestamp 'diperbarui' untuk sinkronisasi.
    final data = pelangganAktif.toMap()..['diperbarui'] = now.toIso8601String();
    final result = await db.insert(
      'pelanggan_aktif',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _jadwalkanNotifikasi(pelangganAktif);
    return result;
  }

  // Fungsi untuk mengambil semua data pelanggan aktif dari database lokal.
  Future<List<PelangganAktif>> ambilSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan_aktif');
    return List.generate(maps.length, (i) {
      return PelangganAktif.fromMap(maps[i]);
    });
  }

  // Fungsi untuk mengambil satu pelanggan aktif berdasarkan ID.
  Future<PelangganAktif?> ambilSatuPelangganAktif(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PelangganAktif.fromMap(maps.first);
    }
    return null;
  }

  // Fungsi untuk memperbarui data pelanggan aktif di database lokal.
  Future<void> updatePelangganAktif(PelangganAktif pelangganAktif) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    // ditambah: Memperbarui timestamp 'diperbarui' untuk sinkronisasi.
    final data = pelangganAktif.toMap()..['diperbarui'] = now.toIso8601String();
    await db.update(
      'pelanggan_aktif',
      data,
      where: 'id = ?',
      whereArgs: [pelangganAktif.id],
    );
    await _jadwalkanNotifikasi(pelangganAktif);
  }

  Future<void> _jadwalkanNotifikasi(PelangganAktif pelangganAktif) async {
    final pelanggan = await _pelangganOperasi.getPelangganById(
      pelangganAktif.idPelanggan,
    );
    final namaPelanggan = pelanggan?.nama ?? 'Tanpa Nama';
    final jadwalNotifikasi = pelangganAktif.tanggalBerakhir.subtract(
      const Duration(days: 1),
    );

    if (jadwalNotifikasi.isAfter(DateTime.now())) {
      await _notifikasiServis.jadwalNotifikasi(
        id: pelangganAktif.id.hashCode,
        title: 'Paket Akan Segera Berakhir',
        body: 'Paket untuk pelanggan $namaPelanggan akan berakhir besok.',
        jadwal: jadwalNotifikasi,
      );
    }
  }

  // diubah: Mengganti implementasi Firebase yang salah dengan logika penghapusan SQLite yang benar.
  // Fungsi ini sekarang secara khusus menghapus pelanggan aktif dari database lokal.
  Future<void> hapusPelangganAktif(String id) async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif', where: 'id = ?', whereArgs: [id]);
    await _notifikasiServis.batalNotifikasi(id.hashCode);
  }

  // Fungsi untuk menghapus semua data pelanggan aktif dari database lokal.
  Future<void> hapusSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif');
  }

  // Fungsi untuk menghapus semua pelanggan yang masa aktifnya telah berakhir.
  Future<int> hapusPelangganKadaluarsa() async {
    final db = await dbHelper.database;
    return await db.delete(
      'pelanggan_aktif',
      where: 'tanggalBerakhir < ?',
      whereArgs: [DateTime.now().toIso8601String()],
    );
  }

  // Fungsi untuk mendapatkan data yang telah berubah sejak waktu sinkronisasi terakhir.
  Future<List<PelangganAktif>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => PelangganAktif.fromMap(maps[i]));
  }

  // Fungsi untuk menyisipkan atau memperbarui data secara massal (batch).
  Future<void> sisipkanAtauPerbaruiBatch(List<PelangganAktif> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'pelanggan_aktif',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
