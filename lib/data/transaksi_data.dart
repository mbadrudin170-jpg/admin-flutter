import 'package:myapp/model/transaksi_model.dart';
import 'package:myapp/data/pelanggan_data.dart';
import 'package:myapp/data/paket_data.dart';

final List<Transaksi> daftarTransaksi = [
  Transaksi(
    id: 'TRX001',
    pelanggan: daftarPelanggan[0],
    paket: daftarPaket[0],
    tanggal: DateTime(2024, 5, 1),
    status: StatusTransaksi.berhasil,
  ),
  Transaksi(
    id: 'TRX002',
    pelanggan: daftarPelanggan[1],
    paket: daftarPaket[1],
    tanggal: DateTime(2024, 5, 12),
    status: StatusTransaksi.pending,
  ),
  Transaksi(
    id: 'TRX003',
    pelanggan: daftarPelanggan[2],
    paket: daftarPaket[2],
    tanggal: DateTime(2024, 5, 2),
    status: StatusTransaksi.gagal,
  ),
];
