// path: lib/splash_screen.dart
// File ini bertanggung jawab untuk menampilkan layar pembuka dan memeriksa koneksi internet.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:admin_wifi/halaman_utama.dart';
// ditambah: Impor paket untuk memeriksa konektivitas.
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ditambah: Memanggil fungsi untuk memulai navigasi setelah pemeriksaan koneksi.
    _startNavigation();
  }

  // ditambah: Fungsi untuk memeriksa koneksi dan menavigasi ke halaman utama.
  Future<void> _startNavigation() async {
    // Cek koneksi internet.
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool isOnline =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    // Tunda navigasi untuk memberikan waktu bagi splash screen terlihat.
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HalamanUtama()),
      ).then((_) {
        // ditambah: Tampilkan SnackBar jika offline setelah HalamanUtama di-build.
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
