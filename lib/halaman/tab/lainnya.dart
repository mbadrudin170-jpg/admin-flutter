// path: lib/halaman/tab/lainnya.dart
import 'package:flutter/material.dart';
import '../../data/services/notifikasi_servis.dart';
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
  final NotifikasiServis _notifikasiServis = NotifikasiServis();
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initNotifikasi();
  }

  Future<void> _initNotifikasi() async {
    await _notifikasiServis.inisialisasi();
    await _notifikasiServis.requestPermissions();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _tampilkanNotifikasiLangsung() async {
    setState(() => _isLoading = true);
    try {
      await _notifikasiServis.tampilkanNotifikasiLangsung(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Halo dari MyApp!',
        body: 'Ini adalah notifikasi langsung yang dikirim sekarang.',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Notifikasi berhasil dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal mengirim notifikasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _jadwalkanNotifikasi() async {
    setState(() => _isLoading = true);
    try {
      // Ubah ke 10 detik sesuai label
      final DateTime jadwal = DateTime.now().add(const Duration(seconds: 10));
      final int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      // Debug: Print waktu jadwal
      debugPrint('Menjadwalkan notifikasi pada: $jadwal');
      debugPrint('Waktu sekarang: ${DateTime.now()}');

      await _notifikasiServis.jadwalNotifikasi(
        id: id,
        title: 'Notifikasi Terjadwal',
        body:
            'Notifikasi ini dijadwalkan pada ${jadwal.hour}:${jadwal.minute.toString().padLeft(2, '0')}:${jadwal.second.toString().padLeft(2, '0')}',
        jadwal: jadwal,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Notifikasi dijadwalkan pada ${jadwal.hour}:${jadwal.minute.toString().padLeft(2, '0')}:${jadwal.second.toString().padLeft(2, '0')} (ID: $id)',
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error jadwalkan notifikasi: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menjadwalkan notifikasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
          // Status inisialisasi
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isInitialized
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isInitialized ? Colors.green : Colors.orange,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isInitialized ? Icons.check_circle : Icons.hourglass_top,
                  color: _isInitialized ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  _isInitialized
                      ? 'Notifikasi Siap'
                      : 'Menyiapkan Notifikasi...',
                  style: TextStyle(
                    color: _isInitialized ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tombol Notifikasi Langsung
          ElevatedButton.icon(
            onPressed: (_isInitialized && !_isLoading)
                ? _tampilkanNotifikasiLangsung
                : null,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.notifications_active),
            label: const Text('Kirim Notifikasi Langsung'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 12),

          // Tombol Jadwal Notifikasi
          ElevatedButton.icon(
            onPressed: (_isInitialized && !_isLoading)
                ? _jadwalkanNotifikasi
                : null,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.schedule),
            label: const Text('Jadwalkan Notifikasi (10 detik)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),

          // diubah: Tambahkan Divider dan judul untuk bagian navigasi
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          Text(
            'Halaman Lainnya',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KritikSaranPage()),
            ),
          ),
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
