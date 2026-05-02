// path : lib/halaman/tab/transaksi.dart
// Halaman ini menampilkan daftar semua transaksi dan ringkasannya.
// Data diambil secara terpusat dan diteruskan ke widget yang relevan.

import 'package:admin_wifi/utils/format_util.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/halaman/form/form_transaksi.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import '../detail/detail_transaksi.dart';

// diubah: RingkasanTransaksi sekarang menjadi StatelessWidget yang hanya menerima data.
class RingkasanTransaksi extends StatelessWidget {
  final double pemasukan;
  final double pengeluaran;
  final double total;

  const RingkasanTransaksi({
    super.key,
    required this.pemasukan,
    required this.pengeluaran,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfo(context, 'Pemasukan', pemasukan, Colors.green),
            _buildInfo(context, 'Pengeluaran', pengeluaran, Colors.red),
            _buildInfo(
              context,
              'Total',
              total,
              total >= 0 ? Colors.blue : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // untuk membangun tampilan info ringkasan
  Widget _buildInfo(
      BuildContext context, String label, double jumlah, Color warna) {
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

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    // diubah: Inisialisasi Future secara langsung untuk menghindari LateInitializationError.
    _dataFuture = _getData();
  }

  // diubah: Menggabungkan semua pengambilan data ke dalam satu fungsi.
  Future<Map<String, dynamic>> _getData() async {
    final results = await Future.wait([
      _transaksiOperasi.ambilSemuaTransaksi(),
      _transaksiOperasi.getTotalPemasukan(),
      _transaksiOperasi.getTotalPengeluaran(),
      _transaksiOperasi.getNetTotal(),
    ]);
    return {
      'transaksi': results[0] as List<TransaksiModel>,
      'pemasukan': results[1] as double,
      'pengeluaran': results[2] as double,
      'total': results[3] as double,
    };
  }

  // untuk memuat atau memuat ulang semua data dengan setState untuk memicu rebuild.
  void _loadData() {
    setState(() {
      _dataFuture = _getData();
    });
  }

  // untuk menavigasi ke halaman tambah transaksi dan memuat ulang data jika berhasil.
  void _tambahTransaksi() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormTransaksiPage()),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Tidak ada data ditemukan.'));
          }

          final data = snapshot.data!;
          final pemasukan = data['pemasukan'] ?? 0.0;
          final pengeluaran = data['pengeluaran'] ?? 0.0;
          final total = data['total'] ?? 0.0;
          final transaksiData = data['transaksi'] as List<TransaksiModel>;

          return Column(
            children: [
              RingkasanTransaksi(
                pemasukan: pemasukan,
                pengeluaran: pengeluaran,
                total: total,
              ),
              Expanded(
                child: transaksiData.isEmpty
                    ? const Center(
                        child: Text('Tidak ada transaksi ditemukan.'),
                      )
                    : _buildTransaksiList(transaksiData),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahTransaksi,
        child: const Icon(Icons.add),
      ),
    );
  }

  // untuk membangun daftar transaksi yang dikelompokkan berdasarkan tanggal.
  Widget _buildTransaksiList(List<TransaksiModel> transaksiData) {
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
                  : -item.jumlah),
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

  // untuk membangun header seksi per tanggal
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

  // untuk membangun satu item dalam daftar transaksi
  Widget _bangunItemTransaksi(TransaksiModel transaksi) {
    IconData iconData;
    Color iconColor;
    if (transaksi.tipe == TipeTransaksi.pemasukan) {
      iconData = Icons.arrow_downward;
      iconColor = Colors.green;
    } else {
      iconData = Icons.arrow_upward;
      iconColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTransaksiPage(transaksi: transaksi),
            ),
          ).then((_) => _loadData());
        },
        leading: CircleAvatar(
          backgroundColor: iconColor.withAlpha(25),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          transaksi.keterangan.isNotEmpty
              ? transaksi.keterangan
              : transaksi.namaKategori,
        ),
        subtitle: Text(transaksi.namaDompet),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              FormatUang.formatMataUang(transaksi.jumlah),
              style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
            ),
            Text(FormatJam.formatJamMenit(transaksi.tanggal)),
          ],
        ),
      ),
    );
  }

  // untuk mengelompokkan transaksi berdasarkan tanggal
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
