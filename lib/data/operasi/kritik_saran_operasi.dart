// lib/data/operasi/kritik_saran_operasi.dart
// File ini berisi kelas untuk mengelola operasi data terkait kritik dan saran di Firestore.

import 'package:admin/model/kritik_saran_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KritikSaranOperasi {
  final CollectionReference _kritikSaranCollection = FirebaseFirestore.instance.collection('kritik_saran');

  Future<void> createKritikSaran(KritikSaran kritikSaran) async {
    await _kritikSaranCollection.add(kritikSaran.toMap());
  }
}
