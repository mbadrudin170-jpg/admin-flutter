// lib/model/kritik_saran_model.dart
// File ini mendefinisikan model data untuk KritikSaran, termasuk atribut dan metode untuk konversi data.

import 'package:cloud_firestore/cloud_firestore.dart';

class KritikSaran {
  final String? id;
  final String isi;
  final DateTime tanggal;

  KritikSaran({
    this.id,
    required this.isi,
    required this.tanggal,
  });

  // Konversi dari objek ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'isi': isi,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
