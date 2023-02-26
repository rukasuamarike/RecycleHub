import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:recyclehub/screens/recycler_login_screen.dart';
import 'package:recyclehub/screens/user_login_screen.dart';
import 'package:recyclehub/screens/user_signup_screen.dart';
import 'package:recyclehub/widgets/crv.dart';

import '../widgets/userdata.dart';
import 'home.dart';

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
    if (user == null) {
      return Scaffold(
          body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width / 4),

            //button to login as a recycling center
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RecyclerLogin())),
                child: const Text("Login as a Recycling Center")),
            const SizedBox(height: 48),

            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLoginScreen())),
                child: const Text("Sign Up or Login as a User"))
          ],
        ),
      ));
    }
    return MultiProvider(providers: [
      StreamProvider.value(
          value: db
              .doc(user.uid)
              .snapshots()
              .map((snap) => UserData.fromFirestore(snap)),
          initialData: UserData(
              uid: "",
              name: "",
              totalCans: 0,
              defaultCenter: "",
              defaultZip: 0)),
      StreamProvider.value(
          value: FirebaseFirestore.instance
              .collection("Users")
              .orderBy("totalCans", descending: true)
              .limit(50)
              .snapshots()
              .map((snap) =>
                  snap.docs.map((doc) => UserData.fromFirestore(doc)).toList()),
          initialData: [
            UserData(
                uid: "uid",
                name: "name",
                totalCans: 0,
                defaultCenter: "defaultCenter",
                defaultZip: 0)
          ])
    ], child: Home());
  }
}
