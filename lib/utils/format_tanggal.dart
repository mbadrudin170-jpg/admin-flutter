// lib/utils/format_tanggal.dart
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormatTanggal {
  static String formatTanggal(DateTime tanggal) {
    return DateFormat.yMMMEd('id_ID').format(tanggal);
  }

  static String formatJam(DateTime tanggal) {
    return DateFormat.Hm('id_ID').format(tanggal);
  }

  static String formatAngka(num value) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(value);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-g]'), '');
    if (cleanText.isEmpty) {
      return const TextEditingValue(text: "", selection: TextSelection.collapsed(offset: 0));
    }

    double number = double.parse(cleanText);
    final formatter = NumberFormat("#,###", "id_ID");
    String newText = formatter.format(number);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}