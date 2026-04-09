// lib/main.dart
import 'package:admin/data/servis/firebase_servis.dart';
import 'package:admin/data/sqlite.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database
  final dbHelper = DatabaseHelper();
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: const Center(
        child: Text('Selamat datang di Admin Panel!'),
      ),
    );
  }
}
