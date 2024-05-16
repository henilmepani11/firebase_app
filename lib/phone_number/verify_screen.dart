import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  final String verificationId;
  const VerifyScreen({super.key, required this.verificationId});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController otpController = TextEditingController();

  void signInWithOTP() async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("phone login successfully")));
    } catch (e) {
      log(e.toString());
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
                controller: otpController,
                decoration: const InputDecoration(
                    hintText: "Verify Number",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  signInWithOTP();
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
