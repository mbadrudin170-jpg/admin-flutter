// Path: lib/data/operasi/riwayat_langganan_operasi.dart

import 'package:admin_wifi/model/riwayat_langganan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:admin_wifi/data/sqlite.dart';

class RiwayatLanggananOperasi {
  final dbHelper = DatabaseHelper.instance;

  // Tambah riwayat
  Future<int> tambahRiwayatLangganan(RiwayatLanggananModel riwayat) async {
    Database db = await dbHelper.database;
    return await db.insert('riwayat_langganan', riwayat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // diubah: Tambahkan fungsi update
  Future<int> updateRiwayat(RiwayatLanggananModel riwayat) async {
    Database db = await dbHelper.database;
    return await db.update(
      'riwayat_langganan',
      riwayat.toMap(),
      where: 'id = ?',
      whereArgs: [riwayat.id],
    );
  }

  // Ambil semua riwayat
  Future<List<RiwayatLanggananModel>> ambilSemuaRiwayat() async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('riwayat_langganan');
    return List.generate(maps.length, (i) {
      return RiwayatLanggananModel.fromMap(maps[i]);
    });
  }

  // Hapus riwayat berdasarkan ID
  Future<int> hapusRiwayat(String id) async {
    Database db = await dbHelper.database;
    return await db.delete('riwayat_langganan', where: 'id = ?', whereArgs: [id]);
  }

  // Hapus semua riwayat
  Future<int> hapusSemuaRiwayat() async {
    Database db = await dbHelper.database;
    return await db.delete('riwayat_langganan');
  }

  // Ambil perubahan untuk sinkronisasi
  Future<List<RiwayatLanggananModel>> getPerubahan(DateTime lastSync) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'riwayat_langganan',
      where: 'diperbarui > ?',
      whereArgs: [lastSync.toIso8601String()],
    );
    return List.generate(maps.length, (i) {
      return RiwayatLanggananModel.fromMap(maps[i]);
    });
  }

  // Sisipkan atau perbarui batch untuk sinkronisasi
  Future<void> sisipkanAtauPerbaruiBatch(
      List<RiwayatLanggananModel> riwayatList) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var riwayat in riwayatList) {
      batch.insert(
        'riwayat_langganan',
        riwayat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
