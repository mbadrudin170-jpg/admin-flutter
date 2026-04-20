// lib/halaman/tab/lainnya.dart
// File ini menampilkan halaman "Lainnya" dengan berbagai menu navigasi.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:admin/halaman/lainnya/kategori.dart';
import 'package:admin/halaman/lainnya/kritik_saran.dart';
import 'package:admin/halaman/lainnya/paket.dart';
import 'package:admin/halaman/lainnya/pelanggan.dart';

class LainnyaPage extends StatefulWidget {
  const LainnyaPage({super.key});

  @override
  State<LainnyaPage> createState() => _LainnyaPageState();
}

class _LainnyaPageState extends State<LainnyaPage> {
  String _version = '...';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${info.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lainnya')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(_version, style: TextStyle(color: Colors.grey[600])),
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
