// path: lib/halaman/detail/detail_transaksi.dart
// Halaman ini menampilkan detail dari satu transaksi.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
// diubah: Mengimpor file utilitas terpusat.
import 'package:admin_wifi/utils/format_util.dart';

class DetailTransaksiPage extends StatelessWidget {
  final TransaksiModel transaksi;

  const DetailTransaksiPage({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', transaksi.id),
            _buildDetailRow('Keterangan', transaksi.keterangan),
            // diubah: Memperbaiki pemanggilan fungsi format tanggal.
            _buildDetailRow(
              'Tanggal',
              FormatTanggal.formatTanggalDanJam(transaksi.tanggal),
            ),
            _buildDetailRow(
              'Jumlah',
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
              ).format(transaksi.jumlah),
            ),
            _buildDetailRow('Tipe', transaksi.tipe.toString().split('.').last),
            _buildDetailRow('Nama Dompet', transaksi.namaDompet),
            _buildDetailRow('Kategori', transaksi.namaKategori), // Perbaikan
            _buildDetailRow(
              'Sub Kategori',
              transaksi.namaSubKategori ?? '-',
            ), // Perbaikan
            // Menampilkan detail pelanggan dan paket jika ada
            if (transaksi.namaPelanggan != null)
              _buildDetailRow('Pelanggan', transaksi.namaPelanggan!),
            if (transaksi.namaPaket != null)
              _buildDetailRow('Paket', transaksi.namaPaket!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
