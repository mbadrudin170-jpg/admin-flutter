// path: tools/migrasi_diarsipkan.dart
// PENTING: Skrip ini HANYA untuk dijalankan sekali oleh developer.
// Tujuan:
// - Mengubah field 'diarsipkan' (boolean) ➜ 'diarsipkan' (timestamp)
// - Jika belum ada → isi dari 'tanggal_berakhir'
// - Jika boolean → convert ke timestamp
// - Jika sudah timestamp → lewati

import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> migrasiDiarsipkan() async {
  // 🔥 Inisialisasi Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDX0t3xU8zelxYj0oAz10PG4u4iUzb6QG4',
        appId: '1:816519063489:web:2eab7119b29bee88ce7140',
        messagingSenderId: '816519063489',
        projectId: 'management-wifi-3acc7',
      ),
    );
  }

  developer.log('===========================================================');
  developer.log('====      MEMULAI MIGRASI diarsipkan (TIMESTAMP)      ====');
  developer.log('===========================================================');

  final db = FirebaseFirestore.instance;
  final koleksiRef = db.collection('riwayat_langganan');

  try {
    final snapshot = await koleksiRef.get();

    if (snapshot.docs.isEmpty) {
      developer.log('✅ Koleksi kosong. Tidak ada yang perlu dimigrasi.');
      return;
    }

    developer.log(
      '🔎 Ditemukan ${snapshot.docs.length} dokumen. Memulai migrasi...',
    );

    var batch = db.batch();

    int dokumenDiproses = 0;
    int dokumenDiupdate = 0;
    int operasiBatch = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final existing = data['diarsipkan'] ?? data['diarsipkan'];
      final tanggalBerakhir = data['tanggal_berakhir'];

      // ❌ Tidak ada tanggal_berakhir → skip
      if (tanggalBerakhir == null) {
        developer.log('    - [SKIP] ${doc.id} tidak punya tanggal_berakhir');
        dokumenDiproses++;
        continue;
      }

      // 🔥 CASE 1: belum ada field sama sekali
      if (existing == null) {
        batch.update(doc.reference, {'diarsipkan': tanggalBerakhir});

        developer.log(
          '    - [UPDATE] ${doc.id} → diarsipkan = tanggal_berakhir',
        );

        dokumenDiupdate++;
        operasiBatch++;
      }
      // 🔥 CASE 2: masih boolean
      else if (existing is bool) {
        batch.update(doc.reference, {'diarsipkan': tanggalBerakhir});

        developer.log('    - [CONVERT] ${doc.id} boolean → timestamp');

        dokumenDiupdate++;
        operasiBatch++;
      }
      // 🔥 CASE 3: sudah timestamp → skip
      else if (existing is Timestamp) {
        developer.log('    - [OK] ${doc.id} sudah timestamp');
      }
      // 🔥 CASE 4: tipe aneh (string/dll)
      else {
        batch.update(doc.reference, {'diarsipkan': tanggalBerakhir});

        developer.log(
          '    - [FIX] ${doc.id} tipe tidak valid → dipaksa timestamp',
        );

        dokumenDiupdate++;
        operasiBatch++;
      }

      dokumenDiproses++;

      // 🔥 Commit tiap 499 operasi
      if (operasiBatch == 499) {
        developer.log('\n⚡️ Commit batch ($operasiBatch operasi)...');
        await batch.commit();

        batch = db.batch();
        operasiBatch = 0;

        developer.log('Batch baru dimulai.');
      }
    }

    // 🔥 Commit sisa terakhir
    if (operasiBatch > 0) {
      developer.log('\n🚀 Commit batch terakhir ($operasiBatch operasi)...');
      await batch.commit();
    }

    developer.log(
      '\n===========================================================',
    );
    developer.log(
      '====                 MIGRASI SELESAI                   ====',
    );
    developer.log(
      '===========================================================',
    );
    developer.log('✅ Total Dokumen Diperiksa: $dokumenDiproses');
    developer.log('🔄 Total Dokumen Diperbarui: $dokumenDiupdate');
    developer.log(
      '===========================================================',
    );
  } catch (e) {
    developer.log(
      '\n===========================================================',
    );
    developer.log(
      '====             TERJADI ERROR SAAT MIGRASI            ====',
    );
    developer.log(
      '===========================================================',
    );
    developer.log('Error: $e');
    developer.log(
      '===========================================================',
    );
  }
}
