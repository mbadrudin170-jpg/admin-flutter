import 'package:myapp/model/kategori.dart';

enum TipeTransaksi {
  pemasukan,
  pengeluaran,
  transfer,
}

class Transaksi {
  final String id;
  final String keterangan;
  final DateTime tanggal;
  final double jumlah;
  final TipeTransaksi tipe;
  final String namaDompet;
  final Kategori kategori;
  final SubKategori subKategori;

  Transaksi({
    required this.id,
    required this.keterangan,
    required this.tanggal,
    required this.jumlah,
    required this.tipe,
    required this.namaDompet,
    required this.kategori,
    required this.subKategori,
  });
}
