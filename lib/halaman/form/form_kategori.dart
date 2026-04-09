// lib/halaman/form/form_kategori.dart
import 'package:flutter/material.dart';
import 'package:admin/model/kategori.dart';

class FormKategoriPage extends StatefulWidget {
  const FormKategoriPage({super.key});

  @override
  State<FormKategoriPage> createState() => _FormKategoriPageState();
}

class _FormKategoriPageState extends State<FormKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  TipeKategori _tipe = TipeKategori.pemasukan;
  final _namaController = TextEditingController();
  final _namaFocusNode = FocusNode();

  @override
  void dispose() {
    _namaController.dispose();
    _namaFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Kategori'),
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
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                ),
                textInputAction: TextInputAction.done, // Mengubah ke done
                onFieldSubmitted: (_) {
                  // Menutup keyboard karena ini adalah input terakhir
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<TipeKategori>(
                initialValue: _tipe,
                decoration: const InputDecoration(labelText: 'Tipe'),
                items: TipeKategori.values.map((TipeKategori tipe) {
                  return DropdownMenuItem<TipeKategori>(
                    value: tipe,
                    child: Text(tipe.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (TipeKategori? newValue) {
                  setState(() {
                    _tipe = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
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
