// Path: lib/model/riwayat_langganan_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enum/status_pembayaran.dart';
import 'package:uuid/uuid.dart';

class RiwayatLanggananModel {
  final String id;
  final String idPelanggan;
  final String idPaket;

  // === SNAPSHOT DATA PAKET ===
  final String namaPaket;
  final int hargaPaket;
  final int durasiPaket;
  final String tipeDurasiPaket;

  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final StatusPembayaran status;
  final DateTime? diperbarui;
  final DateTime? diarsipkan;

  RiwayatLanggananModel({
    String? id,
    required this.idPelanggan,
    required this.idPaket,
    required this.namaPaket,
    required this.hargaPaket,
    required this.durasiPaket,
    required this.tipeDurasiPaket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
    this.diperbarui,
    this.diarsipkan,
  }) : id = id ?? const Uuid().v4();

  factory RiwayatLanggananModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is Timestamp) return dateValue.toDate();
      if (dateValue is String) return DateTime.tryParse(dateValue);
      return null;
    }

    return RiwayatLanggananModel(
      id: map['id'] ?? const Uuid().v4(),
      idPelanggan: map['id_pelanggan'] ?? '',
      idPaket: map['id_paket'] ?? '',
      namaPaket: map['nama_paket'] ?? 'Tidak Diketahui',
      hargaPaket: (map['harga_paket'] as num? ?? 0).toInt(),
      durasiPaket: (map['durasi_paket'] as num? ?? 0).toInt(),
      tipeDurasiPaket: map['tipe_durasi_paket'] ?? 'hari',
      tanggalMulai: parseDateTime(map['tanggal_mulai']) ?? DateTime.now(),
      tanggalBerakhir:
          parseDateTime(map['tanggal_berakhir']) ?? DateTime.now(),
      status: StatusPembayaran.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => StatusPembayaran.lunas,
      ),
      diperbarui: parseDateTime(map['diperbarui']),
      diarsipkan: parseDateTime(map['diarsipkan']),
    );
  }

  // Peta untuk unggah ke Firebase (menggunakan Timestamp)
  Map<String, dynamic> toMapForFirebase() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,
      'nama_paket': namaPaket,
      'harga_paket': hargaPaket,
      'durasi_paket': durasiPaket,
      'tipe_durasi_paket': tipeDurasiPaket,
      'tanggal_mulai': Timestamp.fromDate(tanggalMulai),
      'tanggal_berakhir': Timestamp.fromDate(tanggalBerakhir),
      'status': status.name,
      'diperbarui': diperbarui != null ? Timestamp.fromDate(diperbarui!) : null,
      'diarsipkan': diarsipkan != null ? Timestamp.fromDate(diarsipkan!) : null,
    };
  }

  // Peta untuk simpan ke database lokal Sqflite (menggunakan String ISO 8601)
  Map<String, dynamic> toMapForSqflite() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,
      'nama_paket': namaPaket,
      'harga_paket': hargaPaket,
      'durasi_paket': durasiPaket,
      'tipe_durasi_paket': tipeDurasiPaket,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'status': status.name,
      'diperbarui': diperbarui?.toIso8601String(),
      'diarsipkan': diarsipkan?.toIso8601String(),
    };
  }
}
