
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:admin_wifi/widget/nama_dari_id.dart';
import 'package:flutter/material.dart';

class DetailKritikSaranPage extends StatefulWidget {
  final String id;

  const DetailKritikSaranPage({super.key, required this.id});

  @override
  State<DetailKritikSaranPage> createState() => _DetailKritikSaranPageState();
}

class _DetailKritikSaranPageState extends State<DetailKritikSaranPage> {
  final KritikSaranOperasi _kritikSaranOperasi = KritikSaranOperasi();
  late Future<KritikSaran> _kritikSaranFuture;

  @override
  void initState() {
    super.initState();
    _kritikSaranFuture = _kritikSaranOperasi.getKritikSaranById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kritik & Saran'),
      ),
      body: FutureBuilder<KritikSaran>(
        future: _kritikSaranFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final kritikSaran = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_pin,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      NamaDariIdWidget(
                        userId: kritikSaran.userId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    kritikSaran.isi,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const Divider(height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      FormatTanggal.formatTanggalDanJam(kritikSaran.tanggal),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          }
        },
      ),
    );
  }
}
