// Path: lib/model/riwayat_langganan_model.dart

import 'enum/status_pembayaran.dart'; // Mengimpor enum terpusat

class RiwayatLanggananModel {
  final String id;
  final String idPelanggan;
  final String idPaket;
  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final StatusPembayaran status;
  final DateTime? diperbarui;

  RiwayatLanggananModel({
    required this.id,
    required this.idPelanggan,
    required this.idPaket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
    this.diperbarui,
  });

  factory RiwayatLanggananModel.fromMap(Map<String, dynamic> map) {
    return RiwayatLanggananModel(
      id: map['id'],
      idPelanggan: map['id_pelanggan'],
      idPaket: map['id_paket'],
      tanggalMulai: DateTime.parse(map['tanggalMulai']),
      tanggalBerakhir: DateTime.parse(map['tanggalBerakhir']),
      status: StatusPembayaran.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => StatusPembayaran.lunas,
      ),
      diperbarui: map['diperbarui'] != null
          ? DateTime.parse(map['diperbarui'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,
      'tanggalMulai': tanggalMulai.toIso8601String(),
      'tanggalBerakhir': tanggalBerakhir.toIso8601String(),
      'status': status.name,
      'diperbarui': diperbarui?.toIso8601String(),
    };
  }
}
