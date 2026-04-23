// Path: lib/data/services/notifikasi_servis.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  // TODO: Implementasikan logika untuk menangani notifikasi saat di-tap.
}

class NotifikasiServis {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> inisialisasi() async {
    try {
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings darwinInitializationSettings =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings,
          );

      await _flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse,
      );

      tz.initializeTimeZones();

      // Untuk debugging
      debugPrint('NotifikasiServis: Inisialisasi berhasil');
    } catch (e) {
      debugPrint('NotifikasiServis: Error inisialisasi - $e');
    }
  }

  Future<void> jadwalNotifikasi({
    required int id,
    required String title,
    required String body,
    required DateTime jadwal,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'id_kadaluarsa_paket',
            'Notifikasi Kadaluarsa Paket',
            channelDescription:
                'Channel untuk notifikasi paket yang akan berakhir',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(jadwal, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint(
        'NotifikasiServis: Notifikasi dijadwalkan - ID: $id, Waktu: $jadwal',
      );
    } catch (e) {
      debugPrint('NotifikasiServis: Error jadwal notifikasi - $e');
    }
  }
}
