import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/transaksi_model.dart';
import 'package:myapp/utils/format_tanggal.dart';

class DetailTransaksiPage extends StatelessWidget {
  final Transaksi transaksi;

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
            _buildDetailRow('Tanggal', FormatTanggal.formatTanggalAngkaJam(transaksi.tanggal)),
            _buildDetailRow('Jumlah', NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(transaksi.jumlah)),
            _buildDetailRow('Tipe', transaksi.tipe.toString().split('.').last),
            _buildDetailRow('Nama Dompet', transaksi.namaDompet),
            _buildDetailRow('Kategori', transaksi.kategori.nama),
            _buildDetailRow('Sub Kategori', transaksi.subKategori.nama),

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
          Text(value),
        ],
      ),
    );
  }
}
