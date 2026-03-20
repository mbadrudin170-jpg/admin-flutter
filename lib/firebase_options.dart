// lib/firebase_options.dart
// Dihasilkan oleh FlutterFire CLI.
// Untuk mempelajari lebih lanjut, lihat: https://firebase.google.com/docs/flutter/setup#configure-your-app

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opsi Firebase default untuk platform saat ini.
///
/// **PENTING**: Ganti konten file ini dengan file yang Anda hasilkan
/// dari Firebase Console. Menjalankan `flutterfire configure` akan secara otomatis
/// menghasilkan file ini dengan konfigurasi yang benar untuk proyek Anda.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Konfigurasi Web - GANTI DENGAN KONFIGURASI ANDA
      return const FirebaseOptions(
        apiKey: 'GANTI-INI-DENGAN-API-KEY-ANDA',
        appId: 'GANTI-INI-DENGAN-APP-ID-ANDA',
        messagingSenderId: 'GANTI-INI-DENGAN-SENDER-ID-ANDA',
        projectId: 'GANTI-INI-DENGAN-PROJECT-ID-ANDA',
        authDomain: 'GANTI-INI-DENGAN-AUTH-DOMAIN-ANDA',
        storageBucket: 'GANTI-INI-DENGAN-STORAGE-BUCKET-ANDA',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Konfigurasi Android - GANTI DENGAN KONFIGURASI ANDA
        return const FirebaseOptions(
          apiKey: 'GANTI-INI-DENGAN-API-KEY-ANDA',
          appId: 'GANTI-INI-DENGAN-APP-ID-ANDA',
          messagingSenderId: 'GANTI-INI-DENGAN-SENDER-ID-ANDA',
          projectId: 'GANTI-INI-DENGAN-PROJECT-ID-ANDA',
          storageBucket: 'GANTI-INI-DENGAN-STORAGE-BUCKET-ANDA',
        );
      case TargetPlatform.iOS:
        // Konfigurasi iOS - GANTI DENGAN KONFIGURASI ANDA
        return const FirebaseOptions(
          apiKey: 'GANTI-INI-DENGAN-API-KEY-ANDA',
          appId: 'GANTI-INI-DENGAN-APP-ID-ANDA',
          messagingSenderId: 'GANTI-INI-DENGAN-SENDER-ID-ANDA',
          projectId: 'GANTI-INI-DENGAN-PROJECT-ID-ANDA',
          storageBucket: 'GANTI-INI-DENGAN-STORAGE-BUCKET-ANDA',
          iosBundleId: 'GANTI-INI-DENGAN-BUNDLE-ID-ANDA',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
