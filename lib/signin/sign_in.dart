// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_1405/auth_service.dart';
import 'package:practice_1405/ex_on_size.dart';
import 'package:practice_1405/firestore_screen/firestore.dart';
import 'package:practice_1405/share_pref.dart/share_prefe.dart';
import 'package:practice_1405/signup/sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GetStoragePref sharePref = GetStoragePref();

  _signIN() async {
    UserCredential? userCredential =
        await AuthService.signIn(emailController.text, passwordController.text);
    if (userCredential?.user != null) {
      sharePref.setLogin(userCredential?.user?.uid ?? "");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FireStoreScreen(
                    userId: userCredential?.user?.uid ?? "",
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: "email",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: "password",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await _signIN();
                },
                child: const Text("submit")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a account"),
                5.width,
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text("Sign up")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
