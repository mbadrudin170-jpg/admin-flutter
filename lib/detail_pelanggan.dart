import 'package:flutter/material.dart';
import 'package:myapp/model/pelanggan.dart';

class DetailPelanggan extends StatelessWidget {
  final Pelanggan pelanggan;
  const DetailPelanggan({super.key, required this.pelanggan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pelanggan.nama),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${pelanggan.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Nama: ${pelanggan.nama}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Telepon: ${pelanggan.telepon}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Alamat: ${pelanggan.alamat}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
