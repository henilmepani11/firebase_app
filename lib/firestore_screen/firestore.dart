// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice_1405/auth_service.dart';
import 'package:practice_1405/ex_on_size.dart';
import 'package:practice_1405/share_pref.dart/share_prefe.dart';
import 'package:practice_1405/signin/sign_in.dart';

class FireStoreScreen extends StatefulWidget {
  final String userId;
  const FireStoreScreen({super.key, required this.userId});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  GetStoragePref sharePref = GetStoragePref();

  logOut() async {
    await AuthService.signOut();
    sharePref.clearLogin();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  UserModel? userModel;
  fetchData() async {
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .get();

    userModel = UserModel(
        email: data["email"],
        id: data["id"],
        password: data["password"],
        imageUrl: data["imageUrl"]);
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await logOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundImage: userModel?.imageUrl != null
                  ? NetworkImage(userModel?.imageUrl ?? "")
                  : null,
            ),
            12.height,
            Text(userModel?.email ?? "")
          ],
        ),
      ),
    );
  }
}
