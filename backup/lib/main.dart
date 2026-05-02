// lib/main.dart
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:admin_wifi/data/services/navigasi_servis.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/services/sinkronisasi_database.dart';
import 'firebase_options.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/splash_screen.dart';

// [PERBAIKAN] Buat satu instance layanan sinkronisasi untuk seluruh aplikasi
final SinkronisasiDatabase sinkronisasiDatabase = SinkronisasiDatabase();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    final notifikasiServis = NotifikasiServis();
    await notifikasiServis.inisialisasi();
    await notifikasiServis.requestPermissions();

    await initializeDateFormatting('id_ID', null);

    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;

    // [PERBAIKAN] Panggil metode startSync() yang baru
    // Ini akan menangani sinkronisasi saat startup dan saat koneksi berubah.
    sinkronisasiDatabase.startSync();
  } catch (e) {
    debugPrint("Terjadi kesalahan saat inisialisasi: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 57,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
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
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
      navigatorKey: NavigasiServis.navigatorKey,
    );
  }
}
