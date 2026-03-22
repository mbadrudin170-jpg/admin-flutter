
// lib/halaman/halaman_utama.dart
import 'package:flutter/material.dart';
import 'package:myapp/halaman/lainnya/kategori.dart';
import 'package:myapp/halaman/lainnya/paket.dart';
import 'package:myapp/halaman/lainnya/pelanggan.dart';
import 'package:myapp/halaman/lainnya/pelanggan_aktif.dart';
import 'package:myapp/halaman/tab/dompet_tab.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DompetTab(),
    PelangganPage(),
    PelangganAktifPage(),
    PaketPage(),
    KategoriPage(),
  ];

  static const List<String> _appBarTitles = [
    'Dompet',
    'Pelanggan',
    'Pelanggan Aktif',
    'Paket',
    'Kategori'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Dompet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_circle),
            label: 'Aktif',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Paket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategori',
          ),
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
