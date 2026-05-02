// lib/data/operasi/kategori_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:sqflite/sqflite.dart';

class KategoriOperasi {
  Future<void> createKategori(Kategori kategori) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'kategori',
      kategori.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Kategori>> getKategori() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('kategori');
    return List.generate(maps.length, (i) {
      return Kategori.fromMap(maps[i]);
    });
  }

  Future<List<Kategori>> getKategoriByTipe(TipeKategori tipe) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kategori',
      where: 'tipe = ?',
      whereArgs: [tipe.name],
    );
    return List.generate(maps.length, (i) {
      return Kategori.fromMap(maps[i]);
    });
  }

  Future<void> update(Kategori kategori) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'kategori',
      kategori.toMap(),
      where: 'nama = ?',
      whereArgs: [kategori.nama],
    );
  }

  Future<void> delete(String nama) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('kategori', where: 'nama = ?', whereArgs: [nama]);
  }

  Future<void> bersihkanDanSisipkanSemua(List<Kategori> items) async {
    final db = await DatabaseHelper.instance.database;
    await db.transaction((txn) async {
      await txn.delete('kategori'); // Hapus semua data lama
      for (var item in items) {
        await txn.insert('kategori', item.toMap()); // Sisipkan data baru
      }
    });
  }

  // == METODE BARU UNTUK SINKRONISASI INKREMENTAL ==

  /// Mengambil record yang berubah (dibuat atau diperbarui) setelah waktu [since].
  Future<List<Kategori>> getPerubahan(DateTime since) async {
    final db = await DatabaseHelper.instance.database;
    // Pastikan Anda memiliki kolom 'diperbaruiPada' di tabel Anda
    final List<Map<String, dynamic>> maps = await db.query(
      'kategori',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Kategori.fromMap(maps[i]));
  }

  /// Menyisipkan atau memperbarui batch data dari Firebase.
  /// Menggunakan `ConflictAlgorithm.replace` untuk melakukan "UPSERT".
  Future<void> sisipkanAtauPerbaruiBatch(List<Kategori> items) async {
    final db = await DatabaseHelper.instance.database;
    final batch = db.batch();
    for (var item in items) {
      // Pastikan model Anda memiliki ID yang unik untuk proses ini
      batch.insert(
        'kategori',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}