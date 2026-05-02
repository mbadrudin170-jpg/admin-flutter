
import 'dart:developer' as developer;

import 'package:admin_wifi/data/services/pengecekan_tabel.dart';
import 'package:admin_wifi/data/services/sinkronisasi_database.dart';

/// Kelas ini bertanggung jawab untuk menginisialisasi data aplikasi.
/// Ini memeriksa apakah tabel lokal kosong dan memicu pengunduhan dari Firebase jika perlu.
class InisialisasiDataService {
  final _pengecekanTabelService = PengecekanTabelService();
  final _sinkronisasiService = SinkronisasiDatabase(); // Perbaikan di sini

  /// Memeriksa semua tabel yang relevan dan mengunduh data jika kosong.
  Future<void> inisialisasiDataAplikasi() async {
    developer.log('Memulai proses inisialisasi data...', name: 'InisialisasiData');

    try {
      // 1. Cek dan unduh data Pelanggan
      if (await _pengecekanTabelService.isPelangganEmpty()) {
        developer.log('Tabel Pelanggan kosong, mengunduh dari Firebase...', name: 'InisialisasiData');
        await _sinkronisasiService.sinkronisasiData();
      }

      // 2. Cek dan unduh data Kategori
      if (await _pengecekanTabelService.isKategoriEmpty()) {
        developer.log('Tabel Kategori kosong, mengunduh dari Firebase...', name: 'InisialisasiData');
        await _sinkronisasiService.sinkronisasiData();
      }
      
      // 3. Cek dan unduh data Transaksi
      if (await _pengecekanTabelService.isTransaksiEmpty()) {
        developer.log('Tabel Transaksi kosong, mengunduh dari Firebase...', name: 'InisialisasiData');
        await _sinkronisasiService.sinkronisasiData();
      }
      
      // 4. Cek dan unduh data Pelanggan Aktif
      if (await _pengecekanTabelService.isPelangganAktifEmpty()) {
        developer.log('Tabel Pelanggan Aktif kosong, mengunduh dari Firebase...', name: 'InisialisasiData');
        await _sinkronisasiService.sinkronisasiData();
      }

      // Anda dapat menambahkan pengecekan untuk tabel lain di sini jika perlu

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
