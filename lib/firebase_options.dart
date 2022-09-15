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
    apiKey: 'AIzaSyAtJ6OSPO30qqRhCM7SanzWG_H1XlQul_g',
    appId: '1:803632526216:web:69e02d3dd3791db95f803d',
    messagingSenderId: '803632526216',
    projectId: 'angola-flutter',
    authDomain: 'angola-flutter.firebaseapp.com',
    storageBucket: 'angola-flutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzknopFKCZGb2BoNHzM1BGeACDDPG07PI',
    appId: '1:803632526216:android:39f65edad45a5e6d5f803d',
    messagingSenderId: '803632526216',
    projectId: 'angola-flutter',
    storageBucket: 'angola-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCN3gjh_wNYMbPgOw8IZ-jBZofYDlicdeA',
    appId: '1:803632526216:ios:ffc7314a817d38595f803d',
    messagingSenderId: '803632526216',
    projectId: 'angola-flutter',
    storageBucket: 'angola-flutter.appspot.com',
    iosClientId: '803632526216-mvvpfaf86sfupl47u0of56ejbb0aggi8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterAngola',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCN3gjh_wNYMbPgOw8IZ-jBZofYDlicdeA',
    appId: '1:803632526216:ios:ffc7314a817d38595f803d',
    messagingSenderId: '803632526216',
    projectId: 'angola-flutter',
    storageBucket: 'angola-flutter.appspot.com',
    iosClientId: '803632526216-mvvpfaf86sfupl47u0of56ejbb0aggi8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterAngola',
  );
}
