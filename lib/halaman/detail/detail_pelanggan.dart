// lib/halaman/detail/detail_pelanggan.dart
import 'package:admin_wifi/halaman/form/form_pelanggan.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPelangganPage extends StatefulWidget {
  final Pelanggan pelanggan;
  const DetailPelangganPage({super.key, required this.pelanggan});

  @override
  DetailPelangganPageState createState() => DetailPelangganPageState();
}

class DetailPelangganPageState extends State<DetailPelangganPage> {
  bool _isPasswordVisible = false;

  Future<void> _launchWhatsApp(String phoneNumber) async {
    String formattedNumber = '62${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}';
    final Uri whatsappUri = Uri.parse('https://wa.me/$formattedNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka WhatsApp. Pastikan sudah terinstal.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
                InkWell(
                  onTap: () => _launchWhatsApp(widget.pelanggan.telepon),
                  child: Row(
                    children: [
                      Text(
                        'Telepon: ${widget.pelanggan.telepon}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green.shade700, size: 20),
                    ],
                  ),
                ),
                const Spacer(),
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
            Row(
              children: [
                Text(
                  'MAC Address: ${widget.pelanggan.macAddress}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
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
            const SizedBox(height: 20),
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
