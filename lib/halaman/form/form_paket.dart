import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/model/paket.dart';

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

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _durasiController.dispose();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Paket',
                  border: OutlineInputBorder(),
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                decoration: const InputDecoration(
                  labelText: 'Durasi',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
