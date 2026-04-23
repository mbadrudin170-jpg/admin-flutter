// path: lib/halaman/tab/lainnya.dart
// diubah: File ini menampilkan halaman "Lainnya" dengan berbagai menu navigasi, termasuk menu baru "Tentang Aplikasi".

import 'package:flutter/material.dart';
// ditambah: Impor halaman "Tentang Aplikasi".
import 'package:admin_wifi/halaman/lainnya/tentang_aplikasi.dart';
import 'package:admin_wifi/halaman/lainnya/kategori.dart';
import 'package:admin_wifi/halaman/lainnya/kritik_saran.dart';
import 'package:admin_wifi/halaman/lainnya/paket.dart';
import 'package:admin_wifi/halaman/lainnya/pelanggan.dart';

class LainnyaPage extends StatelessWidget {
  // diubah: Diubah menjadi StatelessWidget karena tidak ada lagi state yang perlu dikelola.
  const LainnyaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lainnya')),
      // diubah: Menghapus Column dan Padding versi yang tidak diperlukan lagi.
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.category,
            title: 'Kategori',
            page: const KategoriPage(),
          ),
          _buildMenuItem(
            context,
            icon: Icons.inventory_2,
            title: 'Paket',
            page: const PaketPage(),
          ),
          _buildMenuItem(
            context,
            icon: Icons.people,
            title: 'Pelanggan',
            page: const PelangganPage(),
          ),
          _buildMenuItem(
            context,
            icon: Icons.feedback,
            title: 'Kritik & Saran',
            page: const KritikSaranPage(),
          ),
          // ditambah: Menambahkan item menu baru untuk halaman "Tentang Aplikasi".
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            page: const TentangAplikasiPage(),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun setiap item menu dalam daftar.
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}
