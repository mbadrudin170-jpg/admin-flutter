// path: lib/halaman/detail/detail_pelanggan_aktif.dart
import 'dart:developer' as developer;
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
// diubah: Mengimpor file utilitas terpusat.
import 'package:admin_wifi/utils/format_util.dart';
import 'package:admin_wifi/utils/perhitungan_util.dart';

class DetailPelangganAktif extends StatefulWidget {
  final PelangganAktif pelanggan;

  const DetailPelangganAktif({super.key, required this.pelanggan});

  @override
  State<DetailPelangganAktif> createState() => _DetailPelangganAktifState();
}

class _DetailPelangganAktifState extends State<DetailPelangganAktif> {
  late PelangganAktif _pelangganAktif;
  // State untuk data yang dimuat
  Pelanggan? _pelanggan;
  Paket? _paket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pelangganAktif = widget.pelanggan;
    _loadDetails();
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
          // diubah: Menggunakan getPaketById yang sudah dikonsolidasi.
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
                          _buildInfoRow(
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
                          // ditambah: Menampilkan sisa masa aktif menggunakan PerhitunganUtil.
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
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This is the parameterized helper method you asked for.
  // It takes a 'label' and a 'value' to create a consistent row style.
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
}
