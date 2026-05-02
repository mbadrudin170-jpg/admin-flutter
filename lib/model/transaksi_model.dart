// lib/model/transaksi_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Asumsi TipeTransaksi sudah ada di file lain atau didefinisikan di sini
enum TipeTransaksi { pemasukan, pengeluaran }

class TransaksiModel {
  final String id;
  final DateTime tanggal;
  final String keterangan;
  final double jumlah;
  final TipeTransaksi tipe;

  // === RELASI & DATA SALINAN (DENORMALISASI) ===

  // Dompet (Wajib ada)
  final String idDompet;
  final String namaDompet;

  // Kategori (Wajib ada)
  final String idKategori;
  final String namaKategori;

  // Pelanggan (Opsional, tidak semua transaksi terkait pelanggan)
  final String? idPelanggan;
  final String? namaPelanggan;

  // Paket (Opsional, hanya untuk transaksi pembelian paket)
  final String? idPaket;
  final String? namaPaket;

  // Sub-Kategori (Opsional)
  final String? idSubKategori;
  final String? namaSubKategori;

  final DateTime? diperbarui;
  final DateTime? diarsipkan;

  TransaksiModel({
    String? id,
    required this.tanggal,
    required this.keterangan,
    required this.jumlah,
    required this.tipe,
    required this.idDompet,
    required this.namaDompet,
    required this.idKategori,
    required this.namaKategori,
    this.idPelanggan,
    this.namaPelanggan,
    this.idPaket,
    this.namaPaket,
    this.idSubKategori,
    this.namaSubKategori,
    this.diperbarui,
    this.diarsipkan,
  }) : id = id ?? const Uuid().v4();

  // Helper untuk parsing tanggal
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;
    if (dateValue is Timestamp) return dateValue.toDate();
    if (dateValue is String) return DateTime.tryParse(dateValue);
    return null;
  }

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
    return TransaksiModel(
      id: map['id'],
      tanggal: _parseDateTime(map['tanggal']) ?? DateTime.now(),
      keterangan: map['keterangan'] ?? '',
      jumlah: (map['jumlah'] as num? ?? 0).toDouble(),
      tipe: TipeTransaksi.values.firstWhere(
        (e) => e.name == map['tipe'],
        orElse: () => TipeTransaksi.pengeluaran,
      ),
      idDompet: map['id_dompet'] ?? '',
      namaDompet: map['nama_dompet'] ?? '',
      idKategori: map['id_kategori'] ?? '',
      namaKategori: map['nama_kategori'] ?? '',
      idPelanggan: map['id_pelanggan'],
      namaPelanggan: map['nama_pelanggan'],
      idPaket: map['id_paket'],
      namaPaket: map['nama_paket'],
      idSubKategori: map['id_sub_kategori'],
      namaSubKategori: map['nama_sub_kategori'],
      diperbarui: _parseDateTime(map['diperbarui']),
      diarsipkan: _parseDateTime(map['diarsipkan']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'keterangan': keterangan,
      'jumlah': jumlah,
      'tipe': tipe.name,
      'id_dompet': idDompet,
      'nama_dompet': namaDompet,
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
      'id_pelanggan': idPelanggan,
      'nama_pelanggan': namaPelanggan,
      'id_paket': idPaket,
      'nama_paket': namaPaket,
      'id_sub_kategori': idSubKategori,
      'nama_sub_kategori': namaSubKategori,
      'diperbarui': diperbarui?.toIso8601String(),
      'diarsipkan': diarsipkan?.toIso8601String(),
    };
  }
}
