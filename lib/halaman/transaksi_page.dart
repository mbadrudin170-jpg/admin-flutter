import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/transaksi_data.dart';
import 'package:myapp/model/transaksi_model.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarTransaksi.length,
        itemBuilder: (context, index) {
          final transaksi = daftarTransaksi[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(
                transaksi.pelanggan.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paket: ${transaksi.paket.nama}'),
                  Text(
                      'Tanggal: ${DateFormat('dd MMMM yyyy').format(transaksi.tanggal)}'),
                ],
              ),
              trailing: Text(
                transaksi.status.name.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(transaksi.status),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.berhasil:
        return Colors.green;
      case StatusTransaksi.pending:
        return Colors.orange;
      case StatusTransaksi.gagal:
        return Colors.red;
    }
  }
}
