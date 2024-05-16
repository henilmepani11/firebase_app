import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginDemo extends StatefulWidget {
  const GoogleLoginDemo({super.key});

  @override
  State<GoogleLoginDemo> createState() => _GoogleLoginDemoState();
}

class _GoogleLoginDemoState extends State<GoogleLoginDemo> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    log("Succssfully login");
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                print("logout");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              UserCredential userCredential = await signInWithGoogle();
              print(userCredential.user?.email);
            },
            child: const Text("Google")),
      ),
    );
  }
}
