// lib/halaman/lainnya/pelanggan_aktif.dart
import 'package:flutter/material.dart';
import 'package:admin/data/operasi/pelanggan_aktif_operasi.dart';
import 'package:admin/halaman/detail/detail_pelanggan_aktif.dart';
import 'package:admin/halaman/form/form_pelanggan_aktif.dart';
import 'package:admin/model/pelanggan_aktif.dart';

class PelangganAktifPage extends StatefulWidget {
  const PelangganAktifPage({super.key});

  @override
  State<PelangganAktifPage> createState() => _PelangganAktifPageState();
}

class _PelangganAktifPageState extends State<PelangganAktifPage> {
  final PelangganAktifOperasi _pelangganAktifOperasi = PelangganAktifOperasi();
  late Future<List<PelangganAktif>> _listaPelangganAktifFuture;

  @override
  void initState() {
    super.initState();
    _loadPelangganAktif();
  }

  void _loadPelangganAktif() {
    setState(() {
      _listaPelangganAktifFuture = _pelangganAktifOperasi.getPelangganAktif();
    });
  }

  void _tambahPelangganAktif() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPelangganAktif()),
    );
    if (result == true) {
      _loadPelangganAktif();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PelangganAktif>>(
        future: _listaPelangganAktifFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pelanggan aktif ditemukan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pelanggan = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPelangganAktif(pelanggan: pelanggan),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pelanggan.avatar),
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: pelanggan.avatar.isEmpty
                            ? const Icon(Icons.person, size: 24)
                            : null,
                      ),
                      title: Text(
                        pelanggan.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Status: ${pelanggan.status.name}"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahPelangganAktif,
        child: const Icon(Icons.add),
      ),
    );
  }
}
