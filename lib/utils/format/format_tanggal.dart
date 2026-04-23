// path: lib/utils/format/format_tanggal.dart
// Fungsi ini digunakan untuk memformat objek DateTime menjadi string tanggal yang mudah dibaca.

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Fungsi untuk memformat tanggal ke dalam format 'dd MMMM yyyy' dengan lokal Indonesia.
String formatTanggal(DateTime tanggal) {
  // // ditambah: Menginisialisasi data lokal untuk pemformatan tanggal Indonesia.
  initializeDateFormatting('id_ID', null);
  // // ditambah: Membuat instance DateFormat untuk format yang diinginkan.
  final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
  // // ditambah: Mengembalikan tanggal yang sudah diformat menjadi string.
  return formatter.format(tanggal);
}

// ditambah: Fungsi untuk memformat tanggal ke dalam format 'dd/MM/yyyy'.
String formatTanggalAngka(DateTime tanggal) {
  // ditambah: Membuat instance DateFormat untuk format angka.
  final formatter = DateFormat('dd-MM-yy');
  // ditambah: Mengembalikan tanggal yang sudah diformat menjadi string.
  return formatter.format(tanggal);
}
