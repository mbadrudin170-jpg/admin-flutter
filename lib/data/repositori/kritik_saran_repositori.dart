// Path: lib/data/repositori/kritik_saran_repositori.dart
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';

class KritikSaranRepositori {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final KritikSaranOperasi _operasiLokal = KritikSaranOperasi();

  // Koleksi Firestore untuk kritik saran
  static const String _koleksi = 'kritik_saran';

  // ==================== OPERASI FIREBASE ====================

  /// Mengambil semua data kritik saran dari Firebase
  Future<List<KritikSaranModel>> getKritikSaranDariFirebase() async {
    try {
      final snapshot = await _firestore
          .collection(_koleksi)
          .orderBy('tanggal', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        // Ambil data dari Firestore
        final Map<String, dynamic> data = doc.data();

        // Tambahkan ID dokumen ke dalam Map data
        data['id'] = doc.id;

        // Panggil fromMap hanya dengan 1 parameter (Map)
        return KritikSaranModel.fromMap(data);
      }).toList();
    } catch (e) {
      developer.log('❌ Gagal mengambil data dari Firebase: $e');
      rethrow;
    }
  }

  /// Menambah kritik saran ke Firebase
  Future<String> tambahKritikSaranKeFirebase(
    KritikSaranModel kritikSaran,
  ) async {
    try {
      final docRef = await _firestore
          .collection(_koleksi)
          .add(kritikSaran.toMap());
      developer.log(
        '✅ Berhasil menambah kritik saran ke Firebase dengan ID: ${docRef.id}',
      );
      return docRef.id;
    } catch (e) {
      developer.log('❌ Gagal menambah kritik saran ke Firebase: $e');
      rethrow;
    }
  }

  /// Memperbarui kritik saran di Firebase
  Future<void> perbaruiKritikSaranDiFirebase(
    KritikSaranModel kritikSaran,
  ) async {
    try {
      if (kritikSaran.id == null) {
        throw Exception('ID tidak boleh null untuk update');
      }

      await _firestore
          .collection(_koleksi)
          .doc(kritikSaran.id)
          .update(kritikSaran.toMap());

      developer.log(
        '✅ Berhasil memperbarui kritik saran di Firebase dengan ID: ${kritikSaran.id}',
      );
    } catch (e) {
      developer.log('❌ Gagal memperbarui kritik saran di Firebase: $e');
      rethrow;
    }
  }

  /// Menghapus kritik saran dari Firebase berdasarkan ID
  Future<void> hapusKritikSaranDariFirebase(String id) async {
    try {
      // Cek apakah dokumen ada sebelum dihapus
      final docSnapshot = await _firestore.collection(_koleksi).doc(id).get();

      if (!docSnapshot.exists) {
        throw Exception('Dokumen dengan ID $id tidak ditemukan di Firebase');
      }

      // Hapus dokumen
      await _firestore.collection(_koleksi).doc(id).delete();

      developer.log(
        '✅ Berhasil menghapus kritik saran dari Firebase dengan ID: $id',
      );
    } catch (e) {
      developer.log('❌ Gagal menghapus kritik saran dari Firebase: $e');
      rethrow;
    }
  }

  /// Menghapus beberapa kritik saran sekaligus dari Firebase (batch delete)
  Future<void> hapusBatchKritikSaranDariFirebase(List<String> daftarId) async {
    try {
      final WriteBatch batch = _firestore.batch();

      for (String id in daftarId) {
        final docRef = _firestore.collection(_koleksi).doc(id);
        batch.delete(docRef);
      }

      await batch.commit();
      developer.log(
        '✅ Berhasil menghapus ${daftarId.length} kritik saran dari Firebase',
      );
    } catch (e) {
      developer.log('❌ Gagal menghapus batch kritik saran dari Firebase: $e');
      rethrow;
    }
  }

  /// Menghapus semua kritik saran dari user tertentu di Firebase
  Future<void> hapusKritikSaranByUserIdDariFirebase(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_koleksi)
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) {
        developer.log('ℹ️ Tidak ada kritik saran dari user $userId');
        return;
      }

      final WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      developer.log(
        '✅ Berhasil menghapus ${snapshot.docs.length} kritik saran dari user $userId',
      );
    } catch (e) {
      developer.log(
        '❌ Gagal menghapus kritik saran by userId dari Firebase: $e',
      );
      rethrow;
    }
  }

  // ==================== OPERASI SINKRONISASI ====================

  /// Menghapus kritik saran secara menyeluruh (Firebase + lokal)
  Future<void> hapusKritikSaranSepenuhnya(String id) async {
    try {
      // Hapus dari Firebase
      await hapusKritikSaranDariFirebase(id);

      // Hapus dari database lokal
      await _operasiLokal.hapusKritikSaran(id);

      developer.log(
        '✅ Berhasil menghapus kritik saran secara menyeluruh dengan ID: $id',
      );
    } catch (e) {
      developer.log('❌ Gagal menghapus kritik saran secara menyeluruh: $e');
      rethrow;
    }
  }

  /// Sinkronisasi: mengambil data dari Firebase dan menyimpannya ke lokal
  Future<void> sinkronisasiDariFirebase() async {
    try {
      developer.log('🔄 Memulai sinkronisasi kritik saran dari Firebase...');

      final dataFirebase = await getKritikSaranDariFirebase();

      if (dataFirebase.isNotEmpty) {
        await _operasiLokal.sisipkanAtauPerbaruiBatch(dataFirebase);
        developer.log(
          '✅ Sinkronisasi selesai: ${dataFirebase.length} data disimpan ke lokal',
        );
      } else {
        developer.log('ℹ️ Tidak ada data yang perlu disinkronisasi');
      }
    } catch (e) {
      developer.log('❌ Gagal sinkronisasi dari Firebase: $e');
      rethrow;
    }
  }

  /// Sinkronisasi: mengirim data lokal yang belum ada di Firebase
  Future<void> sinkronisasiKeFirebase(DateTime lastSync) async {
    try {
      developer.log('🔄 Mengirim perubahan ke Firebase...');

      final perubahanLokal = await _operasiLokal.getPerubahan(lastSync);

      if (perubahanLokal.isEmpty) {
        developer.log('ℹ️ Tidak ada perubahan lokal yang perlu dikirim');
        return;
      }

      for (var item in perubahanLokal) {
        if (item.id != null) {
          // Cek apakah sudah ada di Firebase
          final docSnapshot = await _firestore
              .collection(_koleksi)
              .doc(item.id)
              .get();

          if (docSnapshot.exists) {
            // Update data yang sudah ada
            await perbaruiKritikSaranDiFirebase(item);
          } else {
            // Tambah data baru dengan ID spesifik
            await _firestore
                .collection(_koleksi)
                .doc(item.id)
                .set(item.toMap());
          }
        } else {
          // Jika tidak ada ID, tambah sebagai dokumen baru
          await tambahKritikSaranKeFirebase(item);
        }
      }

      developer.log(
        '✅ Berhasil mengirim ${perubahanLokal.length} perubahan ke Firebase',
      );
    } catch (e) {
      developer.log('❌ Gagal sinkronisasi ke Firebase: $e');
      rethrow;
    }
  }
}
