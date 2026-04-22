// lib/utils/sync_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class SyncManager {
  static const _kLastSyncTimestampKey = 'last_sync_timestamp';

  Future<DateTime> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_kLastSyncTimestampKey);
    // Jika belum pernah sinkronisasi, gunakan waktu yang sangat lampau
    // agar semua data terambil saat pertama kali.
    if (timestamp == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> setLastSyncTimestamp(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastSyncTimestampKey, time.millisecondsSinceEpoch);
  }
}
