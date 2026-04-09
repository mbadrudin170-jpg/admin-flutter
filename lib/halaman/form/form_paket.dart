// lib/halaman/form/form_paket.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin/model/paket.dart';

class FormPaketPage extends StatefulWidget {
  const FormPaketPage({super.key});

  @override
  State<FormPaketPage> createState() => _FormPaketPageState();
}

class _FormPaketPageState extends State<FormPaketPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _durasiController = TextEditingController();
  TipeDurasi _selectedTipe = TipeDurasi.bulan;

  final _namaFocusNode = FocusNode();
  final _hargaFocusNode = FocusNode();
  final _durasiFocusNode = FocusNode();

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _durasiController.dispose();
    _namaFocusNode.dispose();
    _hargaFocusNode.dispose();
    _durasiFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data paket baru
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data paket berhasil disimpan!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Paket Baru'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nama Paket',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_hargaFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama paket tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                focusNode: _hargaFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_durasiFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durasiController,
                focusNode: _durasiFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Durasi',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  // Menutup keyboard karena ini adalah input teks terakhir
                  _durasiFocusNode.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Durasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TipeDurasi>(
                initialValue: _selectedTipe,
                decoration: const InputDecoration(
                  labelText: 'Tipe Durasi',
                  border: OutlineInputBorder(),
                ),
                items: TipeDurasi.values.map((tipe) {
                  return DropdownMenuItem(
                    value: tipe,
                    child: Text(tipe.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTipe = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simpanForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
