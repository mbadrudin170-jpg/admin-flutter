// lib/halaman/detail/detail_pelanggan.dart
import 'package:flutter/material.dart';
import 'package:admin/model/pelanggan_model.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${widget.pelanggan.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Nama: ${widget.pelanggan.nama}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Telepon: ${widget.pelanggan.telepon}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Alamat: ${widget.pelanggan.alamat}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('MAC Address: ${widget.pelanggan.macAddress}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Password: ${_isPasswordVisible ? widget.pelanggan.password : '********'}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
