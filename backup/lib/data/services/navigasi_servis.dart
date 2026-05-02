// path: lib/data/services/navigasi_servis.dart
// Kelas ini bertanggung jawab untuk menyediakan akses global ke NavigatorState.
// Ini memungkinkan navigasi dari luar widget tree, seperti dari layanan notifikasi.

import 'package:flutter/material.dart';

class NavigasiServis {
  // Kunci global untuk mengakses NavigatorState.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
