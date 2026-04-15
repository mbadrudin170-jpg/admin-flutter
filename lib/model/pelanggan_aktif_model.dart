// lib/model/pelanggan_aktif_model.dart
import 'package:uuid/uuid.dart';

// Enum untuk status pembayaran
enum StatusPembayaran {
  lunas,
  belumLunas;

  String get displayName {
    switch (this) {
      case StatusPembayaran.lunas:
        return 'Lunas';
      case StatusPembayaran.belumLunas:
        return 'Belum Lunas';
    }
  }
}

class PelangganAktif {
  final String? id;
  final String idPelanggan;
  final String idPaket;
  final String tanggalMulai;
  final String tanggalBerakhir;
  final StatusPembayaran status;
  final DateTime? diperbarui;
  final String statusSinkronisasi;

  PelangganAktif({
    String? id,
    required this.idPelanggan,
    required this.idPaket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
    this.diperbarui,
    this.statusSinkronisasi = 'SINKRON', // Default value
  }) : id = id ?? const Uuid().v4();

  // Konversi dari Map ke objek
  factory PelangganAktif.fromMap(Map<String, dynamic> map) {
    return PelangganAktif(
      id: map['id'],
      idPelanggan: map['id_pelanggan'],
      idPaket: map['id_paket'],
      tanggalMulai: map['tanggalMulai'],
      tanggalBerakhir: map['tanggalBerakhir'],
      status: StatusPembayaran.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => StatusPembayaran.lunas,
      ),
      diperbarui: map['diperbarui'] != null ? DateTime.parse(map['diperbarui']) : null,
      statusSinkronisasi: map['status_sinkronisasi'] ?? 'SINKRON',
    );
  }

  // Konversi dari objek ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,
      'tanggalMulai': tanggalMulai,
      'tanggalBerakhir': tanggalBerakhir,
      'status': status.name,
      'diperbarui': diperbarui?.toIso8601String(),
      'status_sinkronisasi': statusSinkronisasi,
    };
  }
}
