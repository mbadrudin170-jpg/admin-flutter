
// lib/halaman_utama.dart
import 'package:admin_wifi/services/cek_langganan_kadaluarsa_service.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/halaman/tab/lainnya.dart';
import 'package:admin_wifi/halaman/tab/pelanggan_aktif.dart';
import 'package:admin_wifi/halaman/tab/dompet.dart';
import 'package:admin_wifi/halaman/tab/transaksi.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const PelangganAktifPage(),
    const DompetPage(),
    const TransaksiPage(),
    const LainnyaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // [OPTIMASI] Jalankan tugas pemeliharaan di latar belakang setelah UI utama ditampilkan.
    // Ini tidak memblokir UI dan berjalan diam-diam.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CekLanggananKadaluarsaService().prosesLanggananKadaluarsa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha(179),
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
