
// lib/data/pelanggan_aktif_data.dart
import 'package:admin/model/pelanggan_aktif.dart';

List<PelangganAktif> pelangganAktifList = [
  PelangganAktif(
    id: "1",
    nama: "Budi Santoso",
    paket: "Internet 50 Mbps",
    tanggalBerakhir: "2024-12-01",
    status: StatusMasaAktif.lunas,
    avatar: "https://i.pravatar.cc/150?img=1",
  ),
  PelangganAktif(
    id: "2",
    nama: "Siti Aminah",
    paket: "Internet 20 Mbps",
    tanggalBerakhir: "2024-11-15",
    status: StatusMasaAktif.tidakLunas,
    avatar: "https://i.pravatar.cc/150?img=2",
  ),
  PelangganAktif(
    id: "3",
    nama: "Joko Susilo",
    paket: "Internet 100 Mbps",
    tanggalBerakhir: "2025-01-10",
    status: StatusMasaAktif.lunas,
    avatar: "https://i.pravatar.cc/150?img=3",
  ),
];
