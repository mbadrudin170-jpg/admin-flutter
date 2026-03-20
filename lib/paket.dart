import 'package:flutter/material.dart';
import 'package:myapp/data/paket_data.dart';
import 'package:myapp/halaman/detail/detail_paket.dart';
import 'package:myapp/halaman/form/form_paket.dart'; // Impor halaman form

class PaketPage extends StatelessWidget {
  const PaketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Paket'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: paketData.length,
        itemBuilder: (context, index) {
          final paket = paketData[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPaketPage(paket: paket),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(
                  paket.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    'Rp ${paket.harga} / ${paket.durasi} ${paket.tipe.name}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Aksi saat tombol Beli ditekan
                  },
                  child: const Text('Beli'),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPaketPage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
