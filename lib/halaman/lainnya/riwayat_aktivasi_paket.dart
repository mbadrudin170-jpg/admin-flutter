// path: lib/halaman/lainnya/riwayat_aktivasi_paket.dart
// File ini bertanggung jawab untuk menampilkan daftar riwayat langganan.

import 'package:admin_wifi/data/operasi/riwayat_langganan_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_riwayat_langganan.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';
import 'package:admin_wifi/model/enum/status_pembayaran.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/widget/nama_paket.dart';
import 'package:admin_wifi/widget/nama_pelanggan.dart';
import 'package:admin_wifi/migrasi_diarsipkan.dart';

enum OpsiUrutkan {
  hariIni,
  terbaru,
  terlama,
  namaAZ,
  namaZA,
  lunas,
  belumLunas,
}

class RiwayatAktivasiPaketPage extends StatefulWidget {
  const RiwayatAktivasiPaketPage({super.key});

  @override
  State<RiwayatAktivasiPaketPage> createState() =>
      _RiwayatAktivasiPaketPageState();
}

class _RiwayatAktivasiPaketPageState extends State<RiwayatAktivasiPaketPage> {
  final RiwayatLanggananOperasi _riwayatOperasi = RiwayatLanggananOperasi();
  late Future<List<RiwayatLanggananModel>> _listRiwayatFuture = Future.value(
    [],
  );
  OpsiUrutkan _urutanAktif = OpsiUrutkan.terbaru;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    setState(() {
      _listRiwayatFuture = _riwayatOperasi.ambilSemuaRiwayat().then((list) {
        // Pengurutan default: terbaru
        list.sort((a, b) {
          final dateA = a.diarsipkan ?? a.diperbarui ?? DateTime(1970);
          final dateB = b.diarsipkan ?? b.diperbarui ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });
        return list;
      });
    });
  }

  Future<void> _hapusRiwayat(RiwayatLanggananModel riwayat) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Hapus',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true) {
      try {
        await _riwayatOperasi.hapusRiwayat(riwayat.id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Riwayat berhasil dihapus.'),
            backgroundColor: Colors.green,
          ),
        );
        _loadRiwayat();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus riwayat: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _hapusSemuaRiwayat() async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Semua Riwayat?'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus SEMUA riwayat? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Hapus Semua',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true) {
      try {
        await _riwayatOperasi.hapusSemuaRiwayat();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Semua riwayat berhasil dihapus.'),
            backgroundColor: Colors.green,
          ),
        );
        _loadRiwayat();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus semua riwayat: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _urutkanList(OpsiUrutkan pilihan) async {
    final list = await _listRiwayatFuture;
    final pelangganOperasi = PelangganOperasi();

    final Map<String, String> namaMap = {};
    final semuaPelanggan = await pelangganOperasi.getPelanggan();
    for (var p in semuaPelanggan) {
      namaMap[p.id] = p.nama;
    }

    int Function(RiwayatLanggananModel, RiwayatLanggananModel) comparator;

    switch (pilihan) {
      case OpsiUrutkan.hariIni:
        // DIPERBAIKI: Menggunakan logika fallback yang aman untuk tanggal
        list.sort((a, b) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final dateA = a.diarsipkan ?? a.diperbarui ?? DateTime(1970);
          final dateB = b.diarsipkan ?? b.diperbarui ?? DateTime(1970);

          final aIsToday =
              dateA.year == today.year &&
              dateA.month == today.month &&
              dateA.day == today.day;
          final bIsToday =
              dateB.year == today.year &&
              dateB.month == today.month &&
              dateB.day == today.day;

          if (aIsToday && !bIsToday) {
            return -1; // a hari ini, b tidak -> a duluan
          }
          if (!aIsToday && bIsToday) {
            return 1; // b hari ini, a tidak -> b duluan
          }

          // Jika keduanya hari ini atau keduanya bukan hari ini, urutkan berdasarkan waktu terbaru
          return dateB.compareTo(dateA);
        });
        // Setelah diurutkan, filter untuk hanya menampilkan yang hari ini
        final filteredList = list.where((item) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final itemDate = item.diarsipkan ?? item.diperbarui;
          return itemDate != null &&
              itemDate.year == today.year &&
              itemDate.month == today.month &&
              itemDate.day == today.day;
        }).toList();

        setState(() {
          _listRiwayatFuture = Future.value(filteredList);
          _urutanAktif = pilihan;
        });
        return; // Return agar tidak menjalankan sort di luar switch

      case OpsiUrutkan.terbaru:
        comparator = (a, b) {
          final dateA = a.diarsipkan ?? a.diperbarui ?? DateTime(1970);
          final dateB = b.diarsipkan ?? b.diperbarui ?? DateTime(1970);
          return dateB.compareTo(dateA);
        };
        break;
      case OpsiUrutkan.terlama:
        comparator = (a, b) {
          final dateA = a.diarsipkan ?? a.diperbarui ?? DateTime(1970);
          final dateB = b.diarsipkan ?? b.diperbarui ?? DateTime(1970);
          return dateA.compareTo(dateB);
        };
        break;
      case OpsiUrutkan.namaAZ:
      case OpsiUrutkan.namaZA:
        comparator = (a, b) {
          final namaA = namaMap[a.idPelanggan] ?? '';
          final namaB = namaMap[b.idPelanggan] ?? '';
          return pilihan == OpsiUrutkan.namaAZ
              ? namaA.compareTo(namaB)
              : namaB.compareTo(namaA);
        };
        break;
      case OpsiUrutkan.lunas:
      case OpsiUrutkan.belumLunas:
        comparator = (a, b) {
          final isLunasA = a.status == StatusPembayaran.lunas;
          final isLunasB = b.status == StatusPembayaran.lunas;
          if (isLunasA == isLunasB) return 0;
          return (pilihan == OpsiUrutkan.lunas)
              ? (isLunasA ? -1 : 1)
              : (isLunasA ? 1 : -1);
        };
        break;
    }

    list.sort(comparator);

    setState(() {
      _listRiwayatFuture = Future.value(list);
      _urutanAktif = pilihan;
    });
  }

  void _showUrutkanDialog() async {
    final OpsiUrutkan? pilihan = await showDialog<OpsiUrutkan>(
      context: context,
      builder: (BuildContext context) {
        Widget buildOption(String text, OpsiUrutkan value) {
          final bool isSelected = _urutanAktif == value;
          return Container(
            color: isSelected ? Theme.of(context).highlightColor : null,
            child: SimpleDialogOption(
              onPressed: () => Navigator.pop(context, value),
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }

        return SimpleDialog(
          title: const Text('Urutkan Berdasarkan'),
          children: <Widget>[
            buildOption('Hari Ini', OpsiUrutkan.hariIni),
            buildOption('Arsip Terbaru', OpsiUrutkan.terbaru),
            buildOption('Arsip Terlama', OpsiUrutkan.terlama),
            buildOption('Nama (A-Z)', OpsiUrutkan.namaAZ),
            buildOption('Nama (Z-A)', OpsiUrutkan.namaZA),
            buildOption('Status Pembayaran (Lunas)', OpsiUrutkan.lunas),
            buildOption(
              'Status Pembayaran (Belum Lunas)',
              OpsiUrutkan.belumLunas,
            ),
            SimpleDialogOption(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );

    if (pilihan != null) {
      // Jika memilih 'Hari Ini', muat ulang semua data lalu filter
      if (pilihan == OpsiUrutkan.hariIni) {
        await _loadRiwayat(); // Muat ulang semua data
      }
      _urutkanList(pilihan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Langganan'),
        actions: [
          const IconButton(
            onPressed: migrasiDiarsipkan,
            icon: Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showUrutkanDialog,
            tooltip: 'Urutkan',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _hapusSemuaRiwayat,
            tooltip: 'Hapus Semua Riwayat',
          ),
        ],
      ),
      body: FutureBuilder<List<RiwayatLanggananModel>>(
        future: _listRiwayatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                _urutanAktif == OpsiUrutkan.hariIni
                    ? 'Tidak ada riwayat untuk hari ini.'
                    : 'Tidak ada riwayat langganan ditemukan.',
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final riwayat = snapshot.data![index];

                final statusPembayaranText = riwayat.status.displayName;
                final statusPembayaranColor =
                    riwayat.status == StatusPembayaran.lunas
                    ? Colors.green
                    : Colors.red;

                final tanggalArsip = riwayat.diarsipkan ?? riwayat.diperbarui;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailRiwayatLanggananPage(riwayat: riwayat),
                        ),
                      );
                      // Jika ada sinyal perubahan, muat ulang data
                      if (result == true) {
                        _loadRiwayat();
                      }
                    },
                    onLongPress: () {
                      _hapusRiwayat(riwayat);
                    },
                    title: NamaPelangganWidget(
                      idPelanggan: riwayat.idPelanggan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NamaPaketWidget(idPaket: riwayat.idPaket),
                        const SizedBox(height: 4),
                        Text(
                          'Pembayaran: $statusPembayaranText',
                          style: TextStyle(
                            color: statusPembayaranColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Diarsipkan pada: ${tanggalArsip != null ? FormatTanggal.formatTanggalDanJam(tanggalArsip) : '-'}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Aktif: ${FormatTanggal.formatTanggalBasic(riwayat.tanggalMulai)} - ${FormatTanggal.formatTanggalBasic(riwayat.tanggalBerakhir)}',
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
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
