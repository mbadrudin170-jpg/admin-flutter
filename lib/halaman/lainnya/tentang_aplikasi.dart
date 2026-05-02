// path: lib/halaman/lainnya/tentang_aplikasi.dart

// File ini bertanggung jawab untuk menampilkan informasi tentang aplikasi,
// seperti versi, nama, dan deskripsi singkat.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart'; // diubah/ditambah: untuk info perangkat
import 'dart:io'; // diubah/ditambah: untuk mengecek platform

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

  // diubah/ditambah: Tambahan state untuk menyimpan informasi perangkat
  String _minSDK = '21'; // diubah/ditambah: default minSdkVersion
  String _deviceArch = 'Unknown';

  @override
  void initState() {
    super.initState();
    // Memuat informasi paket saat halaman diinisialisasi.
    _initInfo(); // diubah/ditambah: Menggabungkan semua inisialisasi
  }

  // diubah/ditambah: Mengambil semua informasi yang diperlukan
  Future<void> _initInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String deviceArch = 'Unknown';

    // untuk mendapatkan arsitektur perangkat
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      // Menampilkan semua ABI yang didukung
      deviceArch = androidInfo.supportedAbis.join(', ');
    }

    setState(() {
      _packageInfo = packageInfo;
      _deviceArch = deviceArch;
      // diubah/ditambah: Secara manual mengatur minimal OS berdasarkan build.gradle
      // Android 5.0 (Lollipop) adalah API level 21
      _minSDK = 'Android 5.0 (Lollipop)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul halaman.
        title: const Text('Tentang Aplikasi'),
      ),
      // diubah/ditambah: Ganti Center dengan ListView agar bisa di-scroll
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const SizedBox(height: 20),
          // Menampilkan ikon aplikasi.
          const Icon(Icons.wifi_tethering, size: 80, color: Colors.deepPurple),
          const SizedBox(height: 20),
          // Menampilkan nama aplikasi.
          Text(
            _packageInfo.appName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Menampilkan versi aplikasi.
          Text(
            'Versi ${_packageInfo.version}',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Deskripsi singkat tentang aplikasi.
          const Text(
            'Aplikasi ini membantu Anda mengelola pelanggan dan layanan WiFi dengan lebih mudah. Lacak pembayaran, kelola paket, dan dapatkan notifikasi penting langsung di perangkat Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          // diubah/ditambah: Container untuk info teknis
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Teknis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 20),
                  _buildInfoRow('Nomor Build', _packageInfo.buildNumber),
                  _buildInfoRow('Minimal OS', _minSDK),
                  _buildInfoRow('Arsitektur Perangkat', _deviceArch),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Copyright atau informasi tambahan.
          const Text(
            '© 2024 Dibuat dengan Penuh Semangat',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // diubah/ditambah: Widget helper untuk membuat baris info
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
