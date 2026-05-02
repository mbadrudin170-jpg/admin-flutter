// lib/halaman/form/form_kategori.dart
// Halaman ini menyediakan formulir untuk menambah atau mengedit kategori.

import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/kategori_model.dart';

class FormKategoriPage extends StatefulWidget {
  final Kategori? kategori; // Tambahkan ini untuk mode edit
  const FormKategoriPage({super.key, this.kategori});

  @override
  State<FormKategoriPage> createState() => _FormKategoriPageState();
}

class _FormKategoriPageState extends State<FormKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final KategoriOperasi _kategoriOperasi = KategoriOperasi(); // Instance operasi

  late TipeKategori _tipe;
  late TextEditingController _namaController;
  final _namaFocusNode = FocusNode();

  bool get _isEditMode => widget.kategori != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();

    if (_isEditMode) {
      // Jika mode edit, isi form dengan data yang ada
      _namaController.text = widget.kategori!.nama;
      _tipe = widget.kategori!.tipe;
    } else {
      // Jika mode tambah, gunakan nilai default
      _tipe = TipeKategori.pemasukan;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _namaFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() async {
    if (_formKey.currentState!.validate()) {
      final kategoriBaru = Kategori(
        id: _isEditMode ? widget.kategori!.id : null, // Pertahankan ID jika edit
        nama: _namaController.text,
        tipe: _tipe,
        diperbarui: DateTime.now(),
      );

      try {
        if (_isEditMode) {
          await _kategoriOperasi.update(kategoriBaru);
        } else {
          await _kategoriOperasi.createKategori(kategoriBaru);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar( // Tambahkan const
            content: Text('Kategori berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Kirim 'true' untuk menandakan sukses
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar( // Tidak bisa const karena ada variabel 'e'
            content: Text('Gagal menyimpan kategori: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Kategori' : 'Form Kategori'),
        leading: const BackButton(),
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
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TipeKategori>(
                initialValue: _tipe,
                decoration: const InputDecoration(
                  labelText: 'Tipe',
                  border: OutlineInputBorder(),
                ),
                items: TipeKategori.values.map((TipeKategori tipe) {
                  return DropdownMenuItem<TipeKategori>(
                    value: tipe,
                    child: Text(
                        tipe.name.substring(0, 1).toUpperCase() +
                        tipe.name.substring(1),
                    ),
                  );
                }).toList(),
                onChanged: (TipeKategori? newValue) {
                  setState(() {
                    if (newValue != null) {
                      _tipe = newValue;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanForm,
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
