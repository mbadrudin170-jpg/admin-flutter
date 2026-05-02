// lib/halaman/detail/detail_dompet.dart
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/halaman/form/form_dompet.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:intl/intl.dart';

// 1. Ubah menjadi StatefulWidget
class DetailDompet extends StatefulWidget {
  final Dompet dompet;

  const DetailDompet({super.key, required this.dompet});

  @override
  State<DetailDompet> createState() => _DetailDompetState();
}

class _DetailDompetState extends State<DetailDompet> {
  // 2. Buat state untuk menampung data dompet yang bisa berubah
  late Dompet _dompetSaatIni;
  final DompetOperasi _dompetOperasi = DompetOperasi();

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dengan data awal dari widget
    _dompetSaatIni = widget.dompet;
  }

  // 3. Buat fungsi untuk navigasi dan refresh data
  void _goToEditForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // Buka FormDompet dan kirim data dompet saat ini
        builder: (context) => FormDompet(dompet: _dompetSaatIni),
      ),
    );

    // Jika form ditutup dan mengembalikan 'true' (artinya ada perubahan)
    if (result == true) {
      // Ambil data dompet yang terbaru dari database
      final updatedDompet = await _dompetOperasi.getDompetById(
        _dompetSaatIni.id!,
      );
      if (updatedDompet != null) {
        // Perbarui state dengan data baru, yang akan memicu UI untuk rebuild
        setState(() {
          _dompetSaatIni = updatedDompet;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 4. Gunakan data dari state (_dompetSaatIni) untuk judul
        title: Text(_dompetSaatIni.namaDompet),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Saat kembali, kirimkan 'true' jika ada perubahan
            Navigator.pop(context, true);
          },
        ),
        actions: [
          // 5. Hubungkan fungsi _goToEditForm ke tombol edit
          IconButton(onPressed: _goToEditForm, icon: const Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Dompet:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // 6. Gunakan data dari state untuk menampilkan nama
            Text(
              _dompetSaatIni.namaDompet,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Saldo Saat Ini:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // 7. Gunakan data dari state dan format angka dengan benar
            Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(_dompetSaatIni.saldo),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _dompetSaatIni.saldo >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
