// lib/halaman/tab/transaksi.dart
// Halaman ini menampilkan daftar semua transaksi, dikelompokkan berdasarkan tanggal.
// Ini juga mencakup ringkasan total pemasukan, pengeluaran, dan transfer.
// Pengguna dapat menambahkan transaksi baru melalui tombol floating action.

import 'package:admin_wifi/utils/format_util.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/halaman/form/form_transaksi.dart';
import 'package:admin_wifi/model/transaksi_model.dart';

import '../detail/detail_transaksi.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  late Future<List<TransaksiModel>> _listaTransaksiFuture;
  final GlobalKey<_RingkasanTransaksiState> _ringkasanKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  void _loadTransaksi() {
    setState(() {
      _listaTransaksiFuture = _transaksiOperasi.ambilSemuaTransaksi();
      _ringkasanKey.currentState?.refresh();
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
      appBar: AppBar(title: const Text('Transaksi')),
      body: Column(
        children: [
          RingkasanTransaksi(key: _ringkasanKey),
          Expanded(
            child: FutureBuilder<List<TransaksiModel>>(
              future: _listaTransaksiFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada transaksi ditemukan.'),
                  );
                } else {
                  final transaksiData = snapshot.data!;
                  final groupedTransaksi = _groupTransaksiByDate(transaksiData);

                  return ListView.builder(
                    itemCount: groupedTransaksi.length,
                    itemBuilder: (context, index) {
                      final tanggal = groupedTransaksi.keys.elementAt(index);
                      final transaksiPadaTanggal = groupedTransaksi[tanggal]!;
                      final totalPadaTanggal = transaksiPadaTanggal.fold(
                        0.0,
                        (sum, item) =>
                            sum +
                            (item.tipe == TipeTransaksi.pemasukan
                                ? item.jumlah
                                : (item.tipe == TipeTransaksi.pengeluaran
                                      ? -item.jumlah
                                      : 0)),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bangunHeaderSeksi(tanggal, totalPadaTanggal),
                          ...transaksiPadaTanggal.map(
                            (transaksi) => _bangunItemTransaksi(transaksi),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahTransaksi,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bangunHeaderSeksi(DateTime tanggal, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            FormatTanggal.formatTanggalBasic(tanggal),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            FormatUang.formatMataUang(total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: total >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunItemTransaksi(TransaksiModel transaksi) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTransaksiPage(transaksi: transaksi),
            ),
          ).then((_) => _loadTransaksi());
        },
        // leading: CircleAvatar(
        //   child: Icon(transaksi.kategori.iconData),
        // ),
        title: Text(
          transaksi.keterangan.isNotEmpty
              ? transaksi.keterangan
              : transaksi.kategori.nama,
        ),
        subtitle: Text(transaksi.namaDompet),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              FormatUang.formatMataUang(transaksi.jumlah),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaksi.tipe == TipeTransaksi.pemasukan
                    ? Colors.green
                    : (transaksi.tipe == TipeTransaksi.pengeluaran
                          ? Colors.red
                          : Colors.blue),
              ),
            ),
            Text(FormatJam.formatJamMenit(transaksi.tanggal)),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<TransaksiModel>> _groupTransaksiByDate(
    List<TransaksiModel> transaksi,
  ) {
    final Map<DateTime, List<TransaksiModel>> grouped = {};
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

class RingkasanTransaksi extends StatefulWidget {
  const RingkasanTransaksi({super.key});

  @override
  State<RingkasanTransaksi> createState() => _RingkasanTransaksiState();
}

class _RingkasanTransaksiState extends State<RingkasanTransaksi> {
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  late Future<Map<String, double>> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() {
    _summaryFuture = _getSummaryData();
  }

  Future<Map<String, double>> _getSummaryData() async {
    // Panggil semua future secara bersamaan untuk efisiensi
    final results = await Future.wait([
      _transaksiOperasi.getTotalPemasukan(),
      _transaksiOperasi.getTotalPengeluaran(),
      _transaksiOperasi.getNetTotal(),
    ]);
    return {
      'pemasukan': results[0],
      'pengeluaran': results[1],
      'total': results[2],
    };
  }

  void refresh() {
    setState(() {
      _loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(28.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Ambil data dari snapshot, jika tidak ada, gunakan 0.0
        final pemasukan = snapshot.data?['pemasukan'] ?? 0.0;
        final pengeluaran = snapshot.data?['pengeluaran'] ?? 0.0;
        final total = snapshot.data?['total'] ?? 0.0;

        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfo('Pemasukan', pemasukan, Colors.green),
                _buildInfo('Pengeluaran', pengeluaran, Colors.red),
                // Tampilkan total dengan warna dinamis
                _buildInfo(
                  'Total',
                  total,
                  total >= 0 ? Colors.blue : Colors.red,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfo(String label, double jumlah, Color warna) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          FormatUang.formatMataUang(jumlah),
          style: TextStyle(
            color: warna,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
