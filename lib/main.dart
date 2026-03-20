// Path: lib/main.dart
import 'package:flutter/material.dart';
// Ganti 'myapp' dengan nama project Anda yang ada di pubspec.yaml
import 'package:myapp/tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Memanggil class yang ada di tabs.dart
      home: const MyHomeScreen(),
    );
  }
}
