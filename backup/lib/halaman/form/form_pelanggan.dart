// Halaman ini menyediakan formulir untuk menambah atau mengedit data pelanggan.

import 'package:flutter/material.dart';
import 'package:admin_wifi/model/pelanggan_model.dart';
import 'package:admin_wifi/data/operasi/pelanggan_operasi.dart';

class FormPelanggan extends StatefulWidget {
  final Pelanggan? pelanggan;
  const FormPelanggan({super.key, this.pelanggan});

  @override
  State<FormPelanggan> createState() => _FormPelangganState();
}

class _FormPelangganState extends State<FormPelanggan> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _macAddressController = TextEditingController();

  final _namaFocusNode = FocusNode();
  final _teleponFocusNode = FocusNode();
  final _alamatFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _macAddressFocusNode = FocusNode();

  // ditambah: Variable untuk melacak status visibilitas password
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.pelanggan != null) {
      _namaController.text = widget.pelanggan!.nama;
      _teleponController.text = widget.pelanggan!.telepon;
      _alamatController.text = widget.pelanggan!.alamat;
      _passwordController.text = widget.pelanggan!.password;
      _macAddressController.text = widget.pelanggan!.macAddress;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    _passwordController.dispose();
    _macAddressController.dispose();
    _namaFocusNode.dispose();
    _teleponFocusNode.dispose();
    _alamatFocusNode.dispose();
    _passwordFocusNode.dispose();
    _macAddressFocusNode.dispose();
    super.dispose();
  }

  void _simpanForm() async {
    if (_formKey.currentState!.validate()) {
      final newPelanggan = Pelanggan(
        id: widget.pelanggan?.id ?? DateTime.now().toString(),
        nama: _namaController.text,
        telepon: _teleponController.text,
        alamat: _alamatController.text,
        password: _passwordController.text,
        macAddress: _macAddressController.text,
        diperbarui: DateTime.now().toIso8601String(),
      );
      if (widget.pelanggan == null) {
        await PelangganOperasi().createPelanggan(newPelanggan);
      } else {
        await PelangganOperasi().updatePelanggan(newPelanggan);
      }
      if (mounted) {
        // Kembalikan nilai true untuk menandakan ada perubahan
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pelanggan == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            // Pastikan tidak ada nilai yang dikembalikan saat tombol kembali ditekan
            Navigator.pop(context, false);
          },
        ),
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
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              // diubah: TextFormField untuk password dengan suffixIcon untuk toggle visibility
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  // ditambah: Ikon mata di bagian kanan field
                  suffixIcon: IconButton(
                    icon: Icon(
                      // ditambah: Mengubah ikon berdasarkan status visibility
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      // ditambah: Toggle status visibility saat ikon ditekan
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                // diubah: obscureText menggunakan variable _isPasswordVisible
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_macAddressFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _macAddressController,
                focusNode: _macAddressFocusNode,
                decoration: const InputDecoration(labelText: 'MAC Address'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _macAddressFocusNode.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'MAC Address tidak boleh kosong';
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