// path: lib/halaman/lainnya/tentang_aplikasi.dart

// File ini bertanggung jawab untuk menampilkan informasi tentang aplikasi,
// seperti versi, nama, dan deskripsi singkat.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Halaman yang menampilkan detail tentang aplikasi.
class TentangAplikasiPage extends StatefulWidget {
  const TentangAplikasiPage({super.key});

  @override
  State<TentangAplikasiPage> createState() => _TentangAplikasiPageState();
}

class _TentangAplikasiPageState extends State<TentangAplikasiPage> {
  // Informasi paket aplikasi akan disimpan di sini.
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    // Memuat informasi paket saat halaman diinisialisasi.
    _initPackageInfo();
  }

  // Fungsi untuk mengambil informasi paket aplikasi.
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul halaman.
        title: const Text('Tentang Aplikasi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Menampilkan ikon aplikasi.
              const Icon(
                Icons.wifi_tethering,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              // Menampilkan nama aplikasi.
              Text(
                _packageInfo.appName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Menampilkan versi aplikasi.
              Text(
                'Versi ${_packageInfo.version}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              // Deskripsi singkat tentang aplikasi.
              const Text(
                'Aplikasi ini membantu Anda mengelola pelanggan dan layanan WiFi dengan lebih mudah. Lacak pembayaran, kelola paket, dan dapatkan notifikasi penting langsung di perangkat Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              // Copyright atau informasi tambahan.
              const Text(
                '© 2024 Dibuat dengan Penuh Semangat',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
