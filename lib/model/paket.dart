enum TipeDurasi { jam, hari, bulan }

class Paket {
  final String nama;
  final int harga;
  final int durasi;
  final TipeDurasi tipe;

  Paket({
    required this.nama,
    required this.harga,
    required this.durasi,
    required this.tipe,
  });
}
