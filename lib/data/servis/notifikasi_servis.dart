// path: lib/data/servis/notifikasi_servis.dart
// diubah: File ini diperbarui untuk memperbaiki error akibat perubahan besar pada API flutter_local_notifications.
// Perubahan ini didasarkan pada pesan error dari 'flutter analyze' yang mengindikasikan bahwa
// parameter positional telah diganti dengan parameter named.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ditambah: Placeholder function untuk menangani saat notifikasi di-tap.
void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  // Misalnya, navigasi ke halaman detail pelanggan.
}

class NotifikasiServis {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> inisialisasi() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: darwinInitializationSettings,
        );

    // diubah: Menyesuaikan pemanggilan inisialisasi. Sekarang menggunakan named parameter 'settings'.
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
    );

    tz.initializeTimeZones();
  }

  Future<void> jadwalNotifikasi({
    required int id,
    required String title,
    required String body,
    required DateTime jadwal,
  }) async {
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

    // diubah: zonedSchedule sekarang sepenuhnya menggunakan named parameters.
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(jadwal, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
