import 'package:flutter/material.dart';
import 'package:myapp/transaksi.dart';
import 'package:myapp/home.dart';
import 'package:myapp/paket.dart';
import 'package:myapp/pelanggan.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PelangganAktifPage(),
    const PelangganPage(),
    const PaketPage(),
    const TransaksiPage(),
    const Center(child: Text('Halaman Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Pelanggan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined), label: 'Paket'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
