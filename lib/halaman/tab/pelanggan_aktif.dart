// path: lib/halaman/tab/pelanggan_aktif.dart
// File ini bertanggung jawab untuk menampilkan daftar pelanggan yang aktif.

// diubah: Impor layanan koneksi internet dan repositori yang baru.
import 'package:admin_wifi/data/repositori/pelanggan_aktif_repositori.dart';
import 'package:admin_wifi/services/cek_koneksi_internet.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_pelanggan_aktif.dart';
import 'package:admin_wifi/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/widget/nama_pelanggan.dart';

enum OpsiHapusPilihan { hapusSemua, hapusKadaluarsa, batal }

enum OpsiUrutkan {
  namaAZ,
  namaZA,
  lunas,
  belumLunas,
  paketAktif,
  paketTidakAktif,
}

class PelangganAktifPage extends StatefulWidget {
  const PelangganAktifPage({super.key});

  @override
  State<PelangganAktifPage> createState() => _PelangganAktifPageState();
}

class _PelangganAktifPageState extends State<PelangganAktifPage> {
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  // diubah: Menggunakan repositori untuk interaksi dengan Firebase.
  final PelangganAktifRepositori _pelangganAktifRepositori =
      PelangganAktifRepositori();
  late Future<List<PelangganAktif>> _listaPelangganAktifFuture = Future.value(
    [],
  );
  final NotifikasiServis _notifikasiServis = NotifikasiServis();

  @override
  void initState() {
    super.initState();
    _inisialisasiNotifikasi();
    _loadPelangganAktif();
  }

  Future<void> _inisialisasiNotifikasi() async {
    await _notifikasiServis.inisialisasi();
  }

  void _periksaDanJadwalkanNotifikasi(List<PelangganAktif> pelanggan) async {
    final sekarang = DateTime.now();

    for (var p in pelanggan) {
      if (p.id == null) continue;

      final pelangganOperasi = PelangganOperasi();
      final dataPelanggan = await pelangganOperasi.ambilSatuPelangganById(
        p.idPelanggan,
      );
      final namaPelanggan = dataPelanggan?.nama ?? 'Pelanggan';

      final tigaHariSebelumKadaluarsa = p.tanggalBerakhir.subtract(
        const Duration(days: 3),
      );

      if (tigaHariSebelumKadaluarsa.isAfter(sekarang)) {
        await _notifikasiServis.jadwalNotifikasi(
          id: p.id.hashCode.abs() + 1000,
          title: '⏰ Paket Akan Berakhir',
          body:
              'Paket $namaPelanggan akan berakhir dalam 3 hari (${Format.formatTanggal(p.tanggalBerakhir)})',
          jadwal: tigaHariSebelumKadaluarsa,
        );
      }

      final waktuKadaluarsa = p.tanggalBerakhir;

      if (waktuKadaluarsa.isAfter(sekarang)) {
        await _notifikasiServis.jadwalNotifikasi(
          id: p.id.hashCode.abs() + 2000,
          title: '🔔 Paket Berakhir Sekarang',
          body:
              'Paket $namaPelanggan telah berakhir hari ini (${Format.formatTanggal(waktuKadaluarsa)}). Harap perbarui paket.',
          jadwal: waktuKadaluarsa,
        );
      }
    }
  }

  Future<void> _loadPelangganAktif() async {
    setState(() {
      _listaPelangganAktifFuture = _pelangganAktifOperasi
          .ambilSemuaPelangganAktif()
          .then((list) {
            // diubah: Mengubah urutan default menjadi berdasarkan tanggal berakhir.
            list.sort((a, b) => a.tanggalBerakhir.compareTo(b.tanggalBerakhir));
            return list;
          });
    });

    _listaPelangganAktifFuture.then((pelanggan) {
      if (pelanggan.isNotEmpty) {
        _periksaDanJadwalkanNotifikasi(pelanggan);
      }
    });
  }

  Future<void> _hapusPelangganAktif(PelangganAktif pelanggan) async {
    if (pelanggan.id == null) return;

    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Wrap(
            children: [
              const Text('Apakah Anda yakin ingin menghapus '),
              NamaPelangganWidget(
                idPelanggan: pelanggan.idPelanggan,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('?'),
            ],
          ),
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
        // diubah: Memanggil repositori untuk menghapus dari Firebase.
        final isOnline = await KoneksiInternetService.cekKoneksi();
        if (isOnline) {
          await _pelangganAktifRepositori.hapusPelangganAktif(pelanggan.id!);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Mode offline: Data akan dihapus dari server saat online.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }

        await _pelangganAktifOperasi.hapusPelangganAktif(pelanggan.id!);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pelanggan aktif berhasil dihapus.'),
            backgroundColor: Colors.green,
          ),
        );
        _loadPelangganAktif();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus pelanggan: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _urutkanList(OpsiUrutkan pilihan) async {
    final list = await _listaPelangganAktifFuture;
    final pelangganOperasi = PelangganOperasi();

    final Map<String, String> namaMap = {};
    final semuaPelanggan = await pelangganOperasi.getPelanggan();
    for (var p in semuaPelanggan) {
      namaMap[p.id] = p.nama;
    }

    int Function(PelangganAktif, PelangganAktif) comparator;

    switch (pilihan) {
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
      case OpsiUrutkan.paketAktif:
      case OpsiUrutkan.paketTidakAktif:
        comparator = (a, b) {
          final isAktifA = a.tanggalBerakhir.isAfter(DateTime.now());
          final isAktifB = b.tanggalBerakhir.isAfter(DateTime.now());
          if (isAktifA == isAktifB) return 0;
          return (pilihan == OpsiUrutkan.paketAktif)
              ? (isAktifA ? -1 : 1)
              : (isAktifA ? 1 : -1);
        };
        break;
    }

    list.sort(comparator);

    setState(() {
      _listaPelangganAktifFuture = Future.value(list);
    });
  }

  void _showUrutkanDialog() async {
    final OpsiUrutkan? pilihan = await showDialog<OpsiUrutkan>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Urutkan Berdasarkan'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('Nama (A-Z)'),
              onPressed: () => Navigator.pop(context, OpsiUrutkan.namaAZ),
            ),
            SimpleDialogOption(
              child: const Text('Nama (Z-A)'),
              onPressed: () => Navigator.pop(context, OpsiUrutkan.namaZA),
            ),
            SimpleDialogOption(
              child: const Text('Status Pembayaran (Lunas)'),
              onPressed: () => Navigator.pop(context, OpsiUrutkan.lunas),
            ),
            SimpleDialogOption(
              child: const Text('Status Pembayaran (Belum Lunas)'),
              onPressed: () => Navigator.pop(context, OpsiUrutkan.belumLunas),
            ),
            SimpleDialogOption(
              child: const Text('Status Paket (Aktif)'),
              onPressed: () => Navigator.pop(context, OpsiUrutkan.paketAktif),
            ),
            SimpleDialogOption(
              child: const Text('Status Paket (Tidak Aktif)'),
              onPressed: () =>
                  Navigator.pop(context, OpsiUrutkan.paketTidakAktif),
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
      _urutkanList(pilihan);
    }
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
          final isOnline = await KoneksiInternetService.cekKoneksi();
          if (isOnline) {
            final semuaPelanggan = await _pelangganAktifOperasi
                .ambilSemuaPelangganAktif();
            for (var pelanggan in semuaPelanggan) {
              if (pelanggan.id != null) {
                // diubah: Memanggil repositori untuk menghapus dari Firebase.
                await _pelangganAktifRepositori.hapusPelangganAktif(
                  pelanggan.id!,
                );
              }
            }
          }
          await _pelangganAktifOperasi.hapusSemuaPelangganAktif();
          _loadPelangganAktif();
        }
        break;
      case OpsiHapusPilihan.hapusKadaluarsa:
        final isOnline = await KoneksiInternetService.cekKoneksi();
        if (isOnline) {
          final semuaPelanggan = await _pelangganAktifOperasi
              .ambilSemuaPelangganAktif();
          final sekarang = DateTime.now();
          final pelangganKadaluarsa = semuaPelanggan
              .where((p) => p.tanggalBerakhir.isBefore(sekarang))
              .toList();
          for (var pelanggan in pelangganKadaluarsa) {
            if (pelanggan.id != null) {
              // diubah: Memanggil repositori untuk menghapus dari Firebase.
              await _pelangganAktifRepositori.hapusPelangganAktif(
                pelanggan.id!,
              );
            }
          }
        }
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
                    vertical: 7,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onLongPress: () {
                      _hapusPelangganAktif(pelanggan);
                    },
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
