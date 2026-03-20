
// lib/data/operasi/kategori_operasi.dart
import 'package:myapp/data/sqlite.dart';
import 'package:myapp/model/kategori.dart';

class KategoriOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createKategori(Kategori kategori) async {
    final db = await dbHelper.database;
    await db.insert('kategori', {
      'id': kategori.id,
      'nama': kategori.nama,
      'tipe': kategori.tipe.toString().split('.').last,
    });
    for (var sub in kategori.subKategori) {
      await createSubKategori(sub, kategori.id);
    }
  }

  Future<void> createSubKategori(SubKategori subKategori, String idKategori) async {
    final db = await dbHelper.database;
    await db.insert('sub_kategori', {
      'id': subKategori.id,
      'nama': subKategori.nama,
      'id_kategori': idKategori,
    });
  }

  Future<List<Kategori>> getKategori() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('kategori');

    List<Kategori> kategoriList = [];
    for (var map in maps) {
      final subKategori = await getSubKategori(map['id']);
      kategoriList.add(Kategori(
        id: map['id'],
        nama: map['nama'],
        tipe: TipeKategori.values.firstWhere((e) => e.toString().split('.').last == map['tipe']),
        subKategori: subKategori,
      ));
    }
    return kategoriList;
  }

  Future<List<SubKategori>> getSubKategori(String idKategori) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sub_kategori',
      where: 'id_kategori = ?',
      whereArgs: [idKategori],
    );

    return List.generate(maps.length, (i) {
      return SubKategori(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
      );
    });
  }

  Future<void> updateKategori(Kategori kategori) async {
    final db = await dbHelper.database;
    await db.update(
      'kategori',
      {
        'nama': kategori.nama,
        'tipe': kategori.tipe.toString().split('.').last,
      },
      where: 'id = ?',
      whereArgs: [kategori.id],
    );
  }

  Future<void> updateSubKategori(SubKategori subKategori) async {
    final db = await dbHelper.database;
    await db.update(
      'sub_kategori',
      {'nama': subKategori.nama},
      where: 'id = ?',
      whereArgs: [subKategori.id],
    );
  }

  Future<void> deleteKategori(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'kategori',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'sub_kategori',
      where: 'id_kategori = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSubKategori(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'sub_kategori',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
