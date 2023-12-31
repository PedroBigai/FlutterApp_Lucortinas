// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDRY_HBWd0ossmOoncU5Kx_G5z9r3boGR8',
    appId: '1:810445252188:web:f8fe6839786bba52dc6899',
    messagingSenderId: '810445252188',
    projectId: 'flutter-firebase-db-c5531',
    authDomain: 'flutter-firebase-db-c5531.firebaseapp.com',
    databaseURL: 'https://flutter-firebase-db-c5531-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-db-c5531.appspot.com',
    measurementId: 'G-G8Y9B274T0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIXLhTzPuKKXrnlXjyND8H_DYH98jLDNY',
    appId: '1:810445252188:android:60709ae2dfb78e65dc6899',
    messagingSenderId: '810445252188',
    projectId: 'flutter-firebase-db-c5531',
    databaseURL: 'https://flutter-firebase-db-c5531-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-db-c5531.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAteJ0lqWbt-QAFd2w-MXduff3pEfCpdWI',
    appId: '1:810445252188:ios:398c9f5fa7973161dc6899',
    messagingSenderId: '810445252188',
    projectId: 'flutter-firebase-db-c5531',
    databaseURL: 'https://flutter-firebase-db-c5531-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-db-c5531.appspot.com',
    iosBundleId: 'com.example.cortinas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAteJ0lqWbt-QAFd2w-MXduff3pEfCpdWI',
    appId: '1:810445252188:ios:eb1bb4142b0362b4dc6899',
    messagingSenderId: '810445252188',
    projectId: 'flutter-firebase-db-c5531',
    databaseURL: 'https://flutter-firebase-db-c5531-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-db-c5531.appspot.com',
    iosBundleId: 'com.example.cortinas.RunnerTests',
  );
}
