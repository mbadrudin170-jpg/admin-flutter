// lib/halaman/form/form_pelanggan.dart
import 'package:flutter/material.dart';

class FormPelanggan extends StatefulWidget {
  const FormPelanggan({super.key});

  @override
  State<FormPelanggan> createState() => _FormPelangganState();
}

class _FormPelangganState extends State<FormPelanggan> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();

  final _namaFocusNode = FocusNode();
  final _teleponFocusNode = FocusNode();
  final _alamatFocusNode = FocusNode();

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    _namaFocusNode.dispose();
    _teleponFocusNode.dispose();
    _alamatFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data pelanggan baru
      // final newPelanggan = Pelanggan(
      //   id: (daftarPelanggan.length + 1).toString(),
      //   nama: _namaController.text,
      //   telepon: _teleponController.text,
      //   alamat: _alamatController.text,
      // );
      // print('Pelanggan baru: ${newPelanggan.nama}');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pelanggan'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocusNode,
                decoration: const InputDecoration(labelText: 'Nama'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_teleponFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _teleponController,
                focusNode: _teleponFocusNode,
                decoration: const InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_alamatFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                focusNode: _alamatFocusNode,
                decoration: const InputDecoration(labelText: 'Alamat'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  // Menutup keyboard karena ini adalah input teks terakhir
                  _alamatFocusNode.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
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
