import 'package:admin/data/operasi/paket_operasi.dart';
import 'package:admin/model/paket_model.dart';
import 'package:flutter/material.dart';
import 'package:admin/halaman/detail/detail_paket.dart';
import 'package:admin/halaman/form/form_paket.dart'; // Impor halaman form

class PaketPage extends StatefulWidget {
  const PaketPage({super.key});

  @override
  State<PaketPage> createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  final PaketOperasi _paketOperasi = PaketOperasi();
  late Future<List<Paket>> _paketFuture;

  @override
  void initState() {
    super.initState();
    _paketFuture = _paketOperasi.getPaket();
  }

  void _refreshPaketList() {
    setState(() {
      _paketFuture = _paketOperasi.getPaket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Paket'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Paket>>(
        future: _paketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada paket yang tersedia.'));
          }
          final paketList = snapshot.data!;
          return ListView.builder(
            itemCount: paketList.length,
            itemBuilder: (context, index) {
              final paket = paketList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPaketPage(paket: paket),
                    ),
                  ).then((_) => _refreshPaketList());
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      paket.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp ${paket.harga} / ${paket.durasi} ${paket.tipe.name}',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPaketPage()),
          ).then((_) => _refreshPaketList());
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
