
// path: lib/model/kritik_saran_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class KritikSaranModel {
  final String? id;
  final String isi;
  final DateTime tanggal;
  final String userId;
  // ditambah: Menambahkan properti untuk melacak waktu pembaruan.
  final DateTime? diperbarui;

  KritikSaranModel({
    this.id,
    required this.isi,
    required this.tanggal,
    required this.userId,
    // ditambah: Menambahkan 'diperbarui' ke konstruktor.
    this.diperbarui,
  });

  // Konversi dari objek ke Map untuk Firestore/SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isi': isi,
      'tanggal': tanggal
          .toIso8601String(), // Selalu simpan sebagai string di SQLite
      'userId': userId,
      // ditambah: Menyimpan 'diperbarui' sebagai string ISO 8601.
      'diperbarui': diperbarui?.toIso8601String(),
    };
  }

  // Factory constructor untuk membuat objek dari Map (dari SQLite atau Firestore)
  factory KritikSaranModel.fromMap(Map<String, dynamic> map) {
    return KritikSaranModel(
      id: map['id']?.toString(),
      isi: map['isi'] ?? '',
      userId: map['userId'] ?? '',
      tanggal: (map['tanggal'] is Timestamp)
          ? (map['tanggal'] as Timestamp)
                .toDate() // Dari Firestore
          : DateTime.parse(map['tanggal'] as String), // Dari SQLite
      // ditambah: Mengonversi 'diperbarui' dari Timestamp atau String.
      diperbarui: (map['diperbarui'] is Timestamp)
          ? (map['diperbarui'] as Timestamp).toDate()
          : (map['diperbarui'] != null)
          ? DateTime.parse(map['diperbarui'] as String)
          : null,
    );
  }
}
