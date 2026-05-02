
import 'dart:developer';

import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/riwayat_langganan_operasi.dart';
import 'package:admin_wifi/model/enum/sync_status.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';

class CekLanggananKadaluarsaService {
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  final RiwayatLanggananOperasi _riwayatLanggananOperasi =
      RiwayatLanggananOperasi();
  final PaketOperasi _paketOperasi = PaketOperasi();

  Future<void> prosesLanggananKadaluarsa() async {
    try {
      log('Memulai pengecekan langganan kedaluwarsa...', name: 'CekLangganan');

      final List<PelangganAktif> pelangganAktif = await _pelangganAktifOperasi
          .ambilSemuaPelangganAktif();

      final DateTime now = DateTime.now();

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
        final paket = await _paketOperasi.getPaketById(pelanggan.idPaket);
        if (paket == null) {
          log(
            'Paket dengan ID ${pelanggan.idPaket} tidak ditemukan. Melanjutkan...',
            name: 'CekLangganan',
            level: 900,
          );
          continue;
        }

        final riwayat = RiwayatLanggananModel(
          idPelanggan: pelanggan.idPelanggan,
          idPaket: pelanggan.idPaket,
          namaPaket: paket.nama, 
          hargaPaket: paket.harga, 
          durasiPaket: paket.durasi, 
          tipeDurasiPaket: paket.tipe.name, 
          tanggalMulai: pelanggan.tanggalMulai,
          tanggalBerakhir: pelanggan.tanggalBerakhir,
          status: pelanggan.status,
          diarsipkan: now, 
        );

        await _riwayatLanggananOperasi.tambahRiwayatLangganan(riwayat);
        log(
          'Langganan untuk pelanggan ID ${pelanggan.idPelanggan} telah diarsipkan.',
          name: 'CekLangganan',
        );

        // --- PERUBAHAN DI SINI ---
        await _pelangganAktifOperasi.updateSyncStatusToDeleted(pelanggan.id);
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
    }
  }
}
