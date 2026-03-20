// lib/transaksi.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/operasi/transaksi_operasi.dart';
import 'package:myapp/halaman/form/form_transaksi.dart';
import 'package:myapp/model/transaksi_model.dart';
import 'package:myapp/utils/format_tanggal.dart';

import 'halaman/detail/detail_transaksi.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  late Future<List<Transaksi>> _listaTransaksiFuture;

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  void _loadTransaksi() {
    setState(() {
      _listaTransaksiFuture = _transaksiOperasi.getTransaksi();
    });
  }

  void _tambahTransaksi() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormTransaksiPage()),
    );
    if (result == true) {
      _loadTransaksi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Transaksi>>(
        future: _listaTransaksiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada transaksi ditemukan.'));
          } else {
            final transaksiData = snapshot.data!;
            final groupedTransaksi = _groupTransaksiByDate(transaksiData);
            final pemasukan = transaksiData
                .where((t) => t.tipe == TipeTransaksi.pemasukan)
                .fold(0.0, (sum, item) => sum + item.jumlah);
            final pengeluaran = transaksiData
                .where((t) => t.tipe == TipeTransaksi.pengeluaran)
                .fold(0.0, (sum, item) => sum + item.jumlah);
            final transfer = transaksiData
                .where((t) => t.tipe == TipeTransaksi.transfer)
                .fold(0.0, (sum, item) => sum + item.jumlah);

            return Column(
              children: [
                _bangunRingkasan(pemasukan, pengeluaran, transfer),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedTransaksi.length,
                    itemBuilder: (context, index) {
                      final tanggal = groupedTransaksi.keys.elementAt(index);
                      final transaksiPadaTanggal = groupedTransaksi[tanggal]!;
                      final totalPadaTanggal = transaksiPadaTanggal.fold(
                          0.0,
                          (sum, item) =>
                              sum + (item.tipe == TipeTransaksi.pemasukan ? item.jumlah : -item.jumlah));

                      return Column(
                        children: [
                          _bangunHeaderSeksi(tanggal, totalPadaTanggal),
                          ...transaksiPadaTanggal
                              .map((transaksi) => _bangunItemTransaksi(transaksi))
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahTransaksi,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bangunRingkasan(double pemasukan, double pengeluaran, double transfer) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bangunInfo('Pemasukan', pemasukan, Colors.green),
          _bangunInfo('Pengeluaran', pengeluaran, Colors.red),
          _bangunInfo('Transfer', transfer, Colors.blue),
        ],
      ),
    );
  }

  Widget _bangunInfo(String label, double jumlah, Color warna) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(jumlah),
          style: TextStyle(color: warna, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _bangunHeaderSeksi(DateTime tanggal, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            FormatTanggal.formatTanggal(tanggal),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: total >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunItemTransaksi(Transaksi transaksi) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTransaksiPage(transaksi: transaksi),
          ),
        );
      },
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(transaksi.kategori.nama),
          Text(transaksi.subKategori.nama, style: const TextStyle(fontSize: 12)),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transaksi.keterangan),
          Text(transaksi.namaDompet, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(transaksi.jumlah),
            style: TextStyle(
              color: transaksi.tipe == TipeTransaksi.pemasukan
                  ? Colors.green
                  : (transaksi.tipe == TipeTransaksi.pengeluaran ? Colors.red : Colors.blue),
            ),
          ),
          Text(FormatTanggal.formatJam(transaksi.tanggal)),
        ],
      ),
    );
  }

  Map<DateTime, List<Transaksi>> _groupTransaksiByDate(List<Transaksi> transaksi) {
    final Map<DateTime, List<Transaksi>> grouped = {};
    for (final t in transaksi) {
      final date = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(t);
    }
    return grouped;
  }
}
