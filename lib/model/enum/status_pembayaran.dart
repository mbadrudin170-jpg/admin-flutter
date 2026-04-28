// Path: lib/model/enum/status_pembayaran.dart

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
