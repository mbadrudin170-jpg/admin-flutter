// lib/model/pelanggan_aktif.dart
enum StatusPembayaran { lunas, tidakLunas }

class PelangganAktif {
  final String id; // Diubah dari int ke String
  final String nama;
  final String paket;
  final String tanggalMulai;
  final String tanggalBerakhir;
  final StatusPembayaran status;

  PelangganAktif({
    required this.id,
    required this.nama,
    required this.paket,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.status,
  });

  // Konversi dari Map (Firestore) ke objek PelangganAktif
  factory PelangganAktif.fromMap(Map<String, dynamic> map) {
    return PelangganAktif(
      id: map['id'].toString(), // Pastikan id selalu string
      nama: map['nama'],
      paket: map['paket'],
      tanggalMulai: map['tanggalMulai'],
      tanggalBerakhir: map['tanggalBerakhir'],
      status: StatusPembayaran.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () =>
            StatusPembayaran.tidakLunas, // Default jika tidak ditemukan
      ),
    );
  }

  // Konversi dari objek PelangganAktif ke Map (untuk Firestore)
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
