// Path: lib/halaman/tab/lainnya.dart

import 'package:flutter/material.dart';
import '../../data/services/notifikasi_servis.dart';

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
      final DateTime jadwal = DateTime.now().add(const Duration(seconds: 10));
      final int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _notifikasiServis.jadwalNotifikasi(
        id: id,
        title: 'Notifikasi Terjadwal',
        body:
            'Notifikasi ini dijadwalkan pada ${jadwal.hour}:${jadwal.minute}:${jadwal.second}',
        jadwal: jadwal,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Notifikasi dijadwalkan 10 detik dari sekarang (ID: $id)',
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan & Lainnya')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
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
              ),

              const SizedBox(height: 12),

              // Tombol Jadwal Notifikasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
