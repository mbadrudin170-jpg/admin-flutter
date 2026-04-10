// lib/model/pelanggan.dart

class Pelanggan {
  final String id;
  final String nama;
  final String telepon;
  final String alamat;
  final String password;
  final String macAddress;
  final String diperbarui;

  Pelanggan({
    required this.id,
    required this.nama,
    required this.telepon,
    required this.alamat,
    required this.password,
    required this.macAddress,
    required this.diperbarui,
  });

  // Tambahkan metode fromMap dan toMap jika belum ada
  factory Pelanggan.fromMap(Map<String, dynamic> map) {
    return Pelanggan(
      id: map['id'],
      nama: map['nama'],
      telepon: map['telepon'],
      alamat: map['alamat'],
      password: map['password'],
      macAddress: map['mac_address'],
      diperbarui: map['diperbarui'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'telepon': telepon,
      'alamat': alamat,
      'password': password,
      'mac_address': macAddress,
      'diperbarui': diperbarui,
    };
  }
}
