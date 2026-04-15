// lib/data/operasi/pelanggan_aktif_operasi.dart
import 'package:admin/data/sqlite.dart';
import 'package:admin/model/pelanggan_aktif_model.dart';

class PelangganAktifOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createPelangganAktif(PelangganAktif pelanggan) async {
    final db = await dbHelper.database;
    final data = pelanggan.toMap();
    data['diperbarui'] = DateTime.now().toIso8601String();
    data['status_sinkronisasi'] = 'BARU';
    await db.insert('pelanggan_aktif', data);
  }

  Future<List<PelangganAktif>> ambilSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'status_sinkronisasi != ?',
      whereArgs: ['HAPUS'],
      orderBy: 'tanggalBerakhir DESC',
    );

    return List.generate(maps.length, (i) {
      return PelangganAktif.fromMap(maps[i]);
    });
  }

  // BARU: Mengambil semua data, termasuk yang akan dihapus, untuk proses sinkronisasi.
  Future<List<PelangganAktif>> ambilSemuaUntukSinkronisasi() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pelanggan_aktif');
    return List.generate(maps.length, (i) {
      return PelangganAktif.fromMap(maps[i]);
    });
  }

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

  Future<void> updatePelangganAktif(PelangganAktif pelanggan) async {
    final db = await dbHelper.database;
    final data = pelanggan.toMap();
    data['diperbarui'] = DateTime.now().toIso8601String();
    data['status_sinkronisasi'] = 'EDIT';
    await db.update(
      'pelanggan_aktif',
      data,
      where: 'id = ?',
      whereArgs: [pelanggan.id],
    );
  }

  Future<void> deletePelangganAktif(String id) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan_aktif',
      {
        'status_sinkronisasi': 'HAPUS',
        'diperbarui': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // BARU: Menandai item sebagai sinkron setelah berhasil diunggah.
  Future<void> tandaiSebagaiSinkron(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await dbHelper.database;
    await db.update(
      'pelanggan_aktif',
      {
        'status_sinkronisasi': 'SINKRON',
      },
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

  // BARU: Menghapus item dari SQLite secara permanen setelah dihapus dari Firebase.
  Future<void> hapusLokalPermanen(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await dbHelper.database;
    await db.delete(
      'pelanggan_aktif',
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

  Future<void> hapusSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif');
  }

  Future<int> hapusPelangganKadaluarsa() async {
    final db = await dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final count = await db.delete(
      'pelanggan_aktif',
      where: 'tanggalBerakhir < ? AND status = ?',
      whereArgs: [now, 'lunas'],
    );
    return count;
  }
}
