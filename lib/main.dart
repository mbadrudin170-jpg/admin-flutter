// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

import 'package:admin/data/servis/firebase_servis.dart';
import 'package:admin/data/sqlite.dart';
import 'package:admin/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi data lokalisasi
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi database
  // Perbaikan: Gunakan instance singleton
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
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Tampilkan SplashScreen sebagai halaman pertama
    );
  }
}
