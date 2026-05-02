import 'dart:developer';

import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/riwayat_langganan_operasi.dart';
import 'package:admin_wifi/model/enum/sync_status.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';

/// Service ini bertanggung jawab untuk memeriksa dan mengarsipkan
/// langganan pelanggan aktif yang telah kedaluwarsa.
class CekLanggananKadaluarsaService {
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  final RiwayatLanggananOperasi _riwayatLanggananOperasi =
      RiwayatLanggananOperasi();
  final PaketOperasi _paketOperasi = PaketOperasi();

  /// Memproses semua pelanggan aktif, menemukan yang kedaluwarsa,
  /// memindahkannya ke riwayat, dan menandainya sebagai 'deleted'.
  Future<void> prosesLanggananKadaluarsa() async {
    try {
      log('Memulai pengecekan langganan kedaluwarsa...', name: 'CekLangganan');

      final List<PelangganAktif> pelangganAktif = await _pelangganAktifOperasi
          .ambilSemuaPelangganAktif();

      final DateTime now = DateTime.now();

      // Filter hanya pelanggan yang sudah kedaluwarsa dan belum ditandai deleted
      final List<PelangganAktif> pelangganKadaluarsa = pelangganAktif
          .where(
            (p) =>
                p.tanggalBerakhir.isBefore(now) &&
                p.syncStatus != SyncStatus.deleted,
          )
          .toList();

      if (pelangganKadaluarsa.isEmpty) {
        log(
          'Tidak ada langganan kedaluwarsa yang ditemukan.',
          name: 'CekLangganan',
        );
        return;
      }

      log(
        'Ditemukan ${pelangganKadaluarsa.length} langganan kedaluwarsa untuk diproses.',
        name: 'CekLangganan',
      );

      for (final pelanggan in pelangganKadaluarsa) {
        // 1. Ambil detail paket untuk data snapshot di riwayat
        final paket = await _paketOperasi.getPaketById(pelanggan.idPaket);
        if (paket == null) {
          log(
            'Paket dengan ID ${pelanggan.idPaket} tidak ditemukan. Melanjutkan...',
            name: 'CekLangganan',
            level: 900,
          );
          continue;
        }

        // 2. Buat entri riwayat baru
        final riwayat = RiwayatLanggananModel(
          idPelanggan: pelanggan.idPelanggan,
          idPaket: pelanggan.idPaket,
          namaPaket: paket.nama, // Snapshot nama paket
          hargaPaket: paket.harga, // Snapshot harga
          durasiPaket: paket.durasi, // Snapshot durasi
          tipeDurasiPaket: paket.tipe.name, // Snapshot tipe durasi
          tanggalMulai: pelanggan.tanggalMulai,
          tanggalBerakhir: pelanggan.tanggalBerakhir,
          status: pelanggan.status,
          diarsipkan: now, // Tandai waktu pengarsipan
        );

        await _riwayatLanggananOperasi.tambahRiwayatLangganan(riwayat);
        log(
          'Langganan untuk pelanggan ID ${pelanggan.idPelanggan} telah diarsipkan.',
          name: 'CekLangganan',
        );

        // 3. Tandai pelanggan aktif sebagai 'deleted' dan batalkan notifikasinya
        await _pelangganAktifOperasi.hapusPelangganAktif(pelanggan.id);
        log(
          'Status PelangganAktif ID ${pelanggan.id} diubah menjadi "deleted".',
          name: 'CekLangganan',
        );
      }

      log(
        'Proses pengecekan langganan kedaluwarsa selesai.',
        name: 'CekLangganan',
      );
    } catch (e, s) {
      log(
        'Terjadi error saat memproses langganan kedaluwarsa',
        name: 'CekLanggananError',
        error: e,
        stackTrace: s,
        level: 1000,
      );
      // Lanjutkan eksekusi meskipun ada error
    }
  }
}
