// Path: lib/halaman_utama.dart

import 'package:flutter/material.dart';
import 'package:admin/halaman/tab/pelanggan_aktif.dart';
import 'package:admin/halaman/tab/dompet.dart';
import 'package:admin/halaman/tab/lainnya.dart';
import 'package:admin/halaman/tab/transaksi.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PelangganAktifPage(),
    DompetPage(),
    TransaksiPage(),
    LainnyaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_circle),
            label: 'Aktif',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Dompet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Lainnya'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
