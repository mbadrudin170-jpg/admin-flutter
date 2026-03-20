import 'package:flutter/material.dart';
import 'package:myapp/data/pelanggan_data.dart';
import 'package:myapp/detail_pelanggan.dart';
import 'package:myapp/halaman/form/form_pelanggan.dart';

class PelangganPage extends StatelessWidget {
  const PelangganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pelanggan'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarPelanggan.length,
        itemBuilder: (context, index) {
          final pelanggan = daftarPelanggan[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(
                pelanggan.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(pelanggan.alamat),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPelanggan(pelanggan: pelanggan),
                  ),
                );
              },
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPelanggan()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
