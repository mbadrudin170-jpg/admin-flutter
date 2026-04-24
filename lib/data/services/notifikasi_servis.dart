import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  debugPrint(
    'Notifikasi di-tap: ID=${notificationResponse.id}, '
    'Payload=${notificationResponse.payload}',
  );
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
            macOS: darwinInitializationSettings,
          );

      await _flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse,
      );

      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      debugPrint('NotifikasiServis: Timezone lokal diatur ke Asia/Jakarta.');
      debugPrint('NotifikasiServis: Inisialisasi berhasil');
    } catch (e) {
      debugPrint('NotifikasiServis: Error inisialisasi - $e');
    }
  }

  Future<void> requestPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }

      final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
      if (iOSImplementation != null) {
        await iOSImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      final MacOSFlutterLocalNotificationsPlugin? macOSImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >();
      if (macOSImplementation != null) {
        await macOSImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      debugPrint('NotifikasiServis: Permintaan izin selesai.');
    } catch (e) {
      debugPrint('NotifikasiServis: Gagal meminta izin notifikasi - $e');
    }
  }

  // ✅ BARU: Method untuk request exact alarm permission
  Future<bool> requestExactAlarmPermission() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        final bool? granted = await androidImplementation
            .requestExactAlarmsPermission();
        debugPrint('NotifikasiServis: Exact alarm granted: $granted');
        return granted ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('NotifikasiServis: Error request exact alarm: $e');
      return false;
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

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
      );

      // 🔥 PERBAIKAN PENTING: Ganti ke inexactAllowWhileIdle
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(jadwal, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode:
            AndroidScheduleMode.inexactAllowWhileIdle, // ← UBAH INI
        payload: 'notifikasi_paket',
      );

      debugPrint(
        'NotifikasiServis: Notifikasi dijadwalkan - ID: $id, Waktu: $jadwal',
      );
    } catch (e) {
      debugPrint('NotifikasiServis: Error jadwal notifikasi - $e');
      rethrow; // ← Tambahkan ini agar error muncul di UI
    }
  }

  Future<void> batalNotifikasi(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id: id);
      debugPrint('NotifikasiServis: Notifikasi dibatalkan - ID: $id');
    } catch (e) {
      debugPrint('NotifikasiServis: Error membatalkan notifikasi - $e');
    }
  }

  Future<void> tampilkanNotifikasiLangsung({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'id_notifikasi_langsung',
            'Notifikasi Langsung',
            channelDescription:
                'Channel untuk notifikasi yang ditampilkan langsung',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: 'notifikasi_langsung',
      );

      debugPrint('NotifikasiServis: Notifikasi langsung ditampilkan - ID: $id');
    } catch (e) {
      debugPrint(
        'NotifikasiServis: Error menampilkan notifikasi langsung - $e',
      );
    }
  }
}
