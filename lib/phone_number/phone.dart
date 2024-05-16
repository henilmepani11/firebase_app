import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_1405/phone_number/verify_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  TextEditingController phoneNumberController = TextEditingController();

  void verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${phoneNumberController.text}",
      timeout: const Duration(seconds: 30),
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        log(error.code.toString());
      },
      codeSent: (verificationId, forceResendingToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VerifyScreen(verificationId: verificationId)));
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
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
                controller: phoneNumberController,
                decoration: const InputDecoration(
                    hintText: "Phone Number",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  verifyPhoneNumber();
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
