// lib/halaman/lainnya/pelanggan.dart
// Halaman ini menampilkan daftar semua pelanggan yang terdaftar.

import 'package:admin_wifi/halaman/form/form_pelanggan.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_pelanggan.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  late Future<List<Pelanggan>> _listaPelangganFuture;

  @override
  void initState() {
    super.initState();
    _loadPelanggan();
  }

  // diubah: Method _loadPelanggan sekarang mengurutkan data default A-Z
  Future<void> _loadPelanggan() async {
    setState(() {
      _listaPelangganFuture = _pelangganOperasi.getPelanggan().then((list) {
        // diubah: Urutkan list berdasarkan nama A-Z secara default
        list.sort((a, b) => a.nama.compareTo(b.nama));
        return list;
      });
    });
  }

  void _tambahPelanggan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPelanggan()),
    );
    if (result == true) {
      _loadPelanggan(); // Muat ulang daftar pelanggan jika ada penambahan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pelanggan')),
      body: FutureBuilder<List<Pelanggan>>(
        future: _listaPelangganFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pelanggan ditemukan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pelanggan = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      pelanggan.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(pelanggan.macAddress),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPelangganPage(pelanggan: pelanggan),
                        ),
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahPelanggan,
        child: const Icon(Icons.add),
      ),
    );
  }
}
