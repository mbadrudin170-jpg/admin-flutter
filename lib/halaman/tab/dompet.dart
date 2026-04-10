// lib/halaman/tab/dompet.dart
import 'package:flutter/material.dart';
import 'package:admin/data/operasi/dompet_operasi.dart';
import 'package:admin/halaman/detail/detail_dompet.dart';
import 'package:admin/halaman/form/form_dompet.dart';
import 'package:admin/model/dompet_model.dart';
import 'package:admin/utils/format.dart';

class DompetPage extends StatefulWidget {
  const DompetPage({super.key});

  @override
  State<DompetPage> createState() => _DompetPageState();
}

class _DompetPageState extends State<DompetPage> {
  final DompetOperasi _dompetOperasi = DompetOperasi();
  late Future<List<Dompet>> _listaDompetFuture;

  @override
  void initState() {
    super.initState();
    _loadDompet();
  }

  void _loadDompet() {
    setState(() {
      _listaDompetFuture = _dompetOperasi.getDompet();
    });
  }

  void _tambahDompet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormDompet()),
    );
    if (result == true) {
      _loadDompet(); // Muat ulang daftar dompet jika ada penambahan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const RingkasanKeuangan(),
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
                          ).then((value) => _loadDompet());
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

class RingkasanKeuangan extends StatelessWidget {
  const RingkasanKeuangan({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: Anda perlu mengganti nilai placeholder ini dengan data asli
    // dari operasi transaksi Anda.
    const double pemasukan = 0.0;
    const double pengeluaran = 0.0;
    final double total = pemasukan - pengeluaran;

    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfo('Pemasukan', pemasukan, Colors.green),
            _buildInfo('Pengeluaran', pengeluaran, Colors.red),
            _buildInfo('Total', total, Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, double amount, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Text(
          'Rp ${Format.formatAngka(amount)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
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
          'Saldo: Rp ${Format.formatAngka(dompet.saldo)}',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        onTap: onTap,
      ),
    );
  }
}
