import 'package:flutter/material.dart';
import 'package:myapp/data/pelanggan_aktif_data.dart';
import 'package:myapp/halaman/detail/detail_pelanggan_aktif.dart';
import 'package:myapp/halaman/form/form_pelanggan_aktif.dart';

class PelangganAktifPage extends StatelessWidget {
  const PelangganAktifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pelanggan Aktif'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarPelanggan.length,
        itemBuilder: (context, index) {
          final pelanggan = daftarPelanggan[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPelangganAktif(pelanggan: pelanggan),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(pelanggan.avatar),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: pelanggan.avatar.isEmpty
                      ? const Icon(Icons.person, size: 24)
                      : null,
                ),
                title: Text(
                  pelanggan.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Status: ${pelanggan.status.name}"), // Memperbaiki cara menampilkan status
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPelangganAktif()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
