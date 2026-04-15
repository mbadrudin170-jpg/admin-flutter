// lib/halaman/form/form_dompet.dart
import 'package:admin/data/operasi/dompet_operasi.dart';
import 'package:admin/model/dompet_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class FormDompet extends StatefulWidget {
  const FormDompet({super.key});

  @override
  State<FormDompet> createState() => _FormDompetState();
}

class _FormDompetState extends State<FormDompet> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _saldoController = TextEditingController();
  final DompetOperasi _dompetOperasi = DompetOperasi();

  void _simpanForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final nuevoDompet = Dompet(
          id: const Uuid().v4(),
          namaDompet: _namaController.text,
          // Hapus pemisah ribuan sebelum parsing
          saldo: double.parse(_saldoController.text.replaceAll('.', '')),
          diperbarui: DateTime.now(), // Setel waktu saat ini
        );
        await _dompetOperasi.createDompet(nuevoDompet);
        if (!mounted) return;
        Navigator.pop(context, true); // Kembali dan tandai sukses
        
        // Tampilkan Snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dompet berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );

      } catch (e, s) {
        // Tangkap dan log error
        developer.log(
          'Gagal menyimpan dompet',
          name: 'form_dompet.save',
          error: e,
          stackTrace: s,
        );
        if (!mounted) return;
        // Tampilkan Snackbar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan dompet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Dompet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Dompet',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama dompet tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _saldoController,
                decoration: const InputDecoration(
                  labelText: 'Saldo Awal',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Saldo tidak boleh kosong';
                  }
                  if (double.tryParse(value.replaceAll('.', '')) == null) {
                    return 'Format saldo tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _saldoController.dispose();
    super.dispose();
  }
}