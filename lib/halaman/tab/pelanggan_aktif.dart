// lib/halaman/tab/pelanggan_aktif.dart
import 'package:admin/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:admin/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin/halaman/detail/detail_pelanggan_aktif.dart';
import 'package:admin/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin/model/pelanggan_aktif_model.dart';
import 'package:admin/widget/nama_pelanggan.dart';

enum OpsiHapusPilihan { hapusSemua, hapusKadaluarsa, batal }

class PelangganAktifPage extends StatefulWidget {
  const PelangganAktifPage({super.key});

  @override
  State<PelangganAktifPage> createState() => _PelangganAktifPageState();
}

class _PelangganAktifPageState extends State<PelangganAktifPage> {
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  late Future<List<PelangganAktif>> _listaPelangganAktifFuture;

  @override
  void initState() {
    super.initState();
    _loadPelangganAktif();
  }

  void _loadPelangganAktif() {
    setState(() {
      _listaPelangganAktifFuture = _pelangganAktifOperasi
          .ambilSemuaPelangganAktif();
    });
  }

  void _tambahPelangganAktif() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPelangganAktif()),
    );
    if (!mounted) return;
    if (result == true) {
      _loadPelangganAktif();
    }
  }

  // Fungsi untuk menampilkan dialog dengan beberapa opsi hapus
  void _opsiHapus() async {
    // Menampilkan SimpleDialog untuk memilih opsi
    final OpsiHapusPilihan? pilihan = await showDialog<OpsiHapusPilihan>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Opsi Hapus'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiHapusPilihan.hapusKadaluarsa);
              },
              child: const Text('Hapus pelanggan kadaluarsa'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiHapusPilihan.hapusSemua);
              },
              child: Text(
                'Hapus Semua Pelanggan',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiHapusPilihan.batal);
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    // Menangani pilihan dari pengguna
    switch (pilihan) {
      case OpsiHapusPilihan.hapusSemua:
        // Meminta konfirmasi ulang sebelum menghapus semua
        final bool? konfirmasi = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Hapus Semua'),
              content: const Text(
                'Apakah Anda yakin ingin menghapus semua data pelanggan aktif? Tindakan ini tidak dapat dibatalkan.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        );

        if (konfirmasi == true) {
          await _pelangganAktifOperasi.hapusSemuaPelangganAktif();
          _loadPelangganAktif(); // Muat ulang daftar setelah menghapus
        }
        break;
      case OpsiHapusPilihan.hapusKadaluarsa:
        final int jumlahDihapus = await _pelangganAktifOperasi
            .hapusPelangganKadaluarsa();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$jumlahDihapus pelanggan kadaluarsa berhasil dihapus.',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        _loadPelangganAktif();
        break;
      case OpsiHapusPilihan.batal:
      default:
        // Pengguna memilih batal atau menutup dialog, tidak ada tindakan yang diambil.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PERINGATAN: Ini akan menyebabkan AppBar ganda lagi.
      appBar: AppBar(
        title: const Text('Pelanggan Aktif'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _opsiHapus,
            tooltip: 'Hapus Semua',
          ),
        ],
      ),
      body: FutureBuilder<List<PelangganAktif>>(
        future: _listaPelangganAktifFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada pelanggan aktif ditemukan.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pelanggan = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPelangganAktif(pelanggan: pelanggan),
                        ),
                      );
                    },
                    child: ListTile(
                      title: NamaPelangganWidget(
                        idPelanggan: pelanggan.idPelanggan,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pelanggan.status.displayName),
                          const SizedBox(height: 4),
                          Text(
                            'Berakhir: ${Format.formatTanggal(DateTime.parse(pelanggan.tanggalBerakhir))}',
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahPelangganAktif,
        child: const Icon(Icons.add),
      ),
    );
  }
}
