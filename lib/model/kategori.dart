
// lib/model/kategori.dart

enum TipeKategori {
  pemasukan,
  pengeluaran,
}

class Kategori {
  String? id;
  final String nama;
  final TipeKategori tipe;
  final List<SubKategori> subKategori;
  DateTime? diperbarui; // <-- Kolom baru ditambahkan

  Kategori({
    this.id,
    required this.nama,
    required this.tipe,
    this.subKategori = const [],
    this.diperbarui,
  });

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'],
      nama: map['nama'] ?? '',
      tipe: TipeKategori.values.firstWhere(
        (e) => e.name == map['tipe'],
        orElse: () => TipeKategori.pemasukan,
      ),
      subKategori: (map['subKategori'] as List<dynamic>? ?? [])
          .map((subMap) => SubKategori.fromMap(subMap as Map<String, dynamic>))
          .toList(),
      diperbarui: map['diperbarui'] != null ? DateTime.parse(map['diperbarui']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'tipe': tipe.name,
      'subKategori': subKategori.map((sub) => sub.toMap()).toList(),
      'diperbarui': diperbarui?.toIso8601String(), // <-- Kolom baru ditambahkan
    };
  }
}

class SubKategori {
  String? id;
  final String nama;
  DateTime? diperbarui; // <-- Kolom baru ditambahkan

  SubKategori({this.id, required this.nama, this.diperbarui});

  factory SubKategori.fromMap(Map<String, dynamic> map) {
    return SubKategori(
      id: map['id'],
      nama: map['nama'] ?? '',
      diperbarui: map['diperbarui'] != null ? DateTime.parse(map['diperbarui']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'diperbarui': diperbarui?.toIso8601String(), // <-- Kolom baru ditambahkan
    };
  }
}
