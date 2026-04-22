// lib/model/kritik_saran_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class KritikSaran {
  final String? id;
  final String isi;
  final DateTime tanggal;
  final String userId;

  KritikSaran({
    this.id,
    required this.isi,
    required this.tanggal,
    required this.userId,
  });

  // Konversi dari objek ke Map untuk Firestore/SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isi': isi,
      'tanggal': tanggal.toIso8601String(), // Selalu simpan sebagai string di SQLite
      'userId': userId,
    };
  }

  // Factory constructor untuk membuat objek dari Map (dari SQLite atau Firestore)
  factory KritikSaran.fromMap(Map<String, dynamic> map) {
    return KritikSaran(
      id: map['id']?.toString(),
      isi: map['isi'] ?? '',
      userId: map['userId'] ?? '',
      tanggal: (map['tanggal'] is Timestamp)
          ? (map['tanggal'] as Timestamp).toDate() // Dari Firestore
          : DateTime.parse(map['tanggal'] as String), // Dari SQLite
    );
  }
}
