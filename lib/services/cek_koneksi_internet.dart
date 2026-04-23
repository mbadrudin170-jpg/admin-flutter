// path: lib/services/cek_koneksi_internet.dart
// File ini menyediakan layanan terpusat untuk memeriksa status koneksi internet.

import 'package:connectivity_plus/connectivity_plus.dart';

class KoneksiInternetService {
  // Fungsi statis untuk memeriksa apakah perangkat terhubung ke internet (WiFi atau Mobile).
  // Mengembalikan Future<bool> yang bernilai true jika online, dan false jika offline.
  static Future<bool> cekKoneksi() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // Memeriksa apakah hasil konektivitas mengandung koneksi seluler atau WiFi.
    final isOnline =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
    return isOnline;
  }
}
