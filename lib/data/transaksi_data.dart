import 'package:myapp/data/kategori_data.dart';
import 'package:myapp/model/kategori.dart';
import 'package:myapp/model/transaksi_model.dart';

final List<Transaksi> transaksiData = [
  Transaksi(
    id: '1',
    keterangan: 'Gaji Karyawan',
    tanggal: DateTime(2024, 7, 26),
    jumlah: 5000000,
    tipe: TipeTransaksi.pengeluaran,
    namaDompet: 'Kas',
    kategori: kategoriData[2], // Biaya Operasional
    subKategori: kategoriData[2].subKategori[0], // Listrik
  ),
  Transaksi(
    id: '2',
    keterangan: 'Penjualan Kiloan',
    tanggal: DateTime(2024, 7, 26),
    jumlah: 200000,
    tipe: TipeTransaksi.pemasukan,
    namaDompet: 'Kas',
    kategori: kategoriData[1], // Penjualan
    subKategori: kategoriData[1].subKategori[0], // Penjualan Kiloan
  ),
  Transaksi(
    id: '3',
    keterangan: 'Beli Deterjen',
    tanggal: DateTime(2024, 7, 25),
    jumlah: 100000,
    tipe: TipeTransaksi.pengeluaran,
    namaDompet: 'Kas',
    kategori: kategoriData[3], // Bahan Baku
    subKategori: kategoriData[3].subKategori[0], // Deterjen
  ),
  Transaksi(
    id: '4',
    keterangan: 'Transfer ke Bank',
    tanggal: DateTime(2024, 7, 25),
    jumlah: 1000000,
    tipe: TipeTransaksi.transfer,
    namaDompet: 'Kas',
    kategori: kategoriData[0], // Gaji (sebagai contoh, bisa disesuaikan)
    subKategori: SubKategori(id: '0', nama: 'Transfer'), // Contoh subkategori
  ),
];
