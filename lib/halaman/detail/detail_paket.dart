// path: lib/halaman/detail/detail_paket.dart
// File ini bertanggung jawab untuk menampilkan detail dari sebuah paket layanan.

import 'package:flutter/material.dart';
import 'package:admin_wifi/model/paket_model.dart';
// ditambah: Impor halaman form untuk navigasi edit.
import 'package:admin_wifi/halaman/form/form_paket.dart';

class DetailPaketPage extends StatefulWidget {
  final Paket paket;

  const DetailPaketPage({super.key, required this.paket});

  @override
  State<DetailPaketPage> createState() => _DetailPaketPageState();
}

// diubah: Dijadikan StatefulWidget untuk me-refresh data setelah edit.
class _DetailPaketPageState extends State<DetailPaketPage> {
  // diubah: Objek paket sekarang dapat diperbarui.
  late Paket _paket;

  @override
  void initState() {
    super.initState();
    // diubah: Inisialisasi paket dari widget.
    _paket = widget.paket;
  }

  // ditambah: Fungsi untuk menavigasi ke halaman edit dan me-refresh data jika ada perubahan.
  void _editPaket() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormPaket(paket: _paket), // Mengirim paket yang ada
      ),
    );

    if (result == true) {
      // Jika ada perubahan, muat ulang data paket dari database (atau cukup perbarui dari hasil)
      // Untuk simpelnya, kita bisa mengasumsikan paket yang diperbarui dikirim kembali
      // atau kita bisa memuat ulang dari DB. Di sini kita hanya pop.
      if (mounted) {
        Navigator.pop(
          context,
          true,
        ); // Kembali ke halaman list dan memicu refresh
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_paket.nama),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _editPaket,
            icon: Icon(Icons.edit),
            tooltip: 'Edit Paket',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Detail Paket',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // diubah: Menggunakan _paket yang ada di state.
                _buildDetailRow('Nama Paket', _paket.nama),
                _buildDetailRow('Harga', 'Rp ${_paket.harga}'),
                _buildDetailRow(
                  'Durasi',
                  '${_paket.durasi} ${_paket.tipe.name}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
