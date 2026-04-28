// path: lib/halaman/tab/pelanggan_aktif.dart
// File ini bertanggung jawab untuk menampilkan daftar pelanggan yang aktif.

import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/riwayat_langganan_operasi.dart';
import 'package:admin_wifi/data/repositori/pelanggan_aktif_repositori.dart';
import 'package:admin_wifi/data/services/notifikasi_servis.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';
import 'package:admin_wifi/model/enum/status_pembayaran.dart';
import 'package:admin_wifi/services/cek_koneksi_internet.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:admin_wifi/utils/perhitungan_util.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_pelanggan_aktif.dart';
import 'package:admin_wifi/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/widget/nama_paket.dart';
import 'package:admin_wifi/widget/nama_pelanggan.dart';

enum OpsiHapusPilihan { hapusSemua, hapusKadaluarsa, batal }

enum OpsiUrutkan {
  tanggalBerakhir,
  tanggalMulai,
  diPerbarui,
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
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  final PelangganAktifRepositori _pelangganAktifRepositori =
      PelangganAktifRepositori();
  final NotifikasiServis _notifikasiServis = NotifikasiServis();
  final RiwayatLanggananOperasi _riwayatLanggananOperasi =
      RiwayatLanggananOperasi();

  // State untuk data
  List<PelangganAktif> _semuaPelanggan = [];
  List<PelangganAktif> _hasilFilter = [];
  Map<String, String> _mapNamaPelanggan = {};
  bool _isLoading = true;

  // State untuk UI
  OpsiUrutkan _urutanAktif = OpsiUrutkan.tanggalBerakhir;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilterAndSort();
  }

  Future<void> _unggahKeFirebase() async {
    final isOnline = await KoneksiInternetService.cekKoneksi();
    if (!mounted) return;
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada koneksi internet untuk mengunggah data.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memulai proses unggah ke Firebase...'),
        backgroundColor: Colors.blue,
      ),
    );

    try {
      final semuaPelangganLokal = await _pelangganAktifOperasi
          .ambilSemuaPelangganAktif();

      if (!mounted) return;
      if (semuaPelangganLokal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data lokal untuk diunggah.')),
        );
        return;
      }
      for (final pelanggan in semuaPelangganLokal) {
        await _pelangganAktifRepositori.simpanPelangganAktif(pelanggan);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data berhasil diunggah ke Firebase.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunggah data: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final pelangganList = await _pelangganOperasi.getPelanggan();
      _mapNamaPelanggan = {for (var p in pelangganList) p.id: p.nama};

      final pelangganAktifList = await _pelangganAktifOperasi
          .ambilSemuaPelangganAktif();
      _semuaPelanggan = pelangganAktifList;

      _applyFilterAndSort();

      if (pelangganAktifList.isNotEmpty) {
        _periksaDanJadwalkanNotifikasi(pelangganAktifList);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilterAndSort() {
    List<PelangganAktif> tempResult;

    // 1. Filter berdasarkan pencarian
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      tempResult = _semuaPelanggan.where((pelanggan) {
        final nama =
            _mapNamaPelanggan[pelanggan.idPelanggan]?.toLowerCase() ?? '';
        return nama.contains(query);
      }).toList();
    } else {
      tempResult = List.of(_semuaPelanggan);
    }

    // 2. Urutkan hasil filter
    int Function(PelangganAktif, PelangganAktif) comparator;

    switch (_urutanAktif) {
      case OpsiUrutkan.tanggalBerakhir:
        comparator = (a, b) => a.tanggalBerakhir.compareTo(b.tanggalBerakhir);
        break;
      case OpsiUrutkan.tanggalMulai:
        comparator = (a, b) => a.tanggalMulai.compareTo(b.tanggalMulai);
        break;
      case OpsiUrutkan.diPerbarui:
        comparator = (a, b) {
          final dateA = a.diperbarui ?? a.tanggalMulai;
          final dateB = b.diperbarui ?? b.tanggalMulai;
          return dateB.compareTo(dateA); // Terbaru di atas
        };
        break;
      case OpsiUrutkan.namaAZ:
      case OpsiUrutkan.namaZA:
        comparator = (a, b) {
          final namaA = _mapNamaPelanggan[a.idPelanggan] ?? '';
          final namaB = _mapNamaPelanggan[b.idPelanggan] ?? '';
          return _urutanAktif == OpsiUrutkan.namaAZ
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
          return (_urutanAktif == OpsiUrutkan.lunas)
              ? (isLunasA ? -1 : 1)
              : (isLunasA ? 1 : -1);
        };
        break;
      case OpsiUrutkan.paketAktif:
      case OpsiUrutkan.paketTidakAktif:
        comparator = (a, b) {
          final isAktifA = PerhitunganUtil.sisaHari(a.tanggalBerakhir) >= 0;
          final isAktifB = PerhitunganUtil.sisaHari(b.tanggalBerakhir) >= 0;
          if (isAktifA == isAktifB) return 0;
          return (_urutanAktif == OpsiUrutkan.paketAktif)
              ? (isAktifA ? -1 : 1)
              : (isAktifA ? 1 : -1);
        };
        break;
    }

    tempResult.sort(comparator);

    // 3. Perbarui state UI
    if (mounted) {
      setState(() {
        _hasilFilter = tempResult;
      });
    }
  }

  void _periksaDanJadwalkanNotifikasi(List<PelangganAktif> pelanggan) async {
    final sekarang = DateTime.now();

    for (var p in pelanggan) {
      if (p.id == null) continue;

      final namaPelanggan = _mapNamaPelanggan[p.idPelanggan] ?? 'Pelanggan';
      final tigaHariSebelumKadaluarsa = p.tanggalBerakhir.subtract(
        const Duration(days: 3),
      );

      if (tigaHariSebelumKadaluarsa.isAfter(sekarang)) {
        await _notifikasiServis.jadwalNotifikasi(
          id: (p.id.hashCode.abs() + 1),
          title: '⏰ Paket Akan Berakhir',
          body:
              'Paket $namaPelanggan akan berakhir dalam 3 hari (${FormatTanggal.formatTanggalBasic(p.tanggalBerakhir)})',
          jadwal: tigaHariSebelumKadaluarsa,
        );
      }

      final waktuKadaluarsa = p.tanggalBerakhir;

      if (waktuKadaluarsa.isAfter(sekarang)) {
        await _notifikasiServis.jadwalNotifikasi(
          id: (p.id.hashCode.abs() + 2),
          title: '🔔 Paket Berakhir Sekarang',
          body:
              'Paket $namaPelanggan telah berakhir hari ini (${FormatTanggal.formatTanggalBasic(waktuKadaluarsa)}). Harap perbarui paket.',
          jadwal: waktuKadaluarsa,
        );
      }
    }
  }

  Future<void> _hapusPelangganAktif(PelangganAktif pelangganAktif) async {
    if (pelangganAktif.id == null) return;

    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Wrap(
            children: [
              const Text('Apakah Anda yakin ingin menghapus '),
              NamaPelangganWidget(
                idPelanggan: pelangganAktif.idPelanggan,
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
        final paketOperasi = PaketOperasi();
        final paket = await paketOperasi.getPaketById(pelangganAktif.idPaket);
        if (paket == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Data paket tidak ditemukan. Tidak dapat mengarsipkan.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        // 1. Buat entri riwayat dari pelanggan yang akan dihapus
        final riwayat = RiwayatLanggananModel(
          id: pelangganAktif.id!,
          idPelanggan: pelangganAktif.idPelanggan,
          idPaket: pelangganAktif.idPaket,
          namaPaket: paket.nama,
          hargaPaket: paket.harga,
          durasiPaket: paket.durasi,
          tipeDurasiPaket: paket.tipe.name,
          tanggalMulai: pelangganAktif.tanggalMulai,
          tanggalBerakhir: pelangganAktif.tanggalBerakhir,
          status: pelangganAktif.status,
          diperbarui: DateTime.now(),
        );

        // 2. Simpan ke tabel riwayat
        await _riwayatLanggananOperasi.tambahRiwayatLangganan(riwayat);

        // 3. Hapus notifikasi terjadwal
        await _notifikasiServis.batalNotifikasi(
          (pelangganAktif.id.hashCode.abs() + 1),
        );
        await _notifikasiServis.batalNotifikasi(
          (pelangganAktif.id.hashCode.abs() + 2),
        );

        // 4. Hapus dari Firebase jika online
        final isOnline = await KoneksiInternetService.cekKoneksi();
        if (isOnline) {
          await _pelangganAktifRepositori.hapusPelangganAktif(
            pelangganAktif.id!,
          );
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

        // 5. Hapus dari database lokal
        await _pelangganAktifOperasi.hapusPelangganAktif(pelangganAktif.id!);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pelanggan berhasil diarsipkan ke riwayat.'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(forceRefresh: true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengarsipkan pelanggan: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
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
            buildOption('Tanggal Berakhir', OpsiUrutkan.tanggalBerakhir),
            buildOption('Tanggal Mulai', OpsiUrutkan.tanggalMulai),
            buildOption('Terakhir Diperbarui', OpsiUrutkan.diPerbarui),
            buildOption('Nama (A-Z)', OpsiUrutkan.namaAZ),
            buildOption('Nama (Z-A)', OpsiUrutkan.namaZA),
            buildOption('Status Pembayaran (Lunas)', OpsiUrutkan.lunas),
            buildOption(
              'Status Pembayaran (Belum Lunas)',
              OpsiUrutkan.belumLunas,
            ),
            buildOption('Status Paket (Aktif)', OpsiUrutkan.paketAktif),
            buildOption(
              'Status Paket (Tidak Aktif)',
              OpsiUrutkan.paketTidakAktif,
            ),
            SimpleDialogOption(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );

    if (pilihan != null && pilihan != _urutanAktif) {
      if (mounted) {
        setState(() {
          _urutanAktif = pilihan;
        });
      }
      _applyFilterAndSort();
    }
  }

  void _tambahPelangganAktif() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPelangganAktif()),
    );
    if (!mounted) return;
    if (result == true) {
      _loadData(forceRefresh: true);
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
                await _pelangganAktifRepositori.hapusPelangganAktif(
                  pelanggan.id!,
                );
              }
            }
          }
          await _pelangganAktifOperasi.hapusSemuaPelangganAktif();
          _loadData(forceRefresh: true);
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
        _loadData(forceRefresh: true);
        break;
      case OpsiHapusPilihan.batal:
      default:
        break;
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _isSearching ? _buildSearchField() : const Text('Pelanggan Aktif'),
      actions: _isSearching ? _buildSearchActions() : _buildDefaultActions(),
    );
  }

  Widget _buildSearchField() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: 'Cari nama pelanggan...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
        ),
      ),
    );
  }

  List<Widget> _buildSearchActions() {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          if (mounted) {
            setState(() {
              _isSearching = false;
            });
          }
          _searchController.clear();
        },
        tooltip: 'Tutup Pencarian',
      ),
    ];
  }

  List<Widget> _buildDefaultActions() {
    return [
      IconButton(
        icon: const Icon(Icons.cloud_upload),
        onPressed: _unggahKeFirebase,
        tooltip: 'Unggah ke Firebase',
      ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          if (mounted) {
            setState(() {
              _isSearching = true;
            });
          }
        },
        tooltip: 'Cari',
      ),
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _semuaPelanggan.isEmpty
          ? const Center(child: Text('Tidak ada pelanggan aktif ditemukan.'))
          : _hasilFilter.isEmpty && _searchController.text.isNotEmpty
          ? const Center(child: Text('Pelanggan tidak ditemukan.'))
          : RefreshIndicator(
              onRefresh: () => _unggahKeFirebase(),
              child: ListView.builder(
                itemCount: _hasilFilter.length,
                itemBuilder: (context, index) {
                  final pelanggan = _hasilFilter[index];
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
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPelangganAktif(pelanggan: pelanggan),
                          ),
                        );
                        _loadData(forceRefresh: true);
                      },
                      child: ListTile(
                        title: NamaPelangganWidget(
                          idPelanggan: pelanggan.idPelanggan,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NamaPaketWidget(idPaket: pelanggan.idPaket),
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
                              'Status: ${PerhitunganUtil.getTeksSisaMasaAktif(pelanggan.tanggalBerakhir)}',
                              style: TextStyle(
                                color: PerhitunganUtil.getWarnaSisaMasaAktif(
                                  pelanggan.tanggalBerakhir,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Berakhir: ${FormatTanggal.formatTanggalBasic(pelanggan.tanggalBerakhir)} ${FormatJam.formatJamMenit(pelanggan.tanggalBerakhir)}',
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahPelangganAktif,
        child: const Icon(Icons.add),
      ),
    );
  }
}
