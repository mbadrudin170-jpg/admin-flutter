// lib/model/transaksi_model.dart
// File ini mendefinisikan model data untuk Transaksi, termasuk tipe, atribut, dan metode konversi.

import 'package:admin_wifi/model/kategori_model.dart';

enum TipeTransaksi { pemasukan, pengeluaran, transfer }

extension TipeTransaksiExtension on TipeTransaksi {
  TipeKategori toTipeKategori() {
    switch (this) {
      case TipeTransaksi.pemasukan:
        return TipeKategori.pemasukan;
      case TipeTransaksi.pengeluaran:
        return TipeKategori.pengeluaran;
      default:
        throw ArgumentError(
          'TipeTransaksi tidak dapat dipetakan ke TipeKategori: $this',
        );
    }
  }
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

  // Convert a Transaksi object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keterangan': keterangan,
      'tanggal': tanggal.toIso8601String(),
      'jumlah': jumlah,
      'tipe': tipe.toString(),
      'namaDompet': namaDompet,
      'kategori': kategori.toMap(),
      'subKategori': subKategori.toMap(),
    };
  }

  // Create a Transaksi object from a Map
  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      keterangan: map['keterangan'],
      tanggal: DateTime.parse(map['tanggal']),
      jumlah: map['jumlah'],
      tipe: TipeTransaksi.values.firstWhere((e) => e.toString() == map['tipe']),
      namaDompet: map['namaDompet'],
      kategori: Kategori.fromMap(map['kategori']),
      subKategori: SubKategori.fromMap(map['subKategori']),
    );
  }
}
