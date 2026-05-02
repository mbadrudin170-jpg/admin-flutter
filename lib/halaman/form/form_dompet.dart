// path: lib/halaman/form/form_dompet.dart
// Halaman ini menyediakan formulir untuk menambah atau mengedit dompet.

import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/model/dompet_model.dart';
// diubah: Menggunakan formatter baru yang mendukung angka negatif.
import 'package:admin_wifi/widget/thousands_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

class FormDompet extends StatefulWidget {
  final Dompet? dompet;

  const FormDompet({super.key, this.dompet});

  @override
  State<FormDompet> createState() => _FormDompetState();
}

class _FormDompetState extends State<FormDompet> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _saldoController = TextEditingController();
  final DompetOperasi _dompetOperasi = DompetOperasi();

  late FocusNode _namaFocusNode;
  late FocusNode _saldoFocusNode;

  bool get _isEditMode => widget.dompet != null;

  @override
  void initState() {
    super.initState();
    _namaFocusNode = FocusNode();
    _saldoFocusNode = FocusNode();

    if (_isEditMode) {
      _namaController.text = widget.dompet!.namaDompet;
      _saldoController.text = NumberFormat(
        '#,##0',
        'id_ID',
      ).format(widget.dompet!.saldo);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _saldoController.dispose();
    _namaFocusNode.dispose();
    _saldoFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() async {
    _namaFocusNode.unfocus();
    _saldoFocusNode.unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        final saldo = double.parse(
          _saldoController.text.replaceAll('.', '').replaceAll(',', ''),
        );

        if (_isEditMode) {
          final updatedDompet = Dompet(
            id: widget.dompet!.id,
            namaDompet: _namaController.text,
            saldo: saldo,
            diperbarui: DateTime.now(),
          );
          await _dompetOperasi.updateDompet(updatedDompet);

          if (!mounted) return;
          Navigator.pop(context, true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dompet berhasil diperbarui!'),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          final nuevoDompet = Dompet(
            id: const Uuid().v4(),
            namaDompet: _namaController.text,
            saldo: saldo,
            diperbarui: DateTime.now(),
          );
          await _dompetOperasi.createDompet(nuevoDompet);
          if (!mounted) return;
          Navigator.pop(context, true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dompet berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e, s) {
        developer.log(
          'Gagal menyimpan dompet',
          name: 'form_dompet.save',
          error: e,
          stackTrace: s,
        );
        if (!mounted) return;
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
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Dompet' : 'Tambah Dompet'),
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
                  labelText: 'Nama Dompet',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_saldoFocusNode);
                },
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
                focusNode: _saldoFocusNode,
                decoration: InputDecoration(
                  labelText: _isEditMode ? 'Saldo' : 'Saldo Awal',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  // diubah: Menggunakan formatter baru yang mendukung angka negatif.
                  ThousandsAndNegativeInputFormatter(),
                ],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _simpanForm(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Saldo tidak boleh kosong';
                  }
                  // diubah: Penambahan logika untuk menangani tanda '-' saat validasi.
                  if (double.tryParse(
                            value.replaceAll('.', '').replaceAll(',', ''),
                          ) ==
                          null &&
                      value != '-') {
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
}
