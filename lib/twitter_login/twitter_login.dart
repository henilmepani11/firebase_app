import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';

class TwitterLoginDemo extends StatefulWidget {
  const TwitterLoginDemo({super.key});

  @override
  State<TwitterLoginDemo> createState() => _TwitterLoginDemoState();
}

class _TwitterLoginDemoState extends State<TwitterLoginDemo> {
  Future<UserCredential> signInWithTwitter() async {
    final twitterLogin = TwitterLogin(
        apiKey: 'mh6sWTGzrOrlq4Pb4KD8x6sEs',
        apiSecretKey: 'AoW7BsoXvKnBsvqZCp4pUjeitCO43BWP6i5X5traptHgQC6NCV',
        redirectURI: 'socialauth://');

    final authResult = await twitterLogin.login();

    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(twitterAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                await signInWithTwitter();
              },
              child: const Text("Twitter"))),
    );
  }
}
