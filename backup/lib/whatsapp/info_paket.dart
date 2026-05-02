// Path: lib/whatsapp/info_paket.dart
import 'dart:developer' as developer;
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:url_launcher/url_launcher.dart';

/// Kelas utilitas untuk membuat dan mengirim pesan informasi paket.
class PesanInfoPaket {
  /// Mengambil detail pelanggan dan paket, membuat pesan,
  /// lalu secara otomatis mengirimkannya melalui WhatsApp.
  ///
  /// [pelangganAktif]: Objek PelangganAktif yang baru saja dibuat atau diperbarui.
  static Future<void> kirimRincianPaket(PelangganAktif pelangganAktif) async {
    final pelangganOperasi = PelangganOperasi();
    final paketOperasi = PaketOperasi();

    try {
      // 1. Ambil data lengkap pelanggan dan paket dari database lokal.
      final Pelanggan? pelanggan = await pelangganOperasi.getPelangganById(
        pelangganAktif.idPelanggan,
      );
      final Paket? paket = await paketOperasi.getPaketById(
        pelangganAktif.idPaket,
      );

      if (pelanggan == null || paket == null) {
        developer.log(
          'Gagal mengirim pesan: Pelanggan atau Paket tidak ditemukan.',
          name: 'PesanInfoPaket',
        );
        return;
      }

      // 2. Dapatkan status pembayaran langsung dari model PelangganAktif.
      final String statusPembayaran = pelangganAktif.status.displayName;

      // 3. Buat string pesan yang akan dikirim.
      final String pesan = _buatPesan(
        pelanggan,
        paket,
        pelangganAktif,
        statusPembayaran,
      );

      // 4. Kirim pesan yang sudah diformat ke nomor telepon pelanggan via WhatsApp.
      await _kirimViaWhatsApp(pelanggan.telepon, pesan);
    } catch (e, s) {
      developer.log(
        'Error di kirimRincianPaket',
        name: 'PesanInfoPaket',
        error: e,
        stackTrace: s,
      );
    }
  }

  // diubah: Format pesan diperbaiki agar lebih rapi dan profesional.
  static String _buatPesan(
    Pelanggan pelanggan,
    Paket paket,
    PelangganAktif pelangganAktif,
    String statusPembayaran,
  ) {
    final namaPelanggan = pelanggan.nama;
    final namaPaket = paket.nama;
    final hargaPaket = FormatUang.formatMataUang(paket.harga.toDouble());
    final tanggalMulai = FormatTanggal.formatTanggalDanJam(
      pelangganAktif.tanggalMulai,
    );
    final tanggalBerakhir = FormatTanggal.formatTanggalDanJam(
      pelangganAktif.tanggalBerakhir,
    );

    return '''
*-- Rincian Aktivasi Paket --*

Halo, *$namaPelanggan*.
Terima kasih telah melakukan aktivasi.

Berikut adalah detail paket Anda:
-----------------------------------
📦 *Paket:*
  $namaPaket

💰 *Harga:*
  $hargaPaket

▶️ *Mulai Aktif:*
  $tanggalMulai

⏹️ *Berakhir Pada:*
  $tanggalBerakhir

✅ *Status Pembayaran:*
  $statusPembayaran
-----------------------------------

Semoga harimu menyenangkan!
''';
  }

  // diubah: Logika pemformatan nomor dan penanganan error diperbaiki.
  static Future<void> _kirimViaWhatsApp(
    String nomorTelepon,
    String pesan,
  ) async {
    // 1. Format nomor telepon ke standar internasional (misal: 62812...)
    String formattedNumber = nomorTelepon.replaceAll(RegExp(r'[^0-9]'), '');
    if (formattedNumber.startsWith('0')) {
      formattedNumber = '62${formattedNumber.substring(1)}';
    } else if (!formattedNumber.startsWith('62')) {
      formattedNumber = '62$formattedNumber';
    }

    // 2. Buat URI untuk WhatsApp
    final whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: formattedNumber,
      queryParameters: {'text': pesan},
    );

    // 3. Coba luncurkan URL dengan penanganan error
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        developer.log(
          'Tidak dapat membuka WhatsApp. Pastikan aplikasi sudah terinstal dan konfigurasi <queries> di AndroidManifest.xml sudah benar.',
          name: 'PesanInfoPaket.Error',
        );
      }
    } catch (e, s) {
      developer.log(
        'Gagal meluncurkan URL WhatsApp',
        name: 'PesanInfoPaket.Error',
        error: e,
        stackTrace: s,
      );
    }
  }
}
