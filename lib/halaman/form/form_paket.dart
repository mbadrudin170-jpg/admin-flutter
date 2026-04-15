// lib/halaman/form/form_paket.dart
import 'package:admin/data/operasi/paket_operasi.dart';
import 'package:admin/model/paket_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;

class FormPaket extends StatefulWidget {
  final Paket? paket;
  const FormPaket({super.key, this.paket});

  @override
  State<FormPaket> createState() => _FormPaketState();
}

class _FormPaketState extends State<FormPaket> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _durasiController = TextEditingController();
  final PaketOperasi _paketOperasi = PaketOperasi();

  TipeDurasi _selectedTipe = TipeDurasi.hari;

  bool get _isEditMode => widget.paket != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _namaController.text = widget.paket!.nama;
      _hargaController.text = widget.paket!.harga.toString();
      _durasiController.text = widget.paket!.durasi.toString();
      _selectedTipe = widget.paket!.tipe;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final newPaket = Paket(
        id: _isEditMode ? widget.paket!.id : null,
        nama: _namaController.text,
        harga: int.parse(_hargaController.text),
        durasi: int.parse(_durasiController.text),
        tipe: _selectedTipe,
      );
      try {
        if (_isEditMode) {
          await _paketOperasi.updatePaket(newPaket);
        } else {
          await _paketOperasi.createPaket(newPaket);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Data paket berhasil ${_isEditMode ? 'diperbarui' : 'disimpan'}!',
            ),
          ),
        );
        Navigator.pop(context, true);
      } on DatabaseException catch (e, s) {
        // Tangkap error database secara spesifik
        if (!mounted) return;
        String errorMessage =
            'Gagal menyimpan paket. Terjadi kesalahan database.';
        // Periksa jika ini adalah error karena nama sudah ada (unique constraint)
        if (e.isUniqueConstraintError()) {
          errorMessage = 'Nama paket sudah ada. Harap gunakan nama lain.';
        }
        developer.log(
          'Gagal menyimpan paket: $errorMessage',
          name: 'form_paket.save',
          error: e,
          stackTrace: s,
          level: 1000,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e, s) {
        // Tangkap error lainnya
        if (!mounted) return;
        developer.log(
          'Gagal menyimpan paket: Terjadi kesalahan tidak diketahui.',
          name: 'form_paket.save',
          error: e,
          stackTrace: s,
          level: 1000,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Paket' : 'Tambah Paket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Paket'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama paket tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durasiController,
                decoration: const InputDecoration(labelText: 'Durasi'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Durasi tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Durasi harus berupa angka';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<TipeDurasi>(
                initialValue: _selectedTipe,
                decoration: const InputDecoration(labelText: 'Tipe Durasi'),
                items: TipeDurasi.values.map((TipeDurasi tipe) {
                  return DropdownMenuItem<TipeDurasi>(
                    value: tipe,
                    child: Text(
                      tipe.displayName,
                    ), // Menggunakan displayName dari extension
                  );
                }).toList(),
                onChanged: (TipeDurasi? newValue) {
                  setState(() {
                    _selectedTipe = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveForm, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _durasiController.dispose();
    super.dispose();
  }
}
