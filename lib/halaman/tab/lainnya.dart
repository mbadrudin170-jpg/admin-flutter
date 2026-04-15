// lib/lainnya.dart
import 'package:flutter/material.dart';
import 'package:admin/halaman/lainnya/kategori.dart';
import 'package:admin/halaman/lainnya/paket.dart';
import 'package:admin/halaman/lainnya/pelanggan.dart';

class LainnyaPage extends StatelessWidget {
  const LainnyaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lainnya')),
      // AppBar tidak diperlukan di sini karena sudah ada di main.dart
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
        ],
      ),
    );
  }

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
