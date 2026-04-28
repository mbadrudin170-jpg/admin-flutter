
// Path: lib/data/operasi/riwayat_langganan_operasi.dart

import 'package:sqflite/sqflite.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';
import 'package:admin_wifi/data/sqlite.dart';

class RiwayatLanggananOperasi {
  // Fungsi untuk menambahkan riwayat langganan baru
  Future<void> tambahRiwayatLangganan(RiwayatLanggananModel riwayat) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'riwayat_langganan',
      riwayat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Berguna jika ada kasus duplikasi ID
    );
  }
}
