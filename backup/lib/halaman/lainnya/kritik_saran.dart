// diubah: Mengimpor file utilitas terpusat.
import 'dart:developer' as developer;
import 'package:admin_wifi/halaman/detail/detail_kritik_saran.dart';
import 'package:admin_wifi/utils/format_util.dart';
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
  late Future<List<KritikSaranModel>> _kritikSaranFuture;

  @override
  void initState() {
    super.initState();
    _kritikSaranOperasi.debugCekTabel();
    _loadKritikSaran();
  }

  void _loadKritikSaran() {
    setState(() {
      _kritikSaranFuture = _kritikSaranOperasi
          .getKritikSaran()
          .then((data) {
            developer.log('📊 Jumlah data kritik saran: ${data.length}');
            for (var item in data) {
              developer.log(
                '📝 Data: ${item.isi} | User: ${item.userId} | Tanggal: ${item.tanggal}',
              );
            }
            return data;
          })
          .catchError((error) {
            developer.log('❌ Error ambil data: $error');
            throw error; // Tetap lempar error agar FutureBuilder menangkapnya
          });
    });
  }

  // Fungsi untuk menghapus kritik saran dari halaman daftar (via long press)
  Future<void> _hapusKritikSaran(KritikSaranModel item) async {
    if (item.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat menghapus: ID tidak ditemukan'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus kritik dan saran ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      try {
        await _kritikSaranOperasi.hapusKritikSaran(item.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kritik dan saran berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadKritikSaran();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kritik & Saran')),
      body: FutureBuilder<List<KritikSaranModel>>(
        future: _kritikSaranFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada kritik dan saran.'));
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async { // Jadikan onTap async
                      if (item.id != null) {
                        // Tangkap hasil dari Navigator.push
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailKritikSaranPage(id: item.id!),
                          ),
                        );

                        // Jika hasilnya 'true', muat ulang data
                        if (result == true) {
                          _loadKritikSaran();
                        }
                      }
                    },
                    onLongPress: () => _hapusKritikSaran(item),
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
                            item.isi,
                            style: const TextStyle(fontSize: 15, height: 1.4),
                          ),
                          const Divider(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              FormatTanggal.formatTanggalDanJam(item.tanggal),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
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
