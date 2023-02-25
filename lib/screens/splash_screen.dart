import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:recyclehub/screens/user_signup_screen.dart';

import '../widgets/userdata.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final db = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    //print(userData);
    if (user == null) return UserSignUpScreen();
    return MultiProvider(
        providers: [
          StreamProvider.value(
              value: db
                  .doc(user!.uid)
                  .snapshots()
                  .map((snap) => UserData.fromFirestore(snap)),
              initialData: UserData(
                  uid: "",
                  name: "",
                  totalCans: 0,
                  defaultCenter: "",
                  defaultZip: 0))
        ],
        child: Scaffold(
            body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.width / 4),

              //button to login as a recycling center
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("Login as a Recycling Center")),
              const SizedBox(height: 48),

              ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSignUpScreen())),
                  child: const Text("Sign Up or Login as a User"))
            ],
          ),
        )));
  }
}
