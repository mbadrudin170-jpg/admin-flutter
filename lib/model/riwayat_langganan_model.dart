// Path: lib/model/riwayat_langganan_model.dart
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
  final String tipeDurasiPaket; // Simpan sebagai string dari enum TipeDurasi

  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final StatusPembayaran status;
  final DateTime? diperbarui;
  final DateTime? diarsipkan;

  RiwayatLanggananModel({
    String? id,
    required this.idPelanggan,
    required this.idPaket,
    required this.namaPaket, // ⚠️ Required, tidak boleh null
    required this.hargaPaket, // ⚠️ Required
    required this.durasiPaket, // ⚠️ Required
    required this.tipeDurasiPaket, // ⚠️ Required
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
    this.diperbarui,
    this.diarsipkan,
  }) : id = id ?? const Uuid().v4(); // Generate UUID jika tidak ada

  factory RiwayatLanggananModel.fromMap(Map<String, dynamic> map) {
    return RiwayatLanggananModel(
      id: map['id'],
      idPelanggan: map['id_pelanggan'],
      idPaket: map['id_paket'],

      // Parse snapshot data
      namaPaket: map['nama_paket'],
      hargaPaket: map['harga_paket'],
      durasiPaket: map['durasi_paket'],
      tipeDurasiPaket: map['tipe_durasi_paket'],

      tanggalMulai: DateTime.parse(
        map['tanggal_mulai'],
      ), // ⚠️ Sesuaikan dengan snake_case
      tanggalBerakhir: DateTime.parse(map['tanggal_berakhir']),
      status: StatusPembayaran.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => StatusPembayaran.lunas,
      ),
      diperbarui: map['diperbarui'] != null
          ? DateTime.parse(map['diperbarui'])
          : null,
      diarsipkan: map['diarsipkan'] != null
          ? DateTime.parse(map['diarsipakan'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,

      // Snapshot data (MASUKKAN KE MAP!)
      'nama_paket': namaPaket,
      'harga_paket': hargaPaket,
      'durasi_paket': durasiPaket,
      'tipe_durasi_paket': tipeDurasiPaket,

      'tanggal_mulai': tanggalMulai.toIso8601String(), // ⚠️ Snake case
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'status': status.name,
      'diperbarui': diperbarui?.toIso8601String(),
      'diarsipkan': diarsipkan?.toIso8601String(),
    };
  }
}
