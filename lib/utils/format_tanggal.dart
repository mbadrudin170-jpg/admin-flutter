import 'package:intl/intl.dart';

class FormatTanggal {
  static String formatTanggal(DateTime tanggal) {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(tanggal);
  }

  static String formatJam(DateTime tanggal) {
    return DateFormat('HH:mm').format(tanggal);
  }

  static String formatBulanTahun(DateTime tanggal) {
    return DateFormat('MMMM yyyy', 'id_ID').format(tanggal);
  }

  static String formatTanggalAngka(DateTime tanggal) {
    return DateFormat('dd/MM/yyyy').format(tanggal);
  }

   static String formatTanggalAngkaJam(DateTime tanggal) {
    return DateFormat('dd/MM/yyyy, HH:mm').format(tanggal);
  }
}
