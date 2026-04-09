// lib/model/transaksi.dart
import 'package:uuid/uuid.dart';

class Transaksi {
  final String id;
  final String nama;
  final String paket;
  final int harga;
  final String tanggal;
  final String pelangganId;

  Transaksi({
    String? id,
    required this.nama,
    required this.paket,
    required this.harga,
    required this.tanggal,
    required this.pelangganId,
  }) : this.id = id ?? const Uuid().v4();

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      nama: map['nama'],
      paket: map['paket'],
      harga: map['harga'],
      tanggal: map['tanggal'],
      pelangganId: map['pelangganId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'paket': paket,
      'harga': harga,
      'tanggal': tanggal,
      'pelangganId': pelangganId,
    };
  }
}
