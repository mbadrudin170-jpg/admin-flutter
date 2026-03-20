import 'package:flutter/material.dart';
import 'package:myapp/model/pelanggan.dart';
import 'package:myapp/data/pelanggan_data.dart';

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

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      final newPelanggan = Pelanggan(
        id: (daftarPelanggan.length + 1).toString(),
        nama: _namaController.text,
        telepon: _teleponController.text,
        alamat: _alamatController.text,
      );
      // Logika untuk menyimpan data pelanggan baru
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _teleponController,
                decoration: const InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
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
