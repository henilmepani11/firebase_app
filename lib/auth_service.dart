import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<UserCredential?> signUp(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<UserCredential?> signIn(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

class UserModel {
  String email;
  String password;
  String id;
  String? imageUrl;

  UserModel(
      {required this.email,
      required this.id,
      required this.password,
      this.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json["email"], id: json["id"], password: json["password"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "id": id,
      "imageUrl": imageUrl,
    };
  }
}
