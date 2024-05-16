// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_1405/local_notification/local_notification.dart';
import 'package:practice_1405/phone_number/phone.dart';

import 'package:practice_1405/share_pref.dart/share_prefe.dart';
import 'package:practice_1405/twitter_login/twitter_login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await GetStorage.init();
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GetStoragePref sharePref = GetStoragePref();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: TwitterLoginDemo()
        // (sharePref.getLogin() != null)
        //     ? FireStoreScreen(userId: sharePref.getLogin())
        //     : const SignInScreen(),
        );
  }
}
