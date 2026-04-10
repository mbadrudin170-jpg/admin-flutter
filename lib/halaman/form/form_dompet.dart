// lib/halaman/form/form_dompet.dart
import 'package:flutter/material.dart';
import 'package:admin/data/operasi/dompet_operasi.dart';
import 'package:admin/model/dompet_model.dart';
import 'package:admin/utils/format.dart';
import 'package:uuid/uuid.dart';

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
      final nuevoDompet = Dompet(
        id: const Uuid().v4(),
        namaDompet: _namaController.text,
        saldo: double.parse(_saldoController.text.replaceAll('.', '')),
        diperbarui: DateTime.now().toIso8601String(),
      );
      await _dompetOperasi.createDompet(nuevoDompet);
      if (!mounted) return;
      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Dompet'),
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
                decoration: const InputDecoration(labelText: 'Nama Dompet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama dompet tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _saldoController,
                decoration: const InputDecoration(labelText: 'Saldo Awal'),
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Saldo tidak boleh kosong';
                  }
                  if (double.tryParse(value.replaceAll('.', '')) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
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
