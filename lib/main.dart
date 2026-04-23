// lib/main.dart
// File ini adalah titik masuk utama (main entry point) untuk aplikasi.
// Fungsinya adalah untuk menginisialisasi Firebase, database lokal (SQLite),
// dan layanan lainnya sebelum menjalankan aplikasi.

import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

import 'package:admin_wifi/data/services/firebase_servis.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/splash_screen.dart';

void main() async {
  // Pastikan binding Flutter sudah siap sebelum melakukan inisialisasi asinkron.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Firebase.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // ditambah: Inisialisasi layanan notifikasi.
    final notifikasiServis = NotifikasiServis();
    await notifikasiServis.inisialisasi();

    // Inisialisasi data lokalisasi untuk format tanggal.
    await initializeDateFormatting('id_ID', null);

    // Inisialisasi database lokal (SQLite).
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;

    // Menjalankan proses sinkronisasi di latar belakang tanpa menunggu (await)
    // agar runApp() dapat segera dipanggil dan menghindari timeout dari sistem operasi.
    FirebaseService().sinkronkanSemuaData().catchError((error) {
      debugPrint("Gagal melakukan sinkronisasi otomatis: $error");
    });
  } catch (e) {
    // Tangkap error jika terjadi kegagalan inisialisasi agar aplikasi tidak langsung crash.
    debugPrint("Terjadi kesalahan saat inisialisasi: $e");
  }

  // Segera jalankan aplikasi agar SplashScreen muncul.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Oswald',
        fontSize: 57,
        fontWeight: FontWeight.bold,
      ),
      titleLarge:
          TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontFamily: 'Open Sans', fontSize: 14),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    return MaterialApp(
      title: 'Admin Wifi',
      theme: lightTheme,
      themeMode: ThemeMode.light, // Selalu gunakan tema terang
      home: const SplashScreen(),
    );
  }
}
