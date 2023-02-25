import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width / 16),
          //need to get the user's name from firebase
          const Text("User's Name",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.width / 32),
          InkWell(
            child: Text("My Recycling Center"),
            //on tap launch a google maps link
            onTap: () {},
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 32),

          //need to get the nubmer of cans from firebase
          Text("Number of Cans"),

          SizedBox(height: MediaQuery.of(context).size.width / 32),

          Text("User's email")
        ],
      ),
    ));
  }
}
