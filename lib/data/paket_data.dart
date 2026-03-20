import 'package:myapp/model/paket.dart';

final List<Paket> daftarPaket = [
  Paket(
    nama: 'Bronze',
    harga: 50000,
    durasi: 1,
    tipe: TipeDurasi.bulan,
  ),
  Paket(
    nama: 'Silver',
    harga: 100000,
    durasi: 1,
    tipe: TipeDurasi.bulan,
  ),
  Paket(
    nama: 'Gold',
    harga: 150000,
    durasi: 1,
    tipe: TipeDurasi.bulan,
  ),
  Paket(
    nama: 'Harian',
    harga: 5000,
    durasi: 1,
    tipe: TipeDurasi.hari,
  ),
  Paket(
    nama: 'Mingguan',
    harga: 25000,
    durasi: 7,
    tipe: TipeDurasi.hari,
  ),
];
