// path: lib/halaman/form/form_transaksi.dart
// Halaman ini menyediakan formulir untuk menambah atau mengedit transaksi.

import 'package:admin_wifi/data/operasi/kategori_operasi.dart';
import 'package:admin_wifi/data/operasi/dompet_operasi.dart';
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/model/kategori_model.dart';
import 'package:admin_wifi/model/transaksi_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/model/dompet_model.dart';
import 'package:uuid/uuid.dart';

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

  final DompetOperasi _dompetOperasi = DompetOperasi();
  final KategoriOperasi _kategoriOperasi = KategoriOperasi();
  final TransaksiOperasi _transaksiOperasi = TransaksiOperasi();

  List<Kategori> _kategoriList = [];
  List<Dompet> _dompetList = [];
  List<Kategori> _kategoriFiltered = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final dompetList = await _dompetOperasi.getDompet();
      final kategoriList = await _kategoriOperasi.getKategori();

      setState(() {
        _dompetList = dompetList;
        _kategoriList = kategoriList;
        _filterKategori();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void _filterKategori() {
    setState(() {
      _kategoriFiltered = _kategoriList.where((k) {
        final tipeKategoriTarget = _tipe == TipeTransaksi.pemasukan
            ? TipeKategori.pemasukan
            : TipeKategori.pengeluaran;
        return k.tipe == tipeKategoriTarget;
      }).toList();
      _selectedKategori = null;
      _selectedSubKategori = null;
    });
  }

  // ditambah: Fungsi untuk menampilkan pemilih tanggal
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _tanggal) {
      setState(() {
        _tanggal = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _tanggal.hour,
          _tanggal.minute,
        );
      });
    }
  }

  // ditambah: Fungsi untuk menampilkan pemilih waktu
  Future<void> _pilihWaktu(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_tanggal),
    );
    if (picked != null) {
      setState(() {
        _tanggal = DateTime(
          _tanggal.year,
          _tanggal.month,
          _tanggal.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _simpanForm() async {
    if (_formKey.currentState!.validate()) {
      final newTransaksi = TransaksiModel(
        id: const Uuid().v4(),
        keterangan: _keteranganController.text,
        jumlah: double.parse(_jumlahController.text),
        tanggal: _tanggal,
        tipe: _tipe,
        // Perbaikan: Menangani potensi null pada ID dengan memberikan nilai default
        idDompet: _selectedDompet?.id ?? '',
        namaDompet: _selectedDompet?.namaDompet ?? '',
        idKategori: _selectedKategori?.id ?? '',
        namaKategori: _selectedKategori?.nama ?? '',
        idSubKategori: _selectedSubKategori?.id,
        namaSubKategori: _selectedSubKategori?.nama,
        diperbarui: DateTime.now(),
      );

      try {
        await _transaksiOperasi.tambahTransaksi(newTransaksi);
        if (!mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan transaksi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Transaksi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<TipeTransaksi>(
                      initialValue: _tipe,
                      decoration: const InputDecoration(labelText: 'Tipe'),
                      items: TipeTransaksi.values.map((TipeTransaksi tipe) {
                        return DropdownMenuItem<TipeTransaksi>(
                          value: tipe,
                          child: Text(tipe.name),
                        );
                      }).toList(),
                      onChanged: (TipeTransaksi? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _tipe = newValue;
                            _filterKategori();
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _keteranganController,
                      decoration: const InputDecoration(labelText: 'Keterangan'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Keterangan tidak boleh kosong' : null,
                    ),
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
                    // diubah: Mengubah ListTile untuk menyertakan pemilihan tanggal dan jam
                    ListTile(
                      title: Text(
                          'Tanggal & Jam: ${_tanggal.toLocal().toString().split('.')[0]}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _pilihTanggal(context),
                            tooltip: 'Pilih Tanggal',
                          ),
                          // ditambah: Tombol untuk memilih jam
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _pilihWaktu(context),
                            tooltip: 'Pilih Jam',
                          ),
                        ],
                      ),
                    ),
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
                      validator: (value) => value == null ? 'Dompet harus dipilih' : null,
                    ),
                    if (_kategoriFiltered.isNotEmpty)
                      DropdownButtonFormField<Kategori>(
                        initialValue: _selectedKategori,
                        decoration: const InputDecoration(labelText: 'Kategori'),
                        items: _kategoriFiltered.map((Kategori kategori) {
                          return DropdownMenuItem<Kategori>(
                            value: kategori,
                            child: Text(kategori.nama),
                          );
                        }).toList(),
                        onChanged: (Kategori? newValue) {
                          setState(() {
                            _selectedKategori = newValue;
                            _selectedSubKategori = null;
                          });
                        },
                        validator: (value) => value == null ? 'Kategori harus dipilih' : null,
                      ),
                    if (_selectedKategori != null && _selectedKategori!.subKategori.isNotEmpty)
                      DropdownButtonFormField<SubKategori>(
                        initialValue: _selectedSubKategori,
                        decoration: const InputDecoration(labelText: 'Sub Kategori'),
                        items: _selectedKategori!.subKategori.map((SubKategori sub) {
                          return DropdownMenuItem<SubKategori>(
                            value: sub,
                            child: Text(sub.nama),
                          );
                        }).toList(),
                        onChanged: (SubKategori? newValue) {
                          setState(() {
                            _selectedSubKategori = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Sub Kategori harus dipilih' : null,
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