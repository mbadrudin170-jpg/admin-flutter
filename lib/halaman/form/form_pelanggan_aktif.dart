// lib/halaman/form/form_pelanggan_aktif.dart
import 'package:flutter/material.dart';

class FormPelangganAktif extends StatefulWidget {
  const FormPelangganAktif({super.key});

  @override
  State<FormPelangganAktif> createState() => _FormPelangganAktifState();
}

class _FormPelangganAktifState extends State<FormPelangganAktif> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _statusController = TextEditingController();
  final _avatarController = TextEditingController();

  final _namaFocusNode = FocusNode();
  final _statusFocusNode = FocusNode();
  final _avatarFocusNode = FocusNode();

  @override
  void dispose() {
    _namaController.dispose();
    _statusController.dispose();
    _avatarController.dispose();
    _namaFocusNode.dispose();
    _statusFocusNode.dispose();
    _avatarFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data akan ditambahkan di sini
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pelanggan Aktif')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_statusFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _statusController,
                focusNode: _statusFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_avatarFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarController,
                focusNode: _avatarFocusNode,
                decoration: const InputDecoration(
                  labelText: 'URL Avatar (Opsional)',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  // Menutup keyboard karena ini adalah input teks terakhir
                  _avatarFocusNode.unfocus();
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
