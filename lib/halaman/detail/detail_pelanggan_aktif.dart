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
// ditambah: Mengimpor fungsi formatTanggal untuk memformat tanggal.
import 'package:admin_wifi/utils/format/format_tanggal.dart';
// ditambah: Mengimpor kelas FormatJam untuk memformat waktu.
import 'package:admin_wifi/utils/format/format_jam.dart';

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
      // PERBAIKAN: Langsung gunakan idPaket (String) tanpa konversi
      final idPaket = _pelangganAktif.idPaket;

      // Muat data pelanggan dan paket secara bersamaan
      final results = await Future.wait([
        pelangganOperasi.ambilSatuPelangganById(_pelangganAktif.idPelanggan),
        // PERBAIKAN: Panggil dengan ID String jika tidak kosong
        if (idPaket.isNotEmpty)
          paketOperasi.ambilSatuPaket(idPaket)
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
        // Muat ulang semua detail setelah edit
        _loadDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pelanggan?.nama ?? _pelangganAktif.idPelanggan),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Nama: ${_pelanggan?.nama ?? _pelangganAktif.idPelanggan}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildTeleponDisplay(),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${_pelangganAktif.status.displayName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildPaketDisplay(),
                    const SizedBox(height: 8),
                    // diubah: Menggunakan formatTanggal dan FormatJam untuk menampilkan tanggal dan waktu mulai.
                    Text(
                      'Mulai: ${formatTanggalAngka(_pelangganAktif.tanggalMulai)} - ${FormatJam.formatKeJamMenit(_pelangganAktif.tanggalMulai)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    // diubah: Menggunakan formatTanggal dan FormatJam untuk menampilkan tanggal dan waktu berakhir.
                    Text(
                      'Berakhir: ${formatTanggalAngka(_pelangganAktif.tanggalBerakhir)} - ${FormatJam.formatKeJamMenit(_pelangganAktif.tanggalBerakhir)}',
                      style: Theme.of(context).textTheme.titleMedium,
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

  Widget _buildTeleponDisplay() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pelanggan != null) {
      return Text(
        'No HP: ${_pelanggan!.telepon}',
        style: Theme.of(context).textTheme.titleMedium,
      );
    } else {
      return Text(
        'No HP tidak ditemukan',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.red),
      );
    }
  }

  Widget _buildPaketDisplay() {
    // if (_isLoading) {
    //   return Text(
    //     'Memuat nama paket...',
    //     style: Theme.of(context).textTheme.titleMedium,
    //   );
    // }
    if (_paket != null) {
      return Text(
        'Paket: ${_paket!.nama}',
        style: Theme.of(context).textTheme.titleMedium,
      );
    } else {
      return Text(
        'Paket: (ID: ${_pelangganAktif.idPaket}) tidak ditemukan',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.red),
      );
    }
  }
}
