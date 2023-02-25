import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:recyclehub/widgets/userdata.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    UserData? userData = Provider.of<UserData?>(context);

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width / 16),
          //need to get the user's name from firebase
          Text(userData!.name,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.width / 32),
          InkWell(
            child: const Text("My Recycling Center"),
            //on tap launch a google maps link
            onTap: () {},
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 32),

          //need to get the nubmer of cans from firebase
          Text(userData!.totalCans.toString()),

          SizedBox(height: MediaQuery.of(context).size.width / 32),

          Text(user!.providerData[0].email as String)
        ],
      ),
    ));
  }
}
