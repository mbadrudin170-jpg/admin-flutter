// path: lib/halaman/form/form_transaksi.dart
// Halaman ini menyediakan formulir untuk menambah atau mengedit transaksi.

import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/dompet_model.dart';

class FormTransaksiPage extends StatefulWidget {
  const FormTransaksiPage({super.key});

  @override
  State<FormTransaksiPage> createState() => _FormTransaksiPageState();
}

class _FormTransaksiPageState extends State<FormTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  DateTime _tanggal = DateTime.now();
  Kategori? _selectedKategori;
  SubKategori? _selectedSubKategori;
  TipeTransaksi _tipe = TipeTransaksi.pemasukan;
  Dompet? _selectedDompet;

  // Database operations
  final DompetOperasi _dompetOperasi = DompetOperasi();
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();
  List<Kategori> _kategoriList = [];
  List<Dompet> _dompetList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Fungsi untuk memuat data awal yang diperlukan oleh formulir.
  Future<void> _loadInitialData() async {
    try {
      final dompetList = await _dompetOperasi.getDompet();
      final kategoriList = await _kategoriOperasi.getKategoriByTipe(
        _tipe.toTipeKategori(),
      );

      setState(() {
        _dompetList = dompetList;
        _kategoriList = kategoriList;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk memuat ulang daftar kategori berdasarkan tipe transaksi yang dipilih.
  Future<void> _loadKategori() async {
    final kategoriList = await _kategoriOperasi.getKategoriByTipe(
      _tipe.toTipeKategori(),
    );
    setState(() {
      _kategoriList = kategoriList;
      _selectedKategori = null;
      _selectedSubKategori = null;
    });
  }

  // Fungsi untuk menyimpan data dari formulir.
  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      // Logic to save the form
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Transaksi'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Tipe Transaksi
                    DropdownButtonFormField<TipeTransaksi>(
                      initialValue: _tipe,
                      decoration: const InputDecoration(labelText: 'Tipe'),
                      items: TipeTransaksi.values.map((TipeTransaksi tipe) {
                        return DropdownMenuItem<TipeTransaksi>(
                          value: tipe,
                          child: Text(tipe.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (TipeTransaksi? newValue) {
                        setState(() {
                          _tipe = newValue!;
                          _loadKategori();
                        });
                      },
                    ),
                    // Keterangan
                    TextFormField(
                      controller: _keteranganController,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keterangan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    // Jumlah
                    TextFormField(
                      controller: _jumlahController,
                      decoration: const InputDecoration(labelText: 'Jumlah'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah tidak boleh kosong';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Format jumlah tidak valid';
                        }
                        return null;
                      },
                    ),
                    // Tanggal
                    ListTile(
                      title: Text('Tanggal: ${_tanggal.toLocal()}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _tanggal,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        // diubah: Menambahkan pengecekan null untuk memastikan 'picked' memiliki nilai sebelum melakukan assignment.
                        if (picked != null && picked != _tanggal) {
                          setState(() {
                            // diubah: Meng-assign nilai 'picked' yang sudah pasti tidak null ke '_tanggal'.
                            _tanggal = picked;
                          });
                        }
                      },
                    ),
                    // Dompet
                    DropdownButtonFormField<Dompet>(
                      initialValue: _selectedDompet,
                      decoration: const InputDecoration(labelText: 'Dompet'),
                      items: _dompetList.map((Dompet dompet) {
                        return DropdownMenuItem<Dompet>(
                          value: dompet,
                          child: Text(dompet.namaDompet),
                        );
                      }).toList(),
                      onChanged: (Dompet? newValue) {
                        setState(() {
                          _selectedDompet = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Dompet harus dipilih' : null,
                    ),

                    // Kategori
                    if (_kategoriList.isNotEmpty)
                      DropdownButtonFormField<Kategori>(
                        initialValue: _selectedKategori,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                        ),
                        items: _kategoriList
                            .where((k) => k.tipe == _tipe.toTipeKategori())
                            .map((Kategori kategori) {
                              return DropdownMenuItem<Kategori>(
                                value: kategori,
                                child: Text(kategori.nama),
                              );
                            })
                            .toList(),
                        onChanged: (Kategori? newValue) {
                          setState(() {
                            _selectedKategori = newValue;
                            _selectedSubKategori = null;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Kategori harus dipilih' : null,
                      ),

                    // Sub Kategori
                    if (_selectedKategori != null &&
                        _selectedKategori!.subKategori.isNotEmpty)
                      DropdownButtonFormField<SubKategori>(
                        initialValue: _selectedSubKategori,
                        decoration: const InputDecoration(
                          labelText: 'Sub Kategori',
                        ),
                        items: _selectedKategori!.subKategori.map((
                          SubKategori subKategori,
                        ) {
                          return DropdownMenuItem<SubKategori>(
                            value: subKategori,
                            child: Text(subKategori.nama),
                          );
                        }).toList(),
                        onChanged: (SubKategori? newValue) {
                          setState(() {
                            _selectedSubKategori = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Sub Kategori harus dipilih' : null,
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

  @override
  void dispose() {
    _jumlahController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }
}
