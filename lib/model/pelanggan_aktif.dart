enum StatusMasaAktif { lunas, tidakLunas }

class PelangganAktif {
  final int id;
  final String nama;
  final String paket;
  final String tanggalBerakhir;
  final StatusMasaAktif status;
  final String avatar; // Menambahkan properti avatar

  PelangganAktif({
    required this.id,
    required this.nama,
    required this.paket,
    required this.tanggalBerakhir,
    required this.status,
    this.avatar = '', // Menambahkan avatar ke konstruktor dengan nilai default
  });
}
