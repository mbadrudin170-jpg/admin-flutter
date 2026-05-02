// lib/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:admin_wifi/halaman_utama.dart';
import 'package:admin_wifi/data/services/inisialisasi_data_service.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/services/cek_koneksi_internet.dart';
import 'package:admin_wifi/services/cek_langganan_kadaluarsa_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingMessage = "Memulai aplikasi...";

  @override
  void initState() {
    super.initState();
    // Memulai semua pekerjaan berat setelah frame pertama di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndNavigate();
    });
  }

  Future<void> _initializeAndNavigate() async {
    bool isOnline = false;

    try {
      // 1. Inisialisasi Lokal (Cepat)
      setState(() => _loadingMessage = "Menginisialisasi zona waktu...");
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

      setState(() => _loadingMessage = "Menginisialisasi format tanggal...");
      await initializeDateFormatting('id_ID', null);

      // 2. Inisialisasi Servis Kritis
      setState(() => _loadingMessage = "Mempersiapkan notifikasi...");
      final notifikasiServis = NotifikasiServis();
      await notifikasiServis.inisialisasi();
      await notifikasiServis.requestPermissions();

      setState(() => _loadingMessage = "Membuka database lokal...");
      await DatabaseHelper.instance.database;

      // 3. Pengecekan Koneksi & Sinkronisasi Data (Pekerjaan Paling Berat)
      setState(() => _loadingMessage = "Mengecek koneksi internet...");
      isOnline = await KoneksiInternetService.cekKoneksi();

      if (isOnline) {
        setState(() => _loadingMessage = "Memeriksa & sinkronisasi data...");
        // [FIX] Create an instance before calling the method
        await InisialisasiDataService().inisialisasiDataAplikasi();
      } else {
        setState(
          () => _loadingMessage = "Mode offline, melewati sinkronisasi...",
        );
      }

      // 4. Proses Bisnis Lanjutan
      setState(() => _loadingMessage = "Memeriksa status langganan...");
      await CekLanggananKadaluarsaService().prosesLanggananKadaluarsa();

      setState(() => _loadingMessage = "Selesai, membuka aplikasi...");
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Sedikit jeda agar pesan terbaca
    } catch (e) {
      // Jika terjadi error, tetap coba navigasi tapi tampilkan pesan
      debugPrint("Error saat inisialisasi: $e");
      setState(() => _loadingMessage = "Terjadi error, tetap mencoba...");
    }

    // 5. Navigasi
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HalamanUtama()),
    ).then((_) {
      if (!mounted) return;
      if (!isOnline) {
        // Menampilkan pesan offline setelah halaman utama siap
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Anda dalam mode offline. Data mungkin tidak terbaru.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 80),
            const SizedBox(height: 24),
            const Text(
              'Admin WiFi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _loadingMessage,
              style: const TextStyle(fontSize: 14, fontFamily: 'Open Sans'),
            ),
          ],
        ),
      ),
    );
  }
}
