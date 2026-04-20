// lib/main.dart
// File ini adalah titik masuk utama (main entry point) untuk aplikasi.
// Fungsinya adalah untuk menginisialisasi Firebase, database lokal (SQLite),
// dan layanan lainnya sebelum menjalankan aplikasi.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

import 'package:admin_wifi/data/servis/firebase_servis.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi data lokalisasi
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi database
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  // Inisialisasi layanan Firebase
  final firebaseService = FirebaseService();

  // Sinkronkan semua data
  await firebaseService.sinkronkanSemuaData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(
        fontSize: 57,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(
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
          textStyle: GoogleFonts.roboto(
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
