import 'package:flutter/material.dart';
import 'package:admin/model/pelanggan_aktif_model.dart';

class DetailPelangganAktif extends StatelessWidget {
  final PelangganAktif pelanggan;

  const DetailPelangganAktif({super.key, required this.pelanggan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pelanggan.nama),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                      'Nama: ${pelanggan.nama}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${pelanggan.status}',
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
