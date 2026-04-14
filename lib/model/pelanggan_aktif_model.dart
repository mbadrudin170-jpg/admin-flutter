// lib/model/pelanggan_aktif_model.dart
enum StatusPembayaran { lunas, belumLunas }

extension StatusPembayaranExtension on StatusPembayaran {
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
  final String idPaket;
  final String idPelanggan;
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
    StatusPembayaran statusPembayaran;
    final statusString = map['status'] as String?;

    // Logika parsing yang aman
    if (statusString == 'lunas') {
      statusPembayaran = StatusPembayaran.lunas;
    } else {
      // Jika nilainya 'tidakLunas', null, atau data rusak lainnya,
      // kita akan set default ke tidakLunas.
      statusPembayaran = StatusPembayaran.belumLunas;
    }
    return PelangganAktif(
      id: map['id'] as int?,
      idPelanggan: map['id_pelanggan'],
      idPaket: map['id_paket'],
      tanggalMulai: map['tanggalMulai'],
      tanggalBerakhir: map['tanggalBerakhir'],
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
