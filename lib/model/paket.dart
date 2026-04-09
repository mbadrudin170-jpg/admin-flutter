// lib/model/paket.dart
import 'package:uuid/uuid.dart';

enum TipeDurasi { jam, hari, bulan }

class Paket {
  final String id;
  final String nama;
  final int harga;
  final int durasi;
  final TipeDurasi tipe;

  Paket({
    String? id,
    required this.nama,
    required this.harga,
    required this.durasi,
    required this.tipe,
  }) : id = id ?? const Uuid().v4();

  // Konversi dari Map (Firestore) ke objek Paket
  factory Paket.fromMap(Map<String, dynamic> map) {
    return Paket(
      id: map['id'],
      nama: map['nama'],
      harga: map['harga'],
      durasi: map['durasi'],
      tipe: TipeDurasi.values.firstWhere(
        (e) => e.toString().split('.').last == map['tipe'],
        orElse: () => TipeDurasi.bulan, // Default jika tidak ditemukan
      ),
    );
  }

  // Konversi dari objek Paket ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'durasi': durasi,
      'tipe': tipe.toString().split('.').last,
    };
  }
}
