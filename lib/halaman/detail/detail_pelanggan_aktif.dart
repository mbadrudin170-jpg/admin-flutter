// lib/halaman/detail/detail_pelanggan_aktif.dart
import 'package:admin/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin/data/operasi/pelanggan_operasi.dart';
import 'package:admin/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin/model/pelanggan_model.dart';
import 'package:flutter/material.dart';
import 'package:admin/model/pelanggan_aktif_model.dart';

class DetailPelangganAktif extends StatefulWidget {
  final PelangganAktif pelanggan;

  const DetailPelangganAktif({super.key, required this.pelanggan});

  @override
  State<DetailPelangganAktif> createState() => _DetailPelangganAktifState();
}

class _DetailPelangganAktifState extends State<DetailPelangganAktif> {
  // Inisialisasi langsung untuk menghindari LateError
  late PelangganAktif _pelangganAktif;
  Pelanggan? _pelanggan;

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel state dari widget
    _pelangganAktif = widget.pelanggan;
    _loadPelangganData();
  }

  Future<void> _loadPelangganData() async {
    // Pastikan widget masih ada di pohon sebelum setState
    if (!mounted) return;
    final PelangganOperasi operasi = PelangganOperasi();
    final pelanggan = await operasi.ambilSatuPelanggan(_pelangganAktif.idPelanggan);
    if (mounted && pelanggan != null) {
      setState(() {
        _pelanggan = pelanggan;
      });
    }
  }

  void _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPelangganAktif(pelangganAktif: _pelangganAktif),
      ),
    );

    if (result == true) {
      final PelangganAktifOperasi operasi = PelangganAktifOperasi();
      final updatedPelanggan = await operasi.ambilSatuPelangganAktif(
        _pelangganAktif.id!.toString(),
      );
      if (mounted && updatedPelanggan != null) {
        setState(() {
          _pelangganAktif = updatedPelanggan;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pelangganAktif.idPelanggan),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // selalu kirim true untuk refresh
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
                      'Nama: ${_pelangganAktif.idPelanggan}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    // Tampilkan nomor HP atau indikator loading
                    _pelanggan == null
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            'No HP: ${_pelanggan!.telepon}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${_pelangganAktif.status.displayName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Paket: ${_pelangganAktif.idPaket}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mulai: ${_pelangganAktif.tanggalMulai}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Berakhir: ${_pelangganAktif.tanggalBerakhir}',
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
}
