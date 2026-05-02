
import 'dart:developer' as developer;

import 'package:admin_wifi/data/services/pengecekan_tabel.dart';
import 'package:admin_wifi/data/services/sinkronisasi_database.dart';

/// Kelas ini bertanggung jawab untuk menginisialisasi data aplikasi.
/// Ini memeriksa apakah tabel lokal kosong dan memicu pengunduhan dari Firebase jika perlu.
class InisialisasiDataService {
  final _pengecekanTabelService = PengecekanTabelService();
  final _sinkronisasiService = SinkronisasiDatabase();

  /// Memeriksa semua tabel yang relevan dan mengunduh data jika ada tabel yang kosong.
  Future<void> inisialisasiDataAplikasi() async {
    developer.log('Memulai proses inisialisasi data...', name: 'InisialisasiData');

    try {
      // [REFACTOR] Cek semua kondisi tabel terlebih dahulu.
      final bool perluSinkronisasi = 
          await _pengecekanTabelService.isPelangganEmpty() ||
          await _pengecekanTabelService.isKategoriEmpty() ||
          await _pengecekanTabelService.isTransaksiEmpty() ||
          await _pengecekanTabelService.isPelangganAktifEmpty();

      // [REFACTOR] Jika salah satu tabel kosong, jalankan sinkronisasi sekali saja.
      if (perluSinkronisasi) {
        developer.log(
          'Satu atau lebih tabel data kosong. Memulai sinkronisasi dari Firebase...',
          name: 'InisialisasiData',
        );
        await _sinkronisasiService.sinkronisasiData();
      } else {
        developer.log('Semua tabel data sudah terisi. Tidak perlu sinkronisasi.', name: 'InisialisasiData');
      }

      developer.log('Proses inisialisasi data selesai.', name: 'InisialisasiData');

    } catch (e, s) {
      developer.log(
        'Terjadi kesalahan selama inisialisasi data.',
        name: 'InisialisasiData.Error',
        error: e,
        stackTrace: s,
      );
    }
  }
}
