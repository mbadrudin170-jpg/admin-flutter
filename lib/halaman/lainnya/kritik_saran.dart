// lib/halaman/lainnya/kritik_saran.dart
import 'package:admin_wifi/utils/format/format_tanggal.dart';
import 'package:admin_wifi/utils/format/format_jam.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';
import 'package:admin_wifi/model/kritik_saran_model.dart';
import 'package:admin_wifi/widget/nama_dari_id.dart';

class KritikSaranPage extends StatefulWidget {
  const KritikSaranPage({super.key});

  @override
  State<KritikSaranPage> createState() => _KritikSaranPageState();
}

class _KritikSaranPageState extends State<KritikSaranPage> {
  final KritikSaranOperasi _kritikSaranOperasi = KritikSaranOperasi();
  late Future<List<KritikSaran>> _kritikSaranFuture;

  @override
  void initState() {
    super.initState();
    _loadKritikSaran();
  }

  void _loadKritikSaran() {
    setState(() {
      _kritikSaranFuture = _kritikSaranOperasi.getKritikSaran();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kritik & Saran')),
      body: FutureBuilder<List<KritikSaran>>(
        future: _kritikSaranFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada kritik dan saran yang masuk.',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final listKritikSaran = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: listKritikSaran.length,
              itemBuilder: (context, index) {
                final item = listKritikSaran[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
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
                              userId: item.userId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.isi, // Diperbaiki dari item.pesan
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const Divider(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${formatTanggal(item.tanggal)} ${FormatJam.formatKeJamMenit(item.tanggal)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
