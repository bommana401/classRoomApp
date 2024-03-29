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
    apiKey: 'AIzaSyA6PTelieF76awTkokIQr-H9agGypCjk2s',
    appId: '1:95982546280:web:ec724613d314725188badd',
    messagingSenderId: '95982546280',
    projectId: 'wise-app-5e02c',
    authDomain: 'wise-app-5e02c.firebaseapp.com',
    storageBucket: 'wise-app-5e02c.appspot.com',
    measurementId: 'G-TPYN6KLY7L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3SWP58gxE7_R0TgU9GVvnKrVZxWuG-LY',
    appId: '1:95982546280:android:fbe57ff6c808d57488badd',
    messagingSenderId: '95982546280',
    projectId: 'wise-app-5e02c',
    storageBucket: 'wise-app-5e02c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGy1F_MmlkLTmvgGmk_6CiOaHDomePX88',
    appId: '1:95982546280:ios:d327abb71245710788badd',
    messagingSenderId: '95982546280',
    projectId: 'wise-app-5e02c',
    storageBucket: 'wise-app-5e02c.appspot.com',
    iosClientId: '95982546280-r15t6bklpiq8nhom46tp1lo5s2add0pc.apps.googleusercontent.com',
    iosBundleId: 'com.example.classroomapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGy1F_MmlkLTmvgGmk_6CiOaHDomePX88',
    appId: '1:95982546280:ios:d327abb71245710788badd',
    messagingSenderId: '95982546280',
    projectId: 'wise-app-5e02c',
    storageBucket: 'wise-app-5e02c.appspot.com',
    iosClientId: '95982546280-r15t6bklpiq8nhom46tp1lo5s2add0pc.apps.googleusercontent.com',
    iosBundleId: 'com.example.classroomapp',
  );
}
