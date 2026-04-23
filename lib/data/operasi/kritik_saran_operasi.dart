// path: lib/data/operasi/kritik_saran_operasi.dart
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:sqflite/sqflite.dart';

// Kelas ini menangani semua operasi database untuk entitas KritikSaran.
class KritikSaranOperasi {
  final dbHelper = DatabaseHelper.instance;

  // Fungsi untuk menyisipkan data kritik dan saran baru ke dalam database lokal.
  Future<void> createKritikSaran(KritikSaran kritikSaran) async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    // ditambah: Menambahkan timestamp 'diperbarui' sebelum menyimpan.
    final data = kritikSaran.toMap()..['diperbarui'] = now.toIso8601String();

    await db.insert(
      'kritik_saran',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi untuk mengambil semua data kritik dan saran dari database lokal.
  Future<List<KritikSaran>> getKritikSaran() async {
    final db = await dbHelper.database;
    // ditambah: Mengurutkan hasil berdasarkan tanggal terbaru.
    final List<Map<String, dynamic>> maps = await db.query(
      'kritik_saran',
      orderBy: 'tanggal DESC',
    );
    return List.generate(maps.length, (i) {
      return KritikSaran.fromMap(maps[i]);
    });
  }

  // ditambah: Fungsi untuk mendapatkan perubahan data sejak sinkronisasi terakhir.
  Future<List<KritikSaran>> getPerubahan(DateTime lastSync) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kritik_saran',
      where: 'diperbarui > ?',
      whereArgs: [lastSync.toIso8601String()],
    );
    return List.generate(maps.length, (i) {
      return KritikSaran.fromMap(maps[i]);
    });
  }

  // ditambah: Fungsi untuk menyisipkan atau memperbarui data secara batch.
  Future<void> sisipkanAtauPerbaruiBatch(
    List<KritikSaran> daftarKritikSaran,
  ) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var kritikSaran in daftarKritikSaran) {
      batch.insert(
        'kritik_saran',
        kritikSaran.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
