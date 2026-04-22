// path : lib/halaman/tab/pelanggan_aktif.dart
// File ini bertanggung jawab untuk menampilkan daftar pelanggan yang aktif.
// Fitur utama:
// - Menampilkan daftar pelanggan aktif dari database.
// - Menambahkan status paket "Aktif" (hijau) atau "Tidak Aktif" (merah) berdasarkan tanggal kedaluwarsa.
// - Menambahkan status pembayaran "Lunas" (hijau) atau "Belum Lunas" (merah).
// - Menyediakan opsi untuk menambah pelanggan aktif baru.
// - Menyediakan opsi untuk menghapus semua pelanggan atau hanya yang sudah kedaluwarsa.
// - Navigasi ke halaman detail saat item daftar diklik.
// - Menyediakan opsi pengurutan daftar pelanggan.

import 'package:admin_wifi/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_pelanggan_aktif.dart';
import 'package:admin_wifi/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/widget/nama_pelanggan.dart';

enum OpsiHapusPilihan { hapusSemua, hapusKadaluarsa, batal }

enum OpsiUrutkan {
  namaAZ,
  namaZA,
  lunas,
  belumLunas,
  paketAktif,
  paketTidakAktif,
  batal,
}

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

  void _opsiHapus() async {
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

    switch (pilihan) {
      case OpsiHapusPilihan.hapusSemua:
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
          _loadPelangganAktif();
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
        break;
    }
  }

  void _showUrutkanDialog() async {
    final OpsiUrutkan? pilihan = await showDialog<OpsiUrutkan>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Urutkan Berdasarkan'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.namaAZ);
              },
              child: const Text('Nama (A-Z)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.namaZA);
              },
              child: const Text('Nama (Z-A)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.lunas);
              },
              child: const Text('Status Pembayaran (Lunas)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.belumLunas);
              },
              child: const Text('Status Pembayaran (Belum Lunas)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.paketAktif);
              },
              child: const Text('Status Paket (Aktif)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.paketTidakAktif);
              },
              child: const Text('Status Paket (Tidak Aktif)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, OpsiUrutkan.batal);
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );

    if (!mounted || pilihan == null || pilihan == OpsiUrutkan.batal) return;

    setState(() {
      _listaPelangganAktifFuture = _listaPelangganAktifFuture.then((
        list,
      ) async {
        final PelangganOperasi pelangganOperasi = PelangganOperasi();
        switch (pilihan) {
          case OpsiUrutkan.namaAZ:
          case OpsiUrutkan.namaZA:
            final enrichedList = await Future.wait(
              list.map((p) async {
                // diubah: menggunakan nama metode yang benar 'ambilSatuPelangganById'
                final Pelanggan? pelanggan = await pelangganOperasi
                    .ambilSatuPelangganById(p.idPelanggan);
                final String nama = pelanggan?.nama ?? 'Tidak Diketahui';
                return {'pelanggan': p, 'nama': nama};
              }).toList(),
            );

            enrichedList.sort((a, b) {
              final namaA = a['nama'] as String;
              final namaB = b['nama'] as String;
              return pilihan == OpsiUrutkan.namaAZ
                  ? namaA.compareTo(namaB)
                  : namaB.compareTo(namaA);
            });
            return enrichedList
                .map((e) => e['pelanggan'] as PelangganAktif)
                .toList();

          case OpsiUrutkan.lunas:
          case OpsiUrutkan.belumLunas:
            list.sort((a, b) {
              final isLunasA = a.status == StatusPembayaran.lunas;
              final isLunasB = b.status == StatusPembayaran.lunas;
              if (isLunasA == isLunasB) return 0;
              if (pilihan == OpsiUrutkan.lunas) {
                return isLunasA ? -1 : 1;
              } else {
                return isLunasA ? 1 : -1;
              }
            });
            break;
          case OpsiUrutkan.paketAktif:
          case OpsiUrutkan.paketTidakAktif:
            list.sort((a, b) {
              final isAktifA = a.tanggalBerakhir.isAfter(DateTime.now());
              final isAktifB = b.tanggalBerakhir.isAfter(DateTime.now());
              if (isAktifA == isAktifB) return 0;
              if (pilihan == OpsiUrutkan.paketAktif) {
                return isAktifA ? -1 : 1;
              } else {
                return isAktifA ? 1 : -1;
              }
            });
            break;
          case OpsiUrutkan.batal:
            break;
        }
        return list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelanggan Aktif'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showUrutkanDialog,
            tooltip: 'Urutkan',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _opsiHapus,
            tooltip: 'Hapus',
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

                final sekarang = DateTime.now();
                final isAktif = pelanggan.tanggalBerakhir.isAfter(sekarang);
                final statusPaketText = isAktif ? 'Aktif' : 'Tidak Aktif';
                final statusPaketColor = isAktif ? Colors.green : Colors.red;

                final statusPembayaranText = pelanggan.status.displayName;
                final statusPembayaranColor =
                    pelanggan.status == StatusPembayaran.lunas
                    ? Colors.green
                    : Colors.red;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPelangganAktif(pelanggan: pelanggan),
                        ),
                      );
                      if (result == true) {
                        _loadPelangganAktif();
                      }
                    },
                    child: ListTile(
                      title: NamaPelangganWidget(
                        idPelanggan: pelanggan.idPelanggan,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pembayaran: $statusPembayaranText',
                            style: TextStyle(
                              color: statusPembayaranColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status Paket: $statusPaketText',
                            style: TextStyle(
                              color: statusPaketColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Berakhir: ${Format.formatTanggalDanJam(pelanggan.tanggalBerakhir)}',
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
