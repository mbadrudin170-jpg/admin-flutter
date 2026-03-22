
// lib/halaman/tab/dompet_tab.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/operasi/dompet_operasi.dart';
import 'package:myapp/halaman/detail/detail_dompet.dart';
import 'package:myapp/halaman/form/form_dompet.dart';
import 'package:myapp/model/dompet_model.dart';

class DompetTab extends StatefulWidget {
  const DompetTab({super.key});

  @override
  State<DompetTab> createState() => _DompetTabState();
}

class _DompetTabState extends State<DompetTab> {
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
      body: FutureBuilder<List<Dompet>>(
        future: _listaDompetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada dompet ditemukan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final dompet = snapshot.data![index];
                return ListTile(
                  title: Text(dompet.namaDompet),
                  subtitle: Text('Saldo: Rp ${dompet.saldo.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDompet(dompet: dompet),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahDompet,
        tooltip: 'Tambah Dompet',
        child: const Icon(Icons.add),
      ),
    );
  }
}
