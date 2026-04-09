// lib/firebase_options.dart
// Dihasilkan oleh FlutterFire CLI.
// Untuk mempelajari lebih lanjut, lihat: https://firebase.google.com/docs/flutter/setup#configure-your-app

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDX0t3xU8zelxYj0oAz10PG4u4iUzb6QG4',
        appId: '1:816519063489:web:2eab7119b29bee88ce7140',
        messagingSenderId: '816519063489',
        projectId: 'management-wifi-3acc7',
        authDomain: 'management-wifi-3acc7.firebaseapp.com',
        storageBucket: 'management-wifi-3acc7.firebasestorage.app',
        measurementId: 'G-V2VNZ1XKLJ',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyAcXaRHRpoSDGS_ZcMAUSZLNy_64CvaADA',
          appId: '1:816519063489:android:034d3103dcedc1a3ce7140',
          messagingSenderId: '816519063489',
          projectId: 'management-wifi-3acc7',
          storageBucket: 'management-wifi-3acc7.firebasestorage.app',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions for iOS have not been configured but could be.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
