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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCUPPXobeExYR-YxUzXyxNsW6wslMn4hZI',
    appId: '1:96324714014:web:d8eb89faf91ba9a580380f',
    messagingSenderId: '96324714014',
    projectId: 'pencatatan-kas-f4b28',
    authDomain: 'pencatatan-kas-f4b28.firebaseapp.com',
    storageBucket: 'pencatatan-kas-f4b28.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw0wuw_sqAedTvvgbhCrpKpmID_RWpEFM',
    appId: '1:96324714014:android:f006c264b8dddf7780380f',
    messagingSenderId: '96324714014',
    projectId: 'pencatatan-kas-f4b28',
    storageBucket: 'pencatatan-kas-f4b28.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcH5-mbB5CxDxq-piOpA97vjhl9zJLEGE',
    appId: '1:96324714014:ios:75151584fd3717b180380f',
    messagingSenderId: '96324714014',
    projectId: 'pencatatan-kas-f4b28',
    storageBucket: 'pencatatan-kas-f4b28.appspot.com',
    iosClientId: '96324714014-g09anhqbon48t3lot8hg01m46d32rum9.apps.googleusercontent.com',
    iosBundleId: 'com.example.pembayaranKas',
  );
}
