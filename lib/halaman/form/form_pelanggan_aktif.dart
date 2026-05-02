// path: lib/halaman/form/form_pelanggan_aktif.dart
// Halaman ini menyediakan formulir untuk mengaktifkan pelanggan dengan paket tertentu.

import 'dart:developer' as developer;
import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/model/enum/sync_status.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:admin_wifi/model/pelanggan_aktif_model.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/model/enum/status_pembayaran.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class FormPelangganAktif extends StatefulWidget {
  final PelangganAktif? pelangganAktif;
  const FormPelangganAktif({super.key, this.pelangganAktif});

  @override
  State<FormPelangganAktif> createState() => _FormPelangganAktifState();
}

class _FormPelangganAktifState extends State<FormPelangganAktif> {
  final _formKey = GlobalKey<FormState>();
  // Operasi Database
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  final PaketOperasi _paketOperasi = PaketOperasi();
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();
  final DompetOperasi _dompetOperasi = DompetOperasi();
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();

  // State untuk data
  List<Pelanggan> _pelangganList = [];
  List<Paket> _paketList = [];
  List<Dompet> _dompetList = [];
  List<Kategori> _kategoriList = [];

  // State untuk item yang dipilih
  Pelanggan? _selectedPelanggan;
  Paket? _selectedPaket;
  Dompet? _selectedDompet;
  Kategori? _selectedKategori;

  // State untuk loading
  bool _isLoading = true;

  // State untuk tanggal dan waktu
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  StatusPembayaran _statusPembayaran = StatusPembayaran.lunas;

  bool get _isEditMode => widget.pelangganAktif != null;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final results = await Future.wait([
        _pelangganOperasi.getPelanggan(),
        _paketOperasi.getPaket(),
        _dompetOperasi.getDompet(),
        _kategoriOperasi.getKategori(),
      ]);
      setState(() {
        _pelangganList = results[0] as List<Pelanggan>;
        _pelangganList.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        _paketList = results[1] as List<Paket>;
        _dompetList = results[2] as List<Dompet>;
        _kategoriList = results[3] as List<Kategori>;

        if (_isEditMode) {
          final pa = widget.pelangganAktif!;
          try {
            _selectedPelanggan = _pelangganList.firstWhere(
              (p) => p.id == pa.idPelanggan,
            );
          } catch (e) {
            _selectedPelanggan = null;
          }
          try {
            _selectedPaket = _paketList.firstWhere((p) => p.id == pa.idPaket);
          } catch (e) {
            _selectedPaket = null;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Peringatan: Paket asli (ID: ${pa.idPaket}) tidak ditemukan. Harap pilih paket baru.',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }

          final tglMulai = pa.tanggalMulai;
          _selectedDate = tglMulai;
          _selectedTime = TimeOfDay.fromDateTime(tglMulai);
          _statusPembayaran = pa.status;
        } else {
          _selectedDate = DateTime.now();
          _selectedTime = TimeOfDay.now();
          // Atur default dompet dan kategori jika memungkinkan
          if (_dompetList.isNotEmpty) {
            _selectedDompet = _dompetList.first;
          }
          if (_kategoriList.isNotEmpty) {
            // Coba cari kategori 'Aktivasi Paket', jika tidak ada, gunakan yang pertama
            try {
              _selectedKategori = _kategoriList
                  .firstWhere((k) => k.nama.toLowerCase() == 'aktivasi paket');
            } catch (e) {
              _selectedKategori = _kategoriList.first;
            }
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  DateTime _hitungTanggalBerakhir(DateTime startDate, Paket paket) {
    switch (paket.tipe) {
      case TipeDurasi.jam:
        return startDate.add(Duration(hours: paket.durasi));
      case TipeDurasi.hari:
        return startDate.add(Duration(days: paket.durasi));
      case TipeDurasi.bulan:
        return Jiffy.parseFromDateTime(startDate)
            .add(months: paket.durasi)
            .dateTime;
      case TipeDurasi.menit:
        return startDate.add(Duration(minutes: paket.durasi));
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final selectedPaket = _selectedPaket;
      if (_selectedPelanggan != null &&
          selectedPaket != null &&
          _selectedDate != null &&
          _selectedTime != null &&
          _selectedDompet != null &&
          _selectedKategori != null) {
        final DateTime tanggalMulai = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        final DateTime tanggalBerakhir = _hitungTanggalBerakhir(
          tanggalMulai,
          selectedPaket,
        );

        final pelangganAktifData = PelangganAktif(
          id: _isEditMode ? widget.pelangganAktif!.id : null,
          idPelanggan: _selectedPelanggan!.id,
          idPaket: selectedPaket.id,
          tanggalMulai: tanggalMulai,
          tanggalBerakhir: tanggalBerakhir,
          status: _statusPembayaran,
          syncStatus: SyncStatus.write,
          diperbarui: DateTime.now(),
        );

        try {
          if (_isEditMode) {
            await _pelangganAktifOperasi.updatePelangganAktif(
              pelangganAktifData,
            );
          } else {
            await _pelangganAktifOperasi.createPelangganAktif(
              pelangganAktifData,
            );
          }

          if (_statusPembayaran == StatusPembayaran.lunas) {
            final transaksi = TransaksiModel(
              tanggal: tanggalMulai,
              keterangan:
                  'Aktivasi paket: ${selectedPaket.nama} - ${_selectedPelanggan!.nama}',
              jumlah: selectedPaket.harga.toDouble(),
              tipe: TipeTransaksi.pemasukan,
              idDompet: _selectedDompet!.id!,
              namaDompet: _selectedDompet!.namaDompet,
              idKategori: _selectedKategori!.id ?? '',
              namaKategori: _selectedKategori!.nama,
              idPelanggan: _selectedPelanggan!.id,
              namaPelanggan: _selectedPelanggan!.nama,
              idPaket: selectedPaket.id,
              namaPaket: selectedPaket.nama,
              diperbarui: DateTime.now(),
            );
            await _transaksiOperasi.tambahTransaksi(transaksi);
          }

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pelanggan berhasil ${_isEditMode ? 'diperbarui' : 'diaktifkan'}!',
              ),
            ),
          );
          Navigator.pop(context, true);
        } catch (e, s) {
          developer.log(
            'Terjadi kesalahan saat menyimpan',
            name: 'admin_wifi.form.pelanggan_aktif',
            error: e,
            stackTrace: s,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan: $e. Cek log untuk detail.'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Harap lengkapi semua data, termasuk Pelanggan, Paket, Dompet, dan Kategori.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Pelanggan Aktif' : 'Form Pelanggan Aktif',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView( // Menggunakan ListView untuk mencegah overflow
                  children: [
                    DropdownButtonFormField<Pelanggan>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedPelanggan,
                      items: _pelangganList.map((Pelanggan pelanggan) {
                        return DropdownMenuItem<Pelanggan>(
                          value: pelanggan,
                          child: Text(pelanggan.nama),
                        );
                      }).toList(),
                      onChanged: (Pelanggan? newValue) {
                        setState(() {
                          _selectedPelanggan = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pelanggan tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Paket>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Paket',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedPaket,
                      items: _paketList.map((Paket paket) {
                        return DropdownMenuItem<Paket>(
                          value: paket,
                          child: Text(paket.nama),
                        );
                      }).toList(),
                      onChanged: (Paket? newValue) {
                        setState(() {
                          _selectedPaket = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Paket tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    // Dropdown untuk Dompet
                    DropdownButtonFormField<Dompet>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Dompet',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedDompet,
                      items: _dompetList.map((Dompet dompet) {
                        return DropdownMenuItem<Dompet>(
                          value: dompet,
                          child: Text(dompet.namaDompet),
                        );
                      }).toList(),
                      onChanged: (Dompet? newValue) {
                        setState(() {
                          _selectedDompet = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Dompet tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    // Dropdown untuk Kategori
                    DropdownButtonFormField<Kategori>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Kategori Transaksi',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedKategori,
                      items: _kategoriList.map((Kategori kategori) {
                        return DropdownMenuItem<Kategori>(
                          value: kategori,
                          child: Text(kategori.nama),
                        );
                      }).toList(),
                      onChanged: (Kategori? newValue) {
                        setState(() {
                          _selectedKategori = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Kategori tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pilih Tanggal & Waktu Aktif:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            _selectedDate == null
                                ? 'Pilih Tanggal'
                                : FormatTanggal.formatTanggalBasic(
                                    _selectedDate!,
                                  ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            _selectedTime == null
                                ? 'Pilih Jam'
                                : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _statusPembayaran == StatusPembayaran.lunas
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[200],
                              foregroundColor:
                                  _statusPembayaran == StatusPembayaran.lunas
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _statusPembayaran = StatusPembayaran.lunas;
                              });
                            },
                            child: const Text('Lunas'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _statusPembayaran ==
                                          StatusPembayaran.belumLunas
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[200],
                              foregroundColor:
                                  _statusPembayaran ==
                                          StatusPembayaran.belumLunas
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _statusPembayaran = StatusPembayaran.belumLunas;
                              });
                            },
                            child: const Text('Belum Lunas'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tanggal Mulai:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              (_selectedDate == null || _selectedTime == null)
                                  ? 'Pilih Tanggal & Jam'
                                  : FormatTanggal.formatTanggalDanJam(
                                      DateTime(
                                        _selectedDate!.year,
                                        _selectedDate!.month,
                                        _selectedDate!.day,
                                        _selectedTime!.hour,
                                        _selectedTime!.minute,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tanggal Berakhir:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text((() {
                              if (_selectedDate != null &&
                                  _selectedPaket != null) {
                                DateTime startDate = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _selectedTime?.hour ?? 0,
                                  _selectedTime?.minute ?? 0,
                                );
                                final DateTime endDate = _hitungTanggalBerakhir(
                                  startDate,
                                  _selectedPaket!,
                                );
                                return FormatTanggal.formatTanggalDanJam(
                                  endDate,
                                );
                              } else {
                                return 'Pilih paket & tanggal mulai';
                              }
                            }())),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24), // Spacer
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
