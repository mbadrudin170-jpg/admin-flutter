// lib/halaman/tab/dompet.dart
// File ini menampilkan halaman dompet yang berisi ringkasan keuangan (pemasukan, pengeluaran, total)
// dan daftar semua dompet yang tersedia. Pengguna dapat menambahkan dompet baru melalui
// tombol floating action.

import 'package:admin_wifi/utils/format_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_dompet.dart';
import 'package:admin_wifi/halaman/form/form_dompet.dart';
import 'package:admin_wifi/model/dompet_model.dart';

class DompetPage extends StatefulWidget {
  const DompetPage({super.key});

  @override
  State<DompetPage> createState() => _DompetPageState();
}

class _DompetPageState extends State<DompetPage> {
  final DompetOperasi _dompetOperasi = DompetOperasi();
  // Mengubah menjadi kunci untuk refresh FutureBuilder di RingkasanKeuangan
  final GlobalKey<_RingkasanKeuanganState> _ringkasanKey = GlobalKey();
  late Future<List<Dompet>> _listaDompetFuture;

  @override
  void initState() {
    super.initState();
    _loadDompet();
  }

  void _loadDompet() {
    setState(() {
      _listaDompetFuture = _dompetOperasi.getDompet();
      // Panggil metode refresh di RingkasanKeuangan jika sudah terbangun
      _ringkasanKey.currentState?.refresh();
    });
  }

  void _tambahDompet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormDompet()),
    );
    if (result == true) {
      _loadDompet(); // Muat ulang daftar dompet DAN ringkasan keuangan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dompet')),
      body: Column(
        children: [
          // Berikan kunci ke RingkasanKeuangan
          RingkasanKeuangan(key: _ringkasanKey),
          Expanded(
            child: FutureBuilder<List<Dompet>>(
              future: _listaDompetFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada dompet ditemukan.'),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final dompet = snapshot.data![index];
                      return DompetCard(
                        dompet: dompet,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailDompet(dompet: dompet),
                            ),
                          ).then(
                            (_) => _loadDompet(),
                          ); // Muat ulang setelah dari detail
                        },
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
        onPressed: _tambahDompet,
        tooltip: 'Tambah Dompet',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Mengubah menjadi StatefulWidget untuk mengelola state future-nya sendiri
class RingkasanKeuangan extends StatefulWidget {
  const RingkasanKeuangan({super.key});

  @override
  State<RingkasanKeuangan> createState() => _RingkasanKeuanganState();
}

class _RingkasanKeuanganState extends State<RingkasanKeuangan> {
  final DompetOperasi _dompetOperasi = DompetOperasi();
  late Future<List<double>> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() {
    _summaryFuture = Future.wait([
      _dompetOperasi.getTotalSaldoPositif(),
      _dompetOperasi.getTotalSaldoNegatif(),
      _dompetOperasi.getTotalSaldo(),
    ]);
  }

  // Metode ini bisa dipanggil dari parent untuk refresh
  void refresh() {
    setState(() {
      _loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<double>>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        double pemasukan = 0.0;
        double pengeluaran = 0.0;
        double total = 0.0;

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final result = snapshot.data!;
          pemasukan = result[0];
          pengeluaran = result[1].abs(); // Tampilkan sebagai angka positif
          total = result[2];
        }

        // Tampilkan card dengan data (atau 0 jika masih loading/error)
        return Card(
          margin: const EdgeInsets.all(12.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfo('Pemasukan', pemasukan, Colors.green),
                      _buildInfo('Pengeluaran', pengeluaran, Colors.red),
                      _buildInfo(
                        'Total',
                        total,
                        Theme.of(context).colorScheme.primary,
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

class DompetCard extends StatelessWidget {
  final Dompet dompet;
  final VoidCallback onTap;

  const DompetCard({super.key, required this.dompet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(
          Icons.account_balance_wallet,
          size: 40,
          color: Colors.blueAccent,
        ),
        title: Text(
          dompet.namaDompet,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          'Saldo: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(dompet.saldo)}',
          style: TextStyle(
            fontSize: 16,
            color: dompet.saldo < 0 ? Colors.red : Colors.black54,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
