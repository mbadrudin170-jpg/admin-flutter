// lib/model/pelanggan_aktif.dart
enum StatusMasaAktif { lunas, tidakLunas }

class PelangganAktif {
  final String id; // Diubah dari int ke String
  final String nama;
  final String paket;
  final String tanggalBerakhir;
  final StatusMasaAktif status;
  final String avatar;

  PelangganAktif({
    required this.id,
    required this.nama,
    required this.paket,
    required this.tanggalBerakhir,
    required this.status,
    this.avatar = '',
  });

  // Konversi dari Map (Firestore) ke objek PelangganAktif
  factory PelangganAktif.fromMap(Map<String, dynamic> map) {
    return PelangganAktif(
      id: map['id'].toString(), // Pastikan id selalu string
      nama: map['nama'],
      paket: map['paket'],
      tanggalBerakhir: map['tanggalBerakhir'],
      status: StatusMasaAktif.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => StatusMasaAktif.tidakLunas, // Default jika tidak ditemukan
      ),
      avatar: map['avatar'] ?? '',
    );
  }

  // Konversi dari objek PelangganAktif ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'paket': paket,
      'tanggalBerakhir': tanggalBerakhir,
      'status': status.toString().split('.').last,
      'avatar': avatar,
    };
  }
}
