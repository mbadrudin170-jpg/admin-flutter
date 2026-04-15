// lib/model/pelanggan_aktif_model.dart
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
  final int? id;
  final String idPelanggan; 
  final int idPaket;
  final String tanggalMulai;
  final String tanggalBerakhir;
  final StatusPembayaran status;
  final DateTime? diperbarui;

  PelangganAktif({
    this.id,
    required this.idPelanggan,
    required this.idPaket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
    this.diperbarui,
  });

  factory PelangganAktif.fromMap(Map<String, dynamic> map) {
    final statusString = map['status'] as String?;
    StatusPembayaran statusPembayaran;
    if (statusString == 'lunas') {
      statusPembayaran = StatusPembayaran.lunas;
    } else {
      statusPembayaran = StatusPembayaran.belumLunas;
    }
    return PelangganAktif(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      idPelanggan: map['id_pelanggan'].toString(),
      idPaket: int.tryParse(map['id_paket'].toString()) ?? 0,
      tanggalMulai: map['tanggalMulai'] ?? '',
      tanggalBerakhir: map['tanggalBerakhir'] ?? '',
      status: statusPembayaran,
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
      'tanggalMulai': tanggalMulai,
      'tanggalBerakhir': tanggalBerakhir,
      'status': status.name,
      'diperbarui': diperbarui?.toIso8601String(),
    };
  }
}
