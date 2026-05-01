// // path: tools/migrasi_diarsipkan.dart
// // PENTING: Jalankan SEKALI saja

// import 'dart:developer' as developer;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// Future<void> migrasiDiarsipkan() async {
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: 'ISI',
//         appId: 'ISI',
//         messagingSenderId: 'ISI',
//         projectId: 'ISI',
//       ),
//     );
//   }

//   final db = FirebaseFirestore.instance;
//   final ref = db.collection('riwayat_langganan');

//   developer.log('🚀 MULAI MIGRASI FINAL');

//   final snapshot = await ref.get();

//   var batch = db.batch();
//   int operasi = 0;

//   for (final doc in snapshot.docs) {
//     final data = doc.data();

//     final dynamic v1 = data['diarsipkan'];
//     final dynamic v2 = data['diArsipkan'];
//     final dynamic v3 = data['diarsip_kan'];

//     final tanggalBerakhir = data['tanggal_berakhir'];

//     dynamic finalValue;

//     // =========================
//     // PRIORITAS NILAI
//     // =========================
//     if (v1 is Timestamp) {
//       finalValue = v1;
//     } else if (v2 is Timestamp) {
//       finalValue = v2;
//     } else if (v3 is Timestamp) {
//       finalValue = v3;
//     } else if (v1 is bool || v2 is bool || v3 is bool) {
//       finalValue = tanggalBerakhir;
//     } else if (v1 is String) {
//       finalValue = Timestamp.fromDate(DateTime.parse(v1));
//     } else {
//       finalValue = tanggalBerakhir;
//     }

//     batch.update(doc.reference, {
//       'diarsipkan': finalValue,
//       'diArsipkan': FieldValue.delete(),
//       'diarsip_kan': FieldValue.delete(),
//     });

//     developer.log('✔ ${doc.id} dirapikan');

//     operasi++;

//     if (operasi == 499) {
//       await batch.commit();
//       batch = db.batch();
//       operasi = 0;
//     }
//   }

//   if (operasi > 0) {
//     await batch.commit();
//   }

//   developer.log('✅ MIGRASI SELESAI TOTAL');
// }
