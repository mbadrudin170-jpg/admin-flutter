// lib/model/pelanggan_aktif_model.dart
enum StatusPembayaran { lunas, tidakLunas }

class PelangganAktif {
  final int? id; 
  final String nama;
  final String paket;
  final String tanggalMulai;
  final String tanggalBerakhir;
  final StatusPembayaran status;

  PelangganAktif({
    this.id,
    required this.nama,
    required this.paket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
  });

  factory PelangganAktif.fromMap(Map<String, dynamic> map) {
    return PelangganAktif(
      id: map['id'] as int?,
      nama: map['nama'],
      paket: map['paket'],
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
      'nama': nama,
      'paket': paket,
      'tanggalMulai': tanggalMulai,
      'tanggalBerakhir': tanggalBerakhir,
      'status': status.toString().split('.').last,
    };
  }
}
