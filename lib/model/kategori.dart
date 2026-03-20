
enum TipeKategori {
  pemasukan,
  pengeluaran,
}

class Kategori {
  final String id;
  final String nama;
  final TipeKategori tipe;
  final List<SubKategori> subKategori;

  Kategori({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.subKategori,
  });
}

class SubKategori {
  final String id;
  final String nama;

  SubKategori({
    required this.id,
    required this.nama,
  });
}
