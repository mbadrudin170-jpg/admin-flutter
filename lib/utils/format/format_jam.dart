// Path: lib/utils/format/format_jam.dart
import 'package:intl/intl.dart';

class FormatJam {
  /// Mengubah DateTime menjadi format "HH:mm" (Contoh: 14:30)
  static String formatKeJamMenit(DateTime waktu) {
    return DateFormat('HH:mm').format(waktu);
  }

  /// Mengubah DateTime menjadi format "HH:mm:ss" (Contoh: 14:30:05)
  static String formatKeJamLengkap(DateTime waktu) {
    return DateFormat('HH:mm:ss').format(waktu);
  }

  /// Mengubah string waktu (dari API/DB) menjadi format jam menit
  static String formatTeksKeJam(String teksWaktu) {
    try {
      DateTime waktuSesuai = DateTime.parse(teksWaktu);
      return DateFormat('HH:mm').format(waktuSesuai);
    } catch (e) {
      return "--:--";
    }
  }
}
