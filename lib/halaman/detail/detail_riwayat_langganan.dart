// path: lib/halaman/detail/detail_riwayat_langganan.dart
// File ini bertanggung jawab untuk menampilkan detail dari sebuah riwayat langganan.

import 'package:admin_wifi/halaman/form/form_edit_riwayat_langganan.dart';
import 'package:admin_wifi/model/riwayat_langganan_model.dart';
import 'package:admin_wifi/model/enum/status_pembayaran.dart';
import 'package:admin_wifi/utils/format_util.dart';
import 'package:admin_wifi/widget/nama_paket.dart';
import 'package:admin_wifi/widget/nama_pelanggan.dart';
import 'package:flutter/material.dart';
import 'package:admin_wifi/migrasi_diarsipkan.dart';

class DetailRiwayatLanggananPage extends StatefulWidget {
  final RiwayatLanggananModel riwayat;

  const DetailRiwayatLanggananPage({super.key, required this.riwayat});

  @override
  State<DetailRiwayatLanggananPage> createState() =>
      _DetailRiwayatLanggananPageState();
}

class _DetailRiwayatLanggananPageState
    extends State<DetailRiwayatLanggananPage> {
  late RiwayatLanggananModel _riwayat;

  @override
  void initState() {
    super.initState();
    _riwayat = widget.riwayat;
  }

  // Navigasi ke halaman edit dan segarkan data jika ada perubahan
  void _goToEditPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEditRiwayatLangganan(riwayat: _riwayat),
      ),
    );

    // Jika halaman edit mengembalikan 'true', segarkan halaman ini
    if (result == true) {
      if (mounted) {
        Navigator.of(context).pop(true); // Kirim sinyal kembali ke daftar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusPembayaranText = _riwayat.status.displayName;
    final statusPembayaranColor = _riwayat.status == StatusPembayaran.lunas
        ? Colors.green
        : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat'),
        actions: [
          const IconButton(
            onPressed: migrasiDiarsipkan,
            icon: Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _goToEditPage,
            tooltip: 'Edit Riwayat',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: NamaPelangganWidget(
                    idPelanggan: _riwayat.idPelanggan,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: NamaPaketWidget(
                    idPaket: _riwayat.idPaket,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(height: 32),
                _buildDetailRow(
                  context,
                  icon: Icons.payment,
                  label: 'Status Pembayaran',
                  value: statusPembayaranText,
                  valueColor: statusPembayaranColor,
                ),
                _buildDetailRow(
                  context,
                  icon: Icons.date_range,
                  label: 'Tanggal Mulai',
                  value: FormatTanggal.formatTanggalBasic(
                    _riwayat.tanggalMulai,
                  ), // Diperbaiki
                ),
                _buildDetailRow(
                  context,
                  icon: Icons.event_busy,
                  label: 'Tanggal Berakhir',
                  value: FormatTanggal.formatTanggalBasic(
                    _riwayat.tanggalBerakhir,
                  ), // Diperbaiki
                ),
                _buildDetailRow(
                  context,
                  icon: Icons.archive,
                  label: 'Diarsipkan Pada',
                  value: _riwayat.diperbarui != null
                      ? FormatTanggal.formatTanggalDanJam(_riwayat.diperbarui!)
                      : '-',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 16),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: valueColor != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
