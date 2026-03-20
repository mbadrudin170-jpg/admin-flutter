
// lib/data/operasi/transaksi_operasi.dart
import 'package:myapp/data/sqlite.dart';
import 'package:myapp/model/kategori.dart';
import 'package:myapp/model/transaksi_model.dart';

class TransaksiOperasi {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> createTransaksi(Transaksi transaksi) async {
    final db = await dbHelper.database;
    await db.insert('transaksi', {
      'id': transaksi.id,
      'keterangan': transaksi.keterangan,
      'tanggal': transaksi.tanggal.toIso8601String(),
      'jumlah': transaksi.jumlah,
      'tipe': transaksi.tipe.toString().split('.').last,
      'namaDompet': transaksi.namaDompet,
      'id_kategori': transaksi.kategori.id,
      'id_sub_kategori': transaksi.subKategori.id,
    });
  }

  Future<List<Transaksi>> getTransaksi() async {
    final db = await dbHelper.database;
    const String query = '''
      SELECT
        t.id,
        t.keterangan,
        t.tanggal,
        t.jumlah,
        t.tipe,
        t.namaDompet,
        k.id as id_kategori,
        k.nama as nama_kategori,
        k.tipe as tipe_kategori,
        sk.id as id_sub_kategori,
        sk.nama as nama_sub_kategori
      FROM transaksi t
      INNER JOIN kategori k ON t.id_kategori = k.id
      INNER JOIN sub_kategori sk ON t.id_sub_kategori = sk.id
    ''';
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (i) {
      final TipeKategori tipeKategori = TipeKategori.values.firstWhere(
          (e) => e.toString().split('.').last == maps[i]['tipe_kategori']);

      return Transaksi(
        id: maps[i]['id'],
        keterangan: maps[i]['keterangan'],
        tanggal: DateTime.parse(maps[i]['tanggal']),
        jumlah: maps[i]['jumlah'],
        tipe: TipeTransaksi.values
            .firstWhere((e) => e.toString().split('.').last == maps[i]['tipe']),
        namaDompet: maps[i]['namaDompet'],
        kategori: Kategori(
          id: maps[i]['id_kategori'],
          nama: maps[i]['nama_kategori'],
          tipe: tipeKategori,
          subKategori: [], // SubKategori list is not needed here for the main object
        ),
        subKategori: SubKategori(
          id: maps[i]['id_sub_kategori'],
          nama: maps[i]['nama_sub_kategori'],
        ),
      );
    });
  }

  Future<void> updateTransaksi(Transaksi transaksi) async {
    final db = await dbHelper.database;
    await db.update(
      'transaksi',
      {
        'keterangan': transaksi.keterangan,
        'tanggal': transaksi.tanggal.toIso8601String(),
        'jumlah': transaksi.jumlah,
        'tipe': transaksi.tipe.toString().split('.').last,
        'namaDompet': transaksi.namaDompet,
        'id_kategori': transaksi.kategori.id,
        'id_sub_kategori': transaksi.subKategori.id,
      },
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }

  Future<void> deleteTransaksi(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'transaksi',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
