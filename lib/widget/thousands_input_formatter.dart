import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatter untuk TextField agar dapat menampilkan format angka ribuan secara otomatis.
/// Contoh: Saat pengguna mengetik '1000000', teks akan ditampilkan sebagai '1.000.000'.
class ThousandsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika teks baru kosong, tidak perlu melakukan apa-apa.
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Hapus semua karakter non-digit dari teks baru.
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Konversi string digit menjadi angka.
    final number = int.tryParse(newText);
    if (number == null) {
      // Jika parsing gagal, kembalikan nilai lama.
      return oldValue;
    }

    // Format angka menggunakan NumberFormat dari package 'intl'.
    // 'id_ID' akan menggunakan titik sebagai pemisah ribuan.
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedText = formatter.format(number);

    // Kembalikan nilai baru yang sudah diformat.
    // Posisi kursor diatur ke akhir teks.
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
