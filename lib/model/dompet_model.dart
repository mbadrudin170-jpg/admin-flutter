
// lib/model/dompet_model.dart
class Dompet {
  String? id;
  String namaDompet;
  double saldo;
  String diperbarui;

  Dompet({this.id, required this.namaDompet, required this.saldo, required this.diperbarui});

  // Mengonversi Map dari Firestore menjadi objek Dompet
  factory Dompet.fromMap(Map<String, dynamic> map) {
    return Dompet(
      id: map['id'],
      namaDompet: map['namaDompet'],
      // Pastikan konversi tipe data angka benar
      saldo: (map['saldo'] as num).toDouble(),
      diperbarui: map['diperbarui'],
    );
  }

  // Mengonversi objek Dompet menjadi Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaDompet': namaDompet,
      'saldo': saldo,
      'diperbarui': diperbarui,
    };
  }
}
