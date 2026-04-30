// lib/main.dart
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:admin_wifi/data/services/navigasi_servis.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/data/services/sinkronisasi_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:admin_wifi/data/sqlite.dart';
import 'package:admin_wifi/splash_screen.dart';
// import 'package:admin_wifi/data/operasi/pesan_operasi.dart'; // Import Operasi
// import 'package:admin_wifi/server/server_lokal.dart'; // Import Server

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Inisialisasi Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // 1. Siapkan Notifikasi (Pastikan ini sudah didefinisikan)
    final notifikasiServis = NotifikasiServis();
    await notifikasiServis.inisialisasi();
    await notifikasiServis.requestPermissions();

    await initializeDateFormatting('id_ID', null);

    // 2. Siapkan Database & Operasi
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;
    // final pesanOperasi = PesanOperasi(dbHelper);

    // 3. Jalankan ServerLokal
    // final server = ServerLokal(pesanOperasi);

    // PERBAIKAN: Gunakan nama fungsi 'tampilkanNotifikasiLangsung'
    // // server.jalankanServer((pesananBaru) {
    //   notifikasiServis.tampilkanNotifikasiLangsung(
    //     id:
    //         pesananBaru.id ??
    //         DateTime.now().millisecond, // Gunakan ID dari DB atau unik
    //     title: "Pesanan Masuk! 💰",
    //     body: "${pesananBaru.idPelanggan} membeli ${pesananBaru.idPaket}",
    //   );
    // });

    SinkronisasiDatabase().sinkronkanSemuaData().catchError((error) {
      debugPrint("Gagal melakukan sinkronisasi otomatis: $error");
    });
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

    // Gunakan Oswald lokal untuk semua text theme
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
      fontFamily: 'Roboto', // SET GLOBAL FONT FAMILY
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
