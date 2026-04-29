// path: lib/halaman/detail/detail_pelanggan_aktif.dart
import 'dart:developer' as developer;
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/whatsapp/info_paket.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:admin_wifi/utils/perhitungan_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPelangganAktif extends StatefulWidget {
  final PelangganAktif pelanggan;

  const DetailPelangganAktif({super.key, required this.pelanggan});

  @override
  State<DetailPelangganAktif> createState() => _DetailPelangganAktifState();
}

class _DetailPelangganAktifState extends State<DetailPelangganAktif> {
  late PelangganAktif _pelangganAktif;
  Pelanggan? _pelanggan;
  Paket? _paket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pelangganAktif = widget.pelanggan;
    _loadDetails();
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    // diubah: Logika pemformatan nomor telepon diperbaiki
    String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (formattedNumber.startsWith('0')) {
      formattedNumber = '62${formattedNumber.substring(1)}';
    } else if (!formattedNumber.startsWith('62')) {
      formattedNumber = '62$formattedNumber';
    }

    final Uri whatsappUri = Uri.parse('https://wa.me/$formattedNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak dapat membuka WhatsApp. Pastikan sudah terinstal.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadDetails() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final pelangganOperasi = PelangganOperasi();
    final paketOperasi = PaketOperasi();

    try {
      final idPaket = _pelangganAktif.idPaket;

      final results = await Future.wait([
        pelangganOperasi.getPelangganById(_pelangganAktif.idPelanggan),
        if (idPaket.isNotEmpty)
          paketOperasi.getPaketById(idPaket)
        else
          Future.value(null),
      ]);

      if (mounted) {
        setState(() {
          _pelanggan = results[0] as Pelanggan?;
          _paket = results[1] as Paket?;
          _isLoading = false;
        });
      }
    } catch (e, s) {
      developer.log(
        'Gagal memuat detail',
        name: 'DetailPelangganAktif',
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormPelangganAktif(pelangganAktif: _pelangganAktif),
      ),
    );

    if (result == true) {
      final operasi = PelangganAktifOperasi();
      final updatedPelangganAktif = await operasi.ambilSatuPelangganAktif(
        _pelangganAktif.id!,
      );
      if (mounted && updatedPelangganAktif != null) {
        setState(() {
          _pelangganAktif = updatedPelangganAktif;
        });
        _loadDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pelanggan?.nama ?? 'Detail Pelanggan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _navigateToEdit),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              _pelanggan?.nama ?? _pelangganAktif.idPelanggan,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          _buildWhatsAppInfoRow(
                            'No HP',
                            _pelanggan?.telepon ?? 'Tidak ditemukan',
                          ),
                          _buildInfoRow(
                            'Paket',
                            _paket?.nama ?? '(ID: ${_pelangganAktif.idPaket})',
                          ),
                          _buildInfoRow(
                            'Status',
                            _pelangganAktif.status.displayName,
                          ),

                          _buildInfoRow(
                            'Mulai',
                            '${FormatTanggal.formatTanggalRingkas(_pelangganAktif.tanggalMulai)} - ${FormatJam.formatJamMenit(_pelangganAktif.tanggalMulai)}',
                          ),
                          _buildInfoRow(
                            'Berakhir',
                            '${FormatTanggal.formatTanggalRingkas(_pelangganAktif.tanggalBerakhir)} - ${FormatJam.formatJamMenit(_pelangganAktif.tanggalBerakhir)}',
                          ),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            PerhitunganUtil.getTeksSisaMasaAktif(
                              _pelangganAktif.tanggalBerakhir,
                            ),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: PerhitunganUtil.getWarnaSisaMasaAktif(
                                    _pelangganAktif.tanggalBerakhir,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          // ... Bagian lain dari widget Column
                          const SizedBox(height: 24),
                          // Tombol untuk memicu pengiriman rincian aktivasi melalui WhatsApp
                          ElevatedButton.icon(
                            icon: const Icon(Icons.send_to_mobile),
                            label: const Text('Kirim Info via WhatsApp'),
                            onPressed: () {
                              // Memanggil fungsi statis untuk mengirim pesan
                              PesanInfoPaket.kirimRincianPaket(_pelangganAktif);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          // ... Bagian lain dari widget Column
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          InkWell(
            onTap: () => _launchWhatsApp(value),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
