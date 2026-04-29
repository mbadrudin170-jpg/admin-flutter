
import 'package:admin_wifi/data/operasi/transaksi_operasi.dart';
import 'package:admin_wifi/model/transaksi_model.dart';

class TransaksiRepository {
  final TransaksiOperasi _transaksiOperasi;

  TransaksiRepository(this._transaksiOperasi);

  Future<int> tambahTransaksi(TransaksiModel transaksi) async {
    return await _transaksiOperasi.tambahTransaksi(transaksi);
  }

  Future<List<TransaksiModel>> ambilSemuaTransaksi() async {
    return await _transaksiOperasi.ambilSemuaTransaksi();
  }

  // Tambahkan fungsi lain jika diperlukan (update, delete, dll.)
}
