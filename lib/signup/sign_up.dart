import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice_1405/auth_service.dart';
import 'package:practice_1405/ex_on_size.dart';
import 'package:practice_1405/firestore_screen/firestore.dart';
import 'package:practice_1405/share_pref.dart/share_prefe.dart';
import 'package:practice_1405/signin/sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GetStoragePref sharePref = GetStoragePref();

  bool isLoader = false;

  setLoader(bool val) {
    isLoader = val;
    setState(() {});
  }

  _signUp() async {
    try {
      setLoader(true);
      UserCredential? userCredential = await AuthService.signUp(
          emailController.text, passwordController.text);
      if (userCredential?.user != null) {
        sharePref.setLogin(userCredential?.user?.uid ?? "");

        ///Firebase storage....
        var splitPath = file?.path.split("/").last;
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("users")
            .child(userCredential?.user?.uid ?? "")
            .child(splitPath!)
            .putFile(file!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        UserModel userModel = UserModel(
            email: emailController.text,
            id: userCredential?.user?.uid ?? "",
            password: passwordController.text,
            imageUrl: imageUrl);

        ///Firebase firestore...
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential?.user?.uid ?? "")
            .set(userModel.toJson());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => FireStoreScreen(
                      userId: userCredential?.user?.uid ?? "",
                    )),
            (route) => false);
      }
    } catch (e) {
      log(e.toString());
      setLoader(false);
    } finally {
      setLoader(false);
    }
  }

  File? file;
  pickedImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      file = File(xFile.path);
      print(file?.path);
    } else {
      log("image not picked");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await pickedImage();
              },
              child: CircleAvatar(
                radius: 42,
                backgroundImage: file?.path != null
                    ? FileImage(File(file?.path ?? ""))
                    : null,
              ),
            ),
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
            isLoader
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      await _signUp();
                    },
                    child: const Text("submit")),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Do you have a account"),
                5.width,
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    child: const Text("Sign in")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
