// path: lib/data/operasi/pelanggan_aktif_operasi.dart
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/model/enum/sync_status.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/whatsapp/info_paket.dart';

class PelangganAktifOperasi {
  final dbHelper = DatabaseHelper.instance;
  final NotifikasiServis _notifikasiServis = NotifikasiServis();
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();

  Future<bool> isDeviceConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<int> createPelangganAktif(PelangganAktif pelangganAktif) async {
    final db = await dbHelper.database;
    final now = DateTime.now();

    final pelangganAktifWithStatus = pelangganAktif.copyWith(
      syncStatus: SyncStatus.write,
      diperbarui: now,
    );

    final data = pelangganAktifWithStatus.toMap();
    // SOLUSI: Pastikan sync_status selalu disimpan sebagai string
    data['sync_status'] = SyncStatus.write.name;

    final result = await db.insert(
      'pelanggan_aktif',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _jadwalkanNotifikasi(pelangganAktifWithStatus);
    await PesanInfoPaket.kirimRincianPaket(pelangganAktifWithStatus);

    developer.log(
      '✅ [LOKAL] Pelanggan aktif (ID: ${pelangganAktif.id}) dibuat dan ditandai untuk diunggah.',
    );
    return result;
  }

  Future<List<PelangganAktif>> ambilSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'sync_status != ?',
      whereArgs: [SyncStatus.deleted.name],
    );
    return List.generate(maps.length, (i) => PelangganAktif.fromMap(maps[i]));
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

  Future<void> updatePelangganAktif(PelangganAktif pelangganAktif) async {
    final db = await dbHelper.database;
    final now = DateTime.now();

    final pelangganAktifWithStatus = pelangganAktif.copyWith(
      syncStatus: SyncStatus.write,
      diperbarui: now,
    );

    final data = pelangganAktifWithStatus.toMap();
    // SOLUSI: Pastikan sync_status selalu disimpan sebagai string
    data['sync_status'] = SyncStatus.write.name;

    await db.update(
      'pelanggan_aktif',
      data,
      where: 'id = ?',
      whereArgs: [pelangganAktifWithStatus.id],
    );

    developer.log(
      '✅ [LOKAL] Pelanggan aktif (ID: ${pelangganAktif.id}) diperbarui dan ditandai untuk diunggah.',
    );
    await _jadwalkanNotifikasi(pelangganAktifWithStatus);
    await PesanInfoPaket.kirimRincianPaket(pelangganAktifWithStatus);
  }

  Future<void> hapusPelangganAktif(String id) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan_aktif',
      {'sync_status': SyncStatus.deleted.name},
      where: 'id = ?',
      whereArgs: [id],
    );

    developer.log(
      '✅ [LOKAL] Pelanggan aktif (ID: $id) ditandai untuk dihapus.',
    );
    await _notifikasiServis.batalNotifikasi(id.hashCode);
  }

  Future<List<PelangganAktif>> ambilDataUntukSinkronisasi() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'sync_status = ? OR sync_status = ?',
      whereArgs: [SyncStatus.write.name, SyncStatus.deleted.name],
    );
    return List.generate(maps.length, (i) => PelangganAktif.fromMap(maps[i]));
  }

  Future<void> tandaiSudahSinkron(String id) async {
    final db = await dbHelper.database;
    await db.update(
      'pelanggan_aktif',
      {'sync_status': SyncStatus.synced.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getDeletedItems() async {
    final db = await DatabaseHelper.instance.database;

    return await db.query(
      'pelanggan_aktif',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.deleted.name],
    );
  }

  Future<void> syncDeletedToFirebase() async {
    final db = await DatabaseHelper.instance.database;

    final deletedItems = await db.query(
      'pelanggan_aktif',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.deleted.name],
    );

    for (final item in deletedItems) {
      final String id = item['id'].toString();
      
      try {
        // 1. delete dari firebase
        await FirebaseFirestore.instance
            .collection('pelanggan_aktif')
            .doc(id)
            .delete();

        // 2. setelah sukses, hapus lokal
        await db.delete('pelanggan_aktif', where: 'id = ?', whereArgs: [id]);
      } catch (e) {
        developer.log('Gagal sync delete id=$id: $e', name: 'SyncService');
      }
    }
  }

  Future<void> hapusLokalPermanen(String id) async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _jadwalkanNotifikasi(PelangganAktif pelangganAktif) async {
    final pelanggan = await _pelangganOperasi.getPelangganById(
      pelangganAktif.idPelanggan,
    );
    final namaPelanggan = pelanggan?.nama ?? 'Tanpa Nama';

    // Batalkan notifikasi lama sebelum menjadwalkan yang baru
    await _notifikasiServis.batalNotifikasi(pelangganAktif.id.hashCode);
    await _notifikasiServis.batalNotifikasi((pelangganAktif.id.hashCode + 1));

    // Jadwalkan notifikasi H-1
    final jadwalNotifikasiH1 = pelangganAktif.tanggalBerakhir.subtract(
      const Duration(days: 1),
    );
    if (jadwalNotifikasiH1.isAfter(DateTime.now())) {
      await _notifikasiServis.jadwalNotifikasi(
        id: pelangganAktif.id.hashCode,
        title: 'Paket Akan Segera Berakhir',
        body: 'Paket untuk pelanggan $namaPelanggan akan berakhir besok.',
        jadwal: jadwalNotifikasiH1,
      );
    }

    // Jadwalkan notifikasi H-3
    final jadwalNotifikasiH3 = pelangganAktif.tanggalBerakhir.subtract(
      const Duration(days: 3),
    );
    if (jadwalNotifikasiH3.isAfter(DateTime.now())) {
      await _notifikasiServis.jadwalNotifikasi(
        id: (pelangganAktif.id.hashCode + 1), // ID unik untuk notifikasi kedua
        title: 'Pengingat Paket',
        body:
            'Paket untuk pelanggan $namaPelanggan akan berakhir dalam 3 hari.',
        jadwal: jadwalNotifikasiH3,
      );
    }
  }

  Future<void> purgeDeletedLocalData() async {
    final db = await DatabaseHelper.instance.database;

    try {
      final count = await db.delete(
        'pelanggan_aktif',
        where: 'sync_status = ?',
        whereArgs: [SyncStatus.deleted.name],
      );

      developer.log(
        'Purge $count data deleted lokal selesai',
        name: 'PelangganAktifOperasi',
      );
    } catch (e) {
      developer.log(
        'Gagal purge data deleted: $e',
        name: 'PelangganAktifOperasi',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> hapusSemuaPelangganAktif() async {
    final db = await dbHelper.database;
    await db.delete('pelanggan_aktif');
  }

  Future<int> hapusPelangganKadaluarsa() async {
    final db = await dbHelper.database;
    return await db.delete(
      'pelanggan_aktif',
      where: 'tanggalBerakhir < ?',
      whereArgs: [DateTime.now().toIso8601String()],
    );
  }

  Future<List<PelangganAktif>> getPerubahan(DateTime since) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan_aktif',
      where: 'diperbarui > ?',
      whereArgs: [since.toIso8601String()],
    );
    return List.generate(maps.length, (i) => PelangganAktif.fromMap(maps[i]));
  }

  Future<void> sisipkanAtauPerbaruiBatch(List<PelangganAktif> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      // Saat mengunduh, kita juga harus memastikan notifikasi dijadwalkan ulang
      await _jadwalkanNotifikasi(item);
      batch.insert(
        'pelanggan_aktif',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
