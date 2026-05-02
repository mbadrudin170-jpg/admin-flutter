class PesananModel {
  final int? id;
  final String idPelanggan;
  final String idPaket;
  final DateTime tanggal;

  PesananModel({
    this.id,
    required this.idPelanggan,
    required this.idPaket,
    required this.tanggal,
  });

  // Untuk simpan ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'id_paket': idPaket,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  // Untuk ambil dari SQLite
  factory PesananModel.fromMap(Map<String, dynamic> map) {
    return PesananModel(
      id: map['id'],
      idPelanggan: map['id_pelanggan'],
      idPaket: map['id_paket'],
      tanggal: DateTime.parse(map['tanggal']),
    );
  }
}
