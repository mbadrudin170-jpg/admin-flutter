// lib/splash_screen.dart
// File ini berfungsi untuk menampilkan layar pembuka (splash screen)
// saat aplikasi pertama kali dijalankan. Setelah jeda singkat, aplikasi
// akan menavigasi ke halaman utama.

import 'dart:async';
import 'package:admin_wifi/halaman_utama.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Setelah semua inisialisasi di main.dart selesai,
    // kita navigasi ke HalamanUtama setelah jeda singkat agar splash screen terlihat.
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HalamanUtama(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'Memuat Aplikasi...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
