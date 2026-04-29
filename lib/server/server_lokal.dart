// path: lib/server/server_lokal.dart
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer; // ditambah: import developer log
import 'package:admin_wifi/data/operasi/pesan_operasi.dart';
import 'package:admin_wifi/model/pesan_model.dart';

class ServerLokal {
  final PesanOperasi operasi;
  ServerSocket? _server;

  ServerLokal(this.operasi);

  // untuk menjalankan server lokal
  Future<void> jalankanServer(Function(PesananModel) onPesananMasuk) async {
    if (_server != null) {
      developer.log(
        "Server sudah berjalan",
        name: 'server.lokal',
      ); // diubah: menggunakan developer.log
      return;
    }

    try {
      _server = await ServerSocket.bind(InternetAddress.anyIPv4, 4545);
      developer.log(
        "Server Aktif di Port 4545",
        name: 'server.lokal',
      ); // diubah: menggunakan developer.log

      _server!.listen((Socket client) {
        developer.log(
          "Client terhubung: ${client.remoteAddress}",
          name: 'server.lokal',
        ); // diubah: menggunakan developer.log

        client.listen(
          (data) async {
            try {
              String rawJson = utf8.decode(data);
              Map<String, dynamic> jsonMap = json.decode(rawJson);
              final pesanan = PesananModel.fromMap(jsonMap);

              await operasi.simpanPesanan(pesanan);
              client.write("OK");
              onPesananMasuk(pesanan);
            } catch (e, s) {
              // ditambah: stacktrace
              client.write("ERROR: ${e.toString()}");
              developer.log(
                "Gagal proses data",
                error: e,
                stackTrace: s,
                name: 'server.lokal.error',
              ); // diubah: menggunakan developer.log dengan error
            }
          },
          onError: (error, s) {
            // ditambah: stacktrace
            developer.log(
              "Client error",
              error: error,
              stackTrace: s,
              name: 'server.lokal.error',
            ); // diubah: menggunakan developer.log dengan error
          },
          onDone: () {
            developer.log(
              "Client disconnected",
              name: 'server.lokal',
            ); // diubah: menggunakan developer.log
            client.destroy();
          },
        );
      });
    } catch (e, s) {
      // ditambah: stacktrace
      developer.log(
        "Server Error",
        error: e,
        stackTrace: s,
        name: 'server.lokal.error',
      ); // diubah: menggunakan developer.log dengan error
      _server = null;
    }
  }

  // untuk menghentikan server lokal
  void stop() {
    _server?.close();
    _server = null;
  }
}
