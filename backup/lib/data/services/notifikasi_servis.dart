import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  debugPrint('🔔 Notifikasi di-tap: ID=${notificationResponse.id}');
}

class NotifikasiServis {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'admin_wifi_channel';
  static const String channelName = 'Admin WiFi Notifications';

  Future<void> inisialisasi() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      );

      // 🔥 1. INIT DULU
      await _flutterLocalNotificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse,
      );

      // 🔥 2. BARU BUAT CHANNEL
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: 'Notifikasi untuk aplikasi Admin WiFi',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: Colors.blue,
        showBadge: true,
      );

      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.createNotificationChannel(channel);

      // 🔥 3. TIMEZONE
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

      debugPrint('✅ INISIALISASI BERHASIL');
    } catch (e) {
      debugPrint('❌ ERROR INISIALISASI: $e');
      rethrow;
    }
  }

  Future<void> requestPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImpl =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImpl != null) {
        final bool? granted = await androidImpl
            .requestNotificationsPermission();
        debugPrint('🔔 IZIN NOTIFIKASI: ${granted == true ? "✅ YES" : "❌ NO"}');
      }

      final IOSFlutterLocalNotificationsPlugin? iosImpl =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
      if (iosImpl != null) {
        await iosImpl.requestPermissions(alert: true, badge: true, sound: true);
      }

      debugPrint('✅ IZIN SELESAI');
    } catch (e) {
      debugPrint('❌ ERROR IZIN: $e');
    }
  }

  Future<void> tampilkanNotifikasiLangsung({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: 'Notifikasi Admin WiFi',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
      );

      debugPrint('✅ NOTIFIKASI TERKIRIM: $id - $title');
    } catch (e) {
      debugPrint('❌ GAGAL: $e');
      rethrow;
    }
  }

  Future<void> jadwalNotifikasi({
    required int id,
    required String title,
    required String body,
    required DateTime jadwal,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: 'Notifikasi Admin WiFi',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 🔥 PERBAIKAN: Hapus parameter yang tidak valid
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(jadwal, tz.local),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );

      debugPrint('✅ TERJADWAL: $id pada $jadwal');
    } catch (e) {
      debugPrint('❌ GAGAL JADWAL: $e');
      rethrow;
    }
  }

  Future<void> batalNotifikasi(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  /// Memperbarui jadwal notifikasi yang sudah ada.
  /// Jika notifikasi dengan ID yang sama sudah dijadwalkan, jadwalnya akan ditimpa dengan yang baru.
  Future<void> perbaruiJadwalNotifikasi({
    required int id,
    required String title,
    required String body,
    required DateTime jadwal,
  }) async {
    try {
      // Memanggil fungsi jadwalNotifikasi karena ia akan menimpa jadwal lama jika ID sama.
      await jadwalNotifikasi(id: id, title: title, body: body, jadwal: jadwal);
      debugPrint('✅ JADWAL DIPERBARUI: $id pada $jadwal');
    } catch (e) {
      debugPrint('❌ GAGAL PERBARUI JADWAL: $e');
      rethrow;
    }
  }
}
