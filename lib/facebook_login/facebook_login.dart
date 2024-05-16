import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginDemo extends StatefulWidget {
  const FacebookLoginDemo({super.key});

  @override
  State<FacebookLoginDemo> createState() => _FacebookLoginDemoState();
}

class _FacebookLoginDemoState extends State<FacebookLoginDemo> {
  signInWithFacebook() async {
    try {
      final LoginResult loginResult =
          await FacebookAuth.instance.login(permissions: ["public_profile"]);

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        UserCredential? userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          log(userCredential.user.toString());
        }
      } else {
        throw FirebaseAuthException(
          code: 'Facebook Login Failed',
          message: 'The Facebook login was not successful.',
        );
      }
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Exception: ${e.message}');
    } catch (e) {
      log('Other Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                await signInWithFacebook();
              },
              child: const Text('Facebook'))),
    );
  }
}
