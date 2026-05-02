// path: lib/halaman/lainnya/paket.dart
// Halaman ini menampilkan daftar semua paket yang tersedia dan memungkinkan manajemen (CRUD) paket.

import 'package:admin_wifi/data/operasi/paket_operasi.dart';
import 'package:admin_wifi/halaman/detail/detail_paket.dart';
import 'package:admin_wifi/halaman/form/form_paket.dart';
import 'package:admin_wifi/model/paket_model.dart';
import 'package:flutter/material.dart';

class PaketPage extends StatefulWidget {
  const PaketPage({super.key});

  @override
  State<PaketPage> createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  final PaketOperasi _paketOperasi = PaketOperasi();
  late Future<List<Paket>> _paketFuture;

  @override
  void initState() {
    super.initState();
    _refreshPaketList();
  }

  // untuk memuat ulang daftar paket dari database dan memperbarui UI.
  void _refreshPaketList() {
    setState(() {
      _paketFuture = _paketOperasi.getPaket();
    });
  }

  // untuk menampilkan dialog yang memberikan opsi edit atau hapus pada paket yang dipilih.
  void _showEditDeleteDialog(Paket paket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(paket.nama),
          content: const Text('Pilih aksi yang ingin Anda lakukan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormPaket(paket: paket),
                  ),
                ).then((_) => _refreshPaketList());
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(paket);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // untuk menampilkan dialog konfirmasi sebelum menghapus paket secara permanen.
  void _showDeleteConfirmationDialog(Paket paket) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus paket ${paket.nama}?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.of(dialogContext).pop();

                try {
                  // diubah: Pemeriksaan null dan operator '!' dihapus karena
                  // analyzer dapat memastikan `paket.id` tidak pernah null di sini.
                  await _paketOperasi.hapusPaket(paket.id);
                  _refreshPaketList();

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Paket berhasil dihapus.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus paket: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // untuk menampilkan dialog konfirmasi sebelum menghapus semua paket.
  void _hapusSemuaPaket() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus semua paket? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.of(dialogContext).pop();

                try {
                  await _paketOperasi.hapusSemuaPaket();
                  _refreshPaketList();

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Semua paket berhasil dihapus.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus semua paket: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Paket'),
        actions: [
          IconButton(
            onPressed: _hapusSemuaPaket,
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Hapus Semua',
          ),
        ],
      ),
      body: FutureBuilder<List<Paket>>(
        future: _paketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada paket yang tersedia.'));
          }
          final paketList = snapshot.data!;
          return ListView.builder(
            itemCount: paketList.length,
            itemBuilder: (context, index) {
              final paket = paketList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPaketPage(paket: paket),
                    ),
                  ).then((_) => _refreshPaketList());
                },
                onLongPress: () {
                  _showEditDeleteDialog(paket);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      paket.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp ${paket.harga} / ${paket.durasi} ${paket.tipe.name}',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPaket()),
          ).then((_) => _refreshPaketList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
