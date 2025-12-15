// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  // 🌐 WEB CONFIG
  // ⚠️ Create a Web App in Firebase Console to get real values
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: 'REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '858660360344',
    projectId: 'cinemarathi-3fcf0',
    storageBucket: 'cinemarathi-3fcf0.firebasestorage.app',
    authDomain: 'cinemarathi-3fcf0.firebaseapp.com',
  );

  // 🤖 ANDROID CONFIG (from google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACJxHiBkBhvyO3SsxXwTr0a0-4yrpT9eE',
    appId: '1:858660360344:android:5e3b97da5d47c4f8c600ed',
    messagingSenderId: '858660360344',
    projectId: 'cinemarathi-3fcf0',
    storageBucket: 'cinemarathi-3fcf0.firebasestorage.app',
  );

  // 🍏 iOS CONFIG
  // ⚠️ Use values from GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '858660360344',
    projectId: 'cinemarathi-3fcf0',
    storageBucket: 'cinemarathi-3fcf0.firebasestorage.app',
    iosBundleId: 'com.sumit.cinemarathi',
  );
}
