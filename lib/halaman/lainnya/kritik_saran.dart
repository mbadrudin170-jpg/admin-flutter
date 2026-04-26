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
  late Future<List<KritikSaran>> _kritikSaranFuture;

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

  // Fungsi untuk menghapus kritik saran
  Future<void> _hapusKritikSaran(KritikSaran item) async {
    // Periksa apakah ID tersedia
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

    // Tampilkan dialog konfirmasi
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
        // Tampilkan loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        // Panggil fungsi hapus dari operasi dengan null check
        await _kritikSaranOperasi.hapusKritikSaran(item.id!);

        // Tutup loading dialog
        if (mounted) Navigator.of(context).pop();

        // Tampilkan pesan sukses
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kritik dan saran berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Refresh data
        _loadKritikSaran();
      } catch (e) {
        // Tutup loading dialog jika masih ada
        if (mounted) Navigator.of(context).pop();

        // Tampilkan pesan error
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
      body: FutureBuilder<List<KritikSaran>>(
        future: _kritikSaranFuture,
        builder: (context, snapshot) {
          // DEBUG: Print state
          developer.log('🔄 Connection State: ${snapshot.connectionState}');
          developer.log('📦 Has Data: ${snapshot.hasData}');
          developer.log('❌ Has Error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            developer.log('💥 Error Details: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan error lebih detail
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Terjadi kesalahan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadKritikSaran,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada kritik dan saran yang masuk.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (item.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailKritikSaranPage(id: item.id!),
                          ),
                        );
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
