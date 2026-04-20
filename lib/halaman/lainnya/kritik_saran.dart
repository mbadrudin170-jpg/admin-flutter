// lib/halaman/lainnya/kritik_saran.dart
// Halaman ini menyediakan antarmuka bagi pengguna untuk mengirimkan kritik dan saran.

import 'package:admin/data/operasi/kritik_saran_operasi.dart';
import 'package:admin/model/kritik_saran_model.dart';
import 'package:flutter/material.dart';

class KritikSaranPage extends StatefulWidget {
  const KritikSaranPage({super.key});

  @override
  State<KritikSaranPage> createState() => _KritikSaranPageState();
}

class _KritikSaranPageState extends State<KritikSaranPage> {
  final _controller = TextEditingController();
  final KritikSaranOperasi _kritikSaranOperasi = KritikSaranOperasi();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi kritik atau saran Anda.')),
      );
      return;
    }

    try {
      final kritikSaran = KritikSaran(
        isi: _controller.text.trim(),
        tanggal: DateTime.now(),
      );
      await _kritikSaranOperasi.createKritikSaran(kritikSaran);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terima kasih atas masukan Anda!')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kritik & Saran'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Kami sangat menghargai masukan Anda untuk membantu kami menjadi lebih baik.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan kritik atau saran Anda di sini...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _kirim,
                child: const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
