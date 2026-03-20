import 'package:myapp/pelanggan.dart';
import 'package:myapp/model/paket.dart';

class Transaksi {
  final String id;
  final Pelanggan pelanggan;
  final Paket paket;
  final DateTime tanggal;
  final StatusTransaksi status;

  Transaksi({
    required this.id,
    required this.pelanggan,
    required this.paket,
    required this.tanggal,
    required this.status,
  });
}

enum StatusTransaksi {
  berhasil,
  pending,
  gagal,
}
