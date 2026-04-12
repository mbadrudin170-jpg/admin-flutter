// Path: lib/halaman/form/form_pelanggan_aktif.dart
import 'package:admin/data/operasi/paket_operasi.dart';
import 'package:admin/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin/data/operasi/pelanggan_operasi.dart';
import 'package:admin/model/paket_model.dart';
import 'package:admin/model/pelanggan_aktif_model.dart';
import 'package:admin/model/pelanggan_model.dart';
import 'package:admin/utils/format.dart';
import 'package:flutter/material.dart';

class FormPelangganAktif extends StatefulWidget {
  const FormPelangganAktif({super.key});

  @override
  State<FormPelangganAktif> createState() => _FormPelangganAktifState();
}

class _FormPelangganAktifState extends State<FormPelangganAktif> {
  final _formKey = GlobalKey<FormState>();
  // Operasi Database
  final PelangganOperasi _pelangganOperasi = PelangganOperasi();
  final PaketOperasi _paketOperasi = PaketOperasi();
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();

  // State untuk data
  List<Pelanggan> _pelangganList = [];
  List<Paket> _paketList = [];

  // State untuk item yang dipilih
  Pelanggan? _selectedPelanggan;
  Paket? _selectedPaket;

  // State untuk loading
  bool _isLoading = true;

  // State untuk tanggal dan waktu
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _loadAllData(); // Memuat semua data yang diperlukan
  }

  Future<void> _loadAllData() async {
    try {
      // Menjalankan kedua future secara paralel untuk efisiensi
      final results = await Future.wait([
        _pelangganOperasi.getPelanggan(),
        _paketOperasi.getPaket(),
      ]);
      setState(() {
        _pelangganList = results[0] as List<Pelanggan>;
        _paketList = results[1] as List<Paket>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Guard against context usage across async gaps.
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
        return DateTime(
          startDate.year,
          startDate.month + paket.durasi,
          startDate.day,
          startDate.hour,
          startDate.minute,
        );
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPelanggan != null &&
          _selectedPaket != null &&
          _selectedDate != null &&
          _selectedTime != null) {
        final DateTime tanggalMulai = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        // Hitung tanggal berakhir menggunakan fungsi terpusat
        final DateTime tanggalBerakhir = _hitungTanggalBerakhir(
          tanggalMulai,
          _selectedPaket!,
        );

        final newPelangganAktif = PelangganAktif(
          nama: _selectedPelanggan!.nama,
          paket: _selectedPaket!.nama,
          tanggalMulai: tanggalMulai.toIso8601String(),
          tanggalBerakhir: tanggalBerakhir.toIso8601String(),
          status: StatusPembayaran.lunas,
        );

        try {
          await _pelangganAktifOperasi.createPelangganAktif(newPelangganAktif);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pelanggan berhasil diaktifkan!')),
          );
          Navigator.pop(context, true); // Kirim hasil 'true' untuk refresh
        } // lib/halaman/form/form_pelanggan_aktif.dart
        catch (e, s) {
          // Menangkap stack trace (s) juga
          // Mencetak detail error ke debug console untuk dianalisis
          print('Terjadi kesalahan saat menyimpan: $e');
          print('Stack trace: $s');

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan. Cek debug console untuk detail.'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap lengkapi semua data.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Pelanggan Aktif')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown untuk memilih pelanggan
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

                    // Dropdown untuk memilih paket
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
                                : Format.formatTanggal(_selectedDate!),
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
                                  : '${Format.formatTanggal(_selectedDate!)}, ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
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

                                // Gunakan fungsi terpusat untuk kalkulasi
                                final DateTime endDate = _hitungTanggalBerakhir(
                                  startDate,
                                  _selectedPaket!,
                                );

                                final timePart =
                                    ', ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';

                                return '${Format.formatTanggal(endDate)}$timePart';
                              } else {
                                return 'Pilih paket & tanggal mulai';
                              }
                            }())),
                          ],
                        ),
                      ],
                    ),
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
