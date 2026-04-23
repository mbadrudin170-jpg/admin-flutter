// path: lib/splash_screen.dart
// File ini bertanggung jawab untuk menampilkan layar pembuka dan memeriksa koneksi internet.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:admin_wifi/halaman_utama.dart';
// diubah: Impor diganti ke layanan koneksi internet terpusat.
import 'package:admin_wifi/services/cek_koneksi_internet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startNavigation();
  }

  Future<void> _startNavigation() async {
    // diubah: Menggunakan layanan terpusat untuk memeriksa koneksi internet.
    final bool isOnline = await KoneksiInternetService.cekKoneksi();

    // Tunda navigasi untuk memberikan waktu bagi splash screen terlihat.
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HalamanUtama()),
      ).then((_) {
        if (!mounted) return;
        // Tampilkan SnackBar jika offline setelah HalamanUtama di-build.
        if (!isOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anda dalam mode offline'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'Admin WiFi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
