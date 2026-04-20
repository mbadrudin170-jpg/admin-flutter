// lib/halaman/lainnya/kritik_saran.dart
// Halaman ini menyediakan antarmuka bagi pengguna untuk mengirimkan kritik dan saran.

import 'package:flutter/material.dart';

class KritikSaranPage extends StatefulWidget {
  const KritikSaranPage({super.key});

  @override
  State<KritikSaranPage> createState() => _KritikSaranPageState();
}

class _KritikSaranPageState extends State<KritikSaranPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi kritik atau saran Anda.')),
      );
      return;
    }

    // TODO: Implementasi logika pengiriman (misalnya, ke database atau API)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Terima kasih atas masukan Anda!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kritik & Saran'),
      ),
      body: Padding(
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
    );
  }
}
