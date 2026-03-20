// lib/halaman/form/form_transaksi.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/kategori_data.dart';
import 'package:myapp/model/kategori.dart';
import 'package:myapp/model/transaksi_model.dart';

class FormTransaksiPage extends StatefulWidget {
  const FormTransaksiPage({super.key});

  @override
  State<FormTransaksiPage> createState() => _FormTransaksiPageState();
}

class _FormTransaksiPageState extends State<FormTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Kategori? _selectedKategori;
  SubKategori? _selectedSubKategori;
  TipeTransaksi _tipeTransaksi = TipeTransaksi.pemasukan;

  final _namaFocusNode = FocusNode();
  final _jumlahFocusNode = FocusNode();

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _namaFocusNode.dispose();
    _jumlahFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data transaksi baru
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Transaksi'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            DropdownButtonFormField<TipeTransaksi>(
              initialValue: _tipeTransaksi,
              decoration: const InputDecoration(labelText: 'Tipe Transaksi'),
              items: TipeTransaksi.values.map((TipeTransaksi tipe) {
                return DropdownMenuItem<TipeTransaksi>(
                  value: tipe,
                  child: Text(tipe.toString().split('.').last),
                );
              }).toList(),
              onChanged: (TipeTransaksi? newValue) {
                setState(() {
                  _tipeTransaksi = newValue!;
                  _selectedKategori = null;
                  _selectedSubKategori = null;
                });
              },
            ),
            TextFormField(
              controller: _namaController,
              focusNode: _namaFocusNode,
              decoration: const InputDecoration(labelText: 'Nama Transaksi'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_jumlahFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama transaksi tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _jumlahController,
              focusNode: _jumlahFocusNode,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                // Menutup keyboard karena ini adalah input teks terakhir
                _jumlahFocusNode.unfocus();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah tidak boleh kosong';
                }
                return null;
              },
            ),
            ListTile(
              title: Text(
                  'Tanggal: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Waktu: ${_selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
            DropdownButtonFormField<Kategori>(
              initialValue: _selectedKategori,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: kategoriData
                  .where((k) =>
                      (k.tipe == TipeKategori.pemasukan &&
                          _tipeTransaksi == TipeTransaksi.pemasukan) ||
                      (k.tipe == TipeKategori.pengeluaran &&
                          _tipeTransaksi == TipeTransaksi.pengeluaran))
                  .map((Kategori kategori) {
                return DropdownMenuItem<Kategori>(
                  value: kategori,
                  child: Text(kategori.nama),
                );
              }).toList(),
              onChanged: (Kategori? newValue) {
                setState(() {
                  _selectedKategori = newValue;
                  _selectedSubKategori = null;
                });
              },
            ),
            if (_selectedKategori != null &&
                _selectedKategori!.subKategori.isNotEmpty)
              DropdownButtonFormField<SubKategori>(
                initialValue: _selectedSubKategori,
                decoration: const InputDecoration(labelText: 'Sub Kategori'),
                items: _selectedKategori!.subKategori
                    .map((SubKategori subKategori) {
                  return DropdownMenuItem<SubKategori>(
                    value: subKategori,
                    child: Text(subKategori.nama),
                  );
                }).toList(),
                onChanged: (SubKategori? newValue) {
                  setState(() {
                    _selectedSubKategori = newValue;
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simpanForm,
              child: const Text('Simpan'),
            ),
          ]),
        ),
      ),
    );
  }
}
