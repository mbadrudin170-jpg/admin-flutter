// Path: lib/halaman/form/form_pelanggan_aktif.dart
import 'package:admin/utils/format.dart';
import 'package:flutter/material.dart';

class FormPelangganAktif extends StatefulWidget {
  const FormPelangganAktif({super.key});

  @override
  State<FormPelangganAktif> createState() => _FormPelangganAktifState();
}

class _FormPelangganAktifState extends State<FormPelangganAktif> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // 3. Ambil tanggal dan waktu TERBARU saat widget pertama kali dibuat
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  // Fungsi untuk menampilkan dialog pemilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        // `setState` memberitahu Flutter untuk membangun ulang UI dengan data baru
        _selectedDate = picked;
      });
    }
  }

  // Fungsi untuk menampilkan dialog pemilih waktu
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Pelanggan Aktif')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                  onPressed: () =>
                      _selectTime(context), // DIUBAH: Memanggil fungsi
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    _selectedTime == null
                        ? 'Pilih Jam'
                        : _selectedTime!.format(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
