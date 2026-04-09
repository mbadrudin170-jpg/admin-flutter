import 'package:admin/model/kategori_model.dart';

final List<Kategori> kategoriData = [
  Kategori(
    id: '1',
    nama: 'Gaji',
    tipe: TipeKategori.pemasukan,
    subKategori: [],
  ),
  Kategori(
    id: '2',
    nama: 'Penjualan',
    tipe: TipeKategori.pemasukan,
    subKategori: [
      SubKategori(id: '2a', nama: 'Penjualan Kiloan'),
      SubKategori(id: '2b', nama: 'Penjualan Satuan'),
    ],
  ),
  Kategori(
    id: '3',
    nama: 'Biaya Operasional',
    tipe: TipeKategori.pengeluaran,
    subKategori: [
      SubKategori(id: '3a', nama: 'Listrik'),
      SubKategori(id: '3b', nama: 'Air'),
      SubKategori(id: '3c', nama: 'Gas'),
    ],
  ),
  Kategori(
    id: '4',
    nama: 'Bahan Baku',
    tipe: TipeKategori.pengeluaran,
    subKategori: [
      SubKategori(id: '4a', nama: 'Deterjen'),
      SubKategori(id: '4b', nama: 'Pewangi'),
    ],
  ),
];
