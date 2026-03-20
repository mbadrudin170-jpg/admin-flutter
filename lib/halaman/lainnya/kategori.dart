// lib/halaman/lainnya/kategori.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/operasi/kategori_operasi.dart';
import 'package:myapp/halaman/form/form_kategori.dart';
import 'package:myapp/model/kategori.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();
  late Future<List<Kategori>> _listaKategoriFuture;
  TipeKategori _selectedTipe = TipeKategori.pemasukan;

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  void _loadKategori() {
    setState(() {
      _listaKategoriFuture = _kategoriOperasi.getKategori();
    });
  }

  void _tambahKategori() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormKategoriPage()),
    );
    if (result == true) {
      _loadKategori();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTipe = TipeKategori.pemasukan;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTipe == TipeKategori.pemasukan
                      ? Colors.green
                      : Colors.grey,
                ),
                child: const Text('Pemasukan'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTipe = TipeKategori.pengeluaran;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTipe == TipeKategori.pengeluaran
                      ? Colors.red
                      : Colors.grey,
                ),
                child: const Text('Pengeluaran'),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Kategori>>(
              future: _listaKategoriFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada kategori ditemukan.'));
                } else {
                  final filteredKategori = snapshot.data!
                      .where((k) => k.tipe == _selectedTipe)
                      .toList();
                  return ListView.builder(
                    itemCount: filteredKategori.length,
                    itemBuilder: (context, index) {
                      final kategori = filteredKategori[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Text(kategori.nama),
                          children: kategori.subKategori.map((sub) {
                            return ListTile(
                              title: Text(sub.nama),
                            );
                          }).toList(),
                        ),
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
        onPressed: _tambahKategori,
        child: const Icon(Icons.add),
      ),
    );
  }
}
