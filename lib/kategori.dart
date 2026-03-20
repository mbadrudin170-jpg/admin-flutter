import 'package:flutter/material.dart';
import 'package:myapp/data/kategori_data.dart';
import 'package:myapp/halaman/form/form_kategori.dart';
import 'package:myapp/model/kategori.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  TipeKategori _selectedTipe = TipeKategori.pemasukan;

  @override
  Widget build(BuildContext context) {
    final filteredKategori = kategoriData.where((k) => k.tipe == _selectedTipe).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
      ),
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
            child: ListView.builder(
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormKategoriPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
