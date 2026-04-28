
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_wifi/utils/perhitungan_util.dart';

void main() {
  group('PerhitunganUtil', () {
    group('sisaHari', () {
      test('should return positive days for a future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 5));
        expect(PerhitunganUtil.sisaHari(futureDate), 5);
      });

      test('should return 0 for today', () {
        final today = DateTime.now();
        expect(PerhitunganUtil.sisaHari(today), 0);
      });

      test('should return negative days for a past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 5));
        expect(PerhitunganUtil.sisaHari(pastDate), -5);
      });
    });

    group('getTeksSisaMasaAktif', () {
      test('should return remaining days for more than a day', () {
        final futureDate = DateTime.now().add(const Duration(days: 3, hours: 2));
        expect(PerhitunganUtil.getTeksSisaMasaAktif(futureDate), 'Sisa 3 hari');
      });

      test('should return remaining hours for less than a day', () {
        final futureDate = DateTime.now().add(const Duration(hours: 15));
        expect(PerhitunganUtil.getTeksSisaMasaAktif(futureDate), 'Sisa 15 jam');
      });

      test('should return remaining minutes for less than an hour', () {
        final futureDate = DateTime.now().add(const Duration(minutes: 45));
        expect(PerhitunganUtil.getTeksSisaMasaAktif(futureDate), 'Sisa 45 menit');
      });

      test('should return "Berakhir" for a past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        expect(PerhitunganUtil.getTeksSisaMasaAktif(pastDate), 'Berakhir');
      });

      test('should return "Berakhir dalam beberapa saat" for less than a minute', () {
        final futureDate = DateTime.now().add(const Duration(seconds: 30));
        expect(PerhitunganUtil.getTeksSisaMasaAktif(futureDate), 'Berakhir dalam beberapa saat');
      });
    });

    group('getWarnaSisaMasaAktif', () {
      test('should return green for more than 7 days remaining', () {
        final futureDate = DateTime.now().add(const Duration(days: 10));
        expect(PerhitunganUtil.getWarnaSisaMasaAktif(futureDate), Colors.green);
      });

      test('should return orange for 1 to 7 days remaining', () {
        final futureDate = DateTime.now().add(const Duration(days: 3));
        expect(PerhitunganUtil.getWarnaSisaMasaAktif(futureDate), Colors.orange);
      });

      test('should return red for today or past dates', () {
        final today = DateTime.now();
        final pastDate = DateTime.now().subtract(const Duration(days: 2));
        expect(PerhitunganUtil.getWarnaSisaMasaAktif(today), Colors.red);
        expect(PerhitunganUtil.getWarnaSisaMasaAktif(pastDate), Colors.red);
      });
    });
  });
}
