// path: lib/halaman/tab/lainnya.dart
import 'package:admin_wifi/data/operasi/kritik_saran_operasi.dart';
import 'package:flutter/material.dart';
// import '../../data/services/notifikasi_servis.dart';
import '../lainnya/kategori.dart';
import '../lainnya/kritik_saran.dart';
import '../lainnya/paket.dart';
import '../lainnya/pelanggan.dart';
import '../lainnya/riwayat_aktivasi_paket.dart';
import '../lainnya/tentang_aplikasi.dart';
import 'pesan.dart';

class LainnyaPage extends StatefulWidget {
  const LainnyaPage({super.key});

  @override
  State<LainnyaPage> createState() => _LainnyaTabState();
}

class _LainnyaTabState extends State<LainnyaPage> {
  // Fungsi bantuan untuk membuat tombol navigasi
  Widget _buildNavigationButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan & Lainnya')),
      // diubah: Menggunakan ListView untuk menghindari overflow
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // diubah: Tambahkan Divider dan judul untuk bagian navigasi
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 16.0),
          //   child: Divider(),
          // ),
          // Text(
          //   'Halaman Lainnya',
          //   style: Theme.of(context).textTheme.titleLarge,
          // ),
          // const SizedBox(height: 8),

          // diubah: Tambahkan tombol navigasi ke halaman lainnya
          _buildNavigationButton(
            title: 'Daftar Pesanan',
            icon: Icons.shopping_cart,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HalamanPesan()),
            ),
          ),
          _buildNavigationButton(
            title: 'Kelola Kategori',
            icon: Icons.category,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KategoriPage()),
            ),
          ),
          _buildNavigationButton(
              title: 'Kritik & Saran',
              icon: Icons.feedback,
              onTap: () async {
                // 1. Unduh data dari Firebase
                final dataFromFirebase =
                    await KritikSaranOperasi.unduhDataDariFirebase();

                // diubah/ditambah: periksa mounted setelah operasi async
                if (!mounted) return;

                // 2. Simpan data ke database lokal
                if (dataFromFirebase.isNotEmpty) {
                  final operasi = KritikSaranOperasi();
                  await operasi.sisipkanAtauPerbaruiBatch(dataFromFirebase);
                  // diubah/ditambah: periksa mounted setelah operasi async kedua
                  if (!mounted) return;
                }

                // 3. Navigasi ke halaman setelah data disinkronkan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KritikSaranPage()),
                );
              }),
          _buildNavigationButton(
            title: 'Kelola Paket WiFi',
            icon: Icons.wifi,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaketPage()),
            ),
          ),
          _buildNavigationButton(
            title: 'Daftar Pelanggan',
            icon: Icons.people,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PelangganPage()),
            ),
          ),
          _buildNavigationButton(
            title: 'Riwayat Aktivasi Paket',
            icon: Icons.history,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RiwayatAktivasiPaketPage(),
              ),
            ),
          ),
          _buildNavigationButton(
            title: 'Tentang Aplikasi',
            icon: Icons.info,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TentangAplikasiPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
