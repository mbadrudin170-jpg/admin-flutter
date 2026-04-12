// lib/model/pelanggan_aktif_model.dart
enum StatusPembayaran { lunas, tidakLunas }

class PelangganAktif {
  final int? id;
  final String idPaket;
  final String idPelanggan;
  final String tanggalMulai;
  final String tanggalBerakhir;
  final StatusPembayaran status;

  PelangganAktif({
    this.id,
    required this.idPelanggan,
    required this.idPaket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
  });

  factory PelangganAktif.fromMap(Map<String, dynamic> map) {
    return PelangganAktif(
      id: map['id'] as int?,
      idPelanggan: map['id_pelanggan'],
      idPaket: map['id_paket'],
      tanggalMulai: map['tanggalMulai'],
      tanggalBerakhir: map['tanggalBerakhir'],
      status: StatusPembayaran.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => StatusPembayaran.tidakLunas,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,
      'tanggalMulai': tanggalMulai,
      'tanggalBerakhir': tanggalBerakhir,
      'status': status.toString().split('.').last,
    };
  }
}
