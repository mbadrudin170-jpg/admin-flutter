import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:admin_wifi/utils/format_util.dart';

void main() {
  // Inisialisasi format tanggal untuk lokal 'id_ID' sebelum menjalankan pengujian.
  // Ini penting untuk setiap pengujian yang bergantung pada pemformatan khusus lokal.
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('FormatTanggal', () {
    // Tanggal yang konsisten untuk semua pengujian terkait tanggal.
    // Ini adalah hari Sabtu.
    final testDate = DateTime(2024, 8, 17, 10, 30, 15);

    test('formatTanggalBasic harus memformat tanggal dengan benar', () {
      // Output yang diharapkan: "17 Agu 2024"
      expect(FormatTanggal.formatTanggalBasic(testDate), '17 Agu 2024');
    });

    test(
      'formatTanggalDanJam harus memformat tanggal dan waktu dengan benar',
      () {
        // Output yang diharapkan: "17 Agu 2024, 10:30"
        expect(
          FormatTanggal.formatTanggalDanJam(testDate),
          '17 Agu 2024, 10:30',
        );
      },
    );

    test('formatTanggalRingkas harus memformat tanggal secara singkat', () {
      // Output yang diharapkan: "Sab, 17 Agu 24"
      // 'Sab' adalah singkatan dari 'Sabtu' dalam lokal 'id_ID'.
      expect(FormatTanggal.formatTanggalRingkas(testDate), 'Sab, 17 Agu 24');
    });
  });

  group('FormatJam', () {
    final testTime = DateTime(2024, 8, 17, 22, 5, 45);

    test('formatJamMenit harus memformat waktu dengan benar (HH:mm)', () {
      expect(FormatJam.formatJamMenit(testTime), '22:05');
    });

    test(
      'formatJamLengkap harus memformat waktu dengan detik dengan benar (HH:mm:ss)',
      () {
        expect(FormatJam.formatJamLengkap(testTime), '22:05:45');
      },
    );

    test('formatTeksKeJam harus mengonversi string ISO yang valid ke waktu', () {
      // String ini dalam format UTC. String ini akan diurai dan kemudian diformat dalam zona waktu lokal.
      const isoString = '2024-08-17T14:30:00.000Z';
      final dateTime = DateTime.parse(isoString).toLocal();
      // Membuat output yang diharapkan secara dinamis untuk menghindari ketidakstabilan terkait zona waktu.
      final expected =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

      expect(FormatJam.formatTeksKeJam(isoString), expected);
    });

    test(
      'formatTeksKeJam harus mengembalikan fallback untuk string yang tidak valid',
      () {
        const invalidString = 'ini-bukan-tanggal';
        expect(FormatJam.formatTeksKeJam(invalidString), '--:--');
      },
    );

    test(
      'formatTeksKeJam harus mengembalikan fallback untuk string kosong',
      () {
        expect(FormatJam.formatTeksKeJam(''), '--:--');
      },
    );
  });

  group('FormatUang', () {
    test('formatMataUang harus memformat nol dengan benar', () {
      expect(FormatUang.formatMataUang(0), 'Rp 0');
    });

    test(
      'formatMataUang harus memformat jumlah standar dengan pemisah ribuan',
      () {
        expect(FormatUang.formatMataUang(50000), 'Rp 50.000');
      },
    );

    test('formatMataUang harus memformat jumlah besar dengan benar', () {
      expect(FormatUang.formatMataUang(123456789), 'Rp 123.456.789');
    });

    test(
      'formatMataUang harus menangani angka floating point dengan pembulatan',
      () {
        // Implementasi menentukan `decimalDigits: 0`, dan NumberFormat membulatkan.
        expect(FormatUang.formatMataUang(75555.99), 'Rp 75.556');
      },
    );

    test('formatMataUang harus memformat angka negatif dengan tanda minus', () {
      // Format mata uang standar 'id_ID' untuk angka negatif adalah -Rp 50.000.
      expect(FormatUang.formatMataUang(-50000), '-Rp 50.000');
    });
  });
}
