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
    apiKey: 'AIzaSyAJcVl3VeoaAG8Uu5N_9zfBDaw0Ir91zM0',
    appId: '1:256156674385:web:8dbc210c11f5f9e5a50b70',
    messagingSenderId: '256156674385',
    projectId: 'termini-firebase-auth',
    authDomain: 'termini-firebase-auth.firebaseapp.com',
    storageBucket: 'termini-firebase-auth.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUKZNhoIWPAEoL1uDRXhe10chr6dXJ560',
    appId: '1:256156674385:android:2593b50005c2c593a50b70',
    messagingSenderId: '256156674385',
    projectId: 'termini-firebase-auth',
    storageBucket: 'termini-firebase-auth.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxZaokCP6Jx3t_ZUO0ng48GfplkMF4DN4',
    appId: '1:256156674385:ios:89886a81823a558fa50b70',
    messagingSenderId: '256156674385',
    projectId: 'termini-firebase-auth',
    storageBucket: 'termini-firebase-auth.appspot.com',
    iosClientId: '256156674385-cki8coqnfhb55udpf2cq3p4akhk0pkjd.apps.googleusercontent.com',
    iosBundleId: 'com.mihajlora.lab4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxZaokCP6Jx3t_ZUO0ng48GfplkMF4DN4',
    appId: '1:256156674385:ios:89886a81823a558fa50b70',
    messagingSenderId: '256156674385',
    projectId: 'termini-firebase-auth',
    storageBucket: 'termini-firebase-auth.appspot.com',
    iosClientId: '256156674385-cki8coqnfhb55udpf2cq3p4akhk0pkjd.apps.googleusercontent.com',
    iosBundleId: 'com.mihajlora.lab4',
  );
}
