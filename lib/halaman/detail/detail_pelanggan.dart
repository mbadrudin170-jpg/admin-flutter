// lib/halaman/detail/detail_pelanggan.dart
import 'package:admin_wifi/halaman/form/form_pelanggan.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:flutter/services.dart';

class DetailPelangganPage extends StatefulWidget {
  final Pelanggan pelanggan;
  const DetailPelangganPage({super.key, required this.pelanggan});

  @override
  DetailPelangganPageState createState() => DetailPelangganPageState();
}

class DetailPelangganPageState extends State<DetailPelangganPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pelanggan.nama),
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
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FormPelanggan(pelanggan: widget.pelanggan),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: ${widget.pelanggan.nama}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Telepon: ${widget.pelanggan.telepon}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(), // Ini akan mendorong ikon ke ujung kanan
                IconButton(
                  icon: const Icon(Icons.content_copy, size: 20.0),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.pelanggan.telepon),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nomor telepon berhasil disalin!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Salin nomor telepon',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Alamat: ${widget.pelanggan.alamat}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // lib/halaman/detail/detail_pelanggan.dart
            Row(
              children: [
                Text(
                  'MAC Address: ${widget.pelanggan.macAddress}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(), // Mendorong ikon ke ujung kanan
                IconButton(
                  icon: const Icon(Icons.content_copy, size: 20.0),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.pelanggan.macAddress),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('MAC Address berhasil disalin!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Salin MAC Address',
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Password: ${_isPasswordVisible ? widget.pelanggan.password : '********'}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Ditambah: Spasi sebelum tombol
            // Ditambah: Tombol untuk menyalin semua informasi pelanggan
            ElevatedButton(
              onPressed: () {
                final allInfo = '''
Nama: ${widget.pelanggan.nama}
Telepon: ${widget.pelanggan.telepon}
Alamat: ${widget.pelanggan.alamat}
MAC Address: ${widget.pelanggan.macAddress}
Password: ${widget.pelanggan.password}
''';
                Clipboard.setData(ClipboardData(text: allInfo));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Semua informasi pelanggan berhasil disalin!',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Salin Semua Info'),
            ),
          ],
        ),
      ),
    );
  }
}
