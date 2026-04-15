// lib/model/paket_model.dart

// Enum untuk tipe durasi paket
enum TipeDurasi {
  jam,
  hari,
  bulan;

  // Getter untuk mendapatkan nama yang ramah pengguna
  String get displayName {
    switch (this) {
      case TipeDurasi.jam:
        return 'Jam';
      case TipeDurasi.hari:
        return 'Hari';
      case TipeDurasi.bulan:
        return 'Bulan';
    }
  }
}

class Paket {
  final int? id; // ID dari database (nullable untuk paket baru)
  final String nama;
  final int harga;
  final int durasi;
  final TipeDurasi tipe;

  Paket({
    this.id,
    required this.nama,
    required this.harga,
    required this.durasi,
    required this.tipe,
  });

  // Konversi dari Map (dari database) ke objek Paket
  factory Paket.fromMap(Map<String, dynamic> map) {
    return Paket(
      id: map['id'],
      nama: map['nama'],
      harga: map['harga'],
      durasi: map['durasi'],
      tipe: TipeDurasi.values.firstWhere(
        (e) => e.name == map['tipe'], // Mencocokkan berdasarkan nama enum
        orElse: () => TipeDurasi.hari, // Default jika ada data korup
      ),
    );
  }

  // Konversi dari objek Paket ke Map (untuk database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'durasi': durasi,
      'tipe': tipe.name, // Menyimpan nama enum sebagai string
    };
  }
}
