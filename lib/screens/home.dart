import 'dart:io';
import 'dart:core';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:recyclehub/screens/profile.dart';
import 'package:recyclehub/widgets/userdata.dart';
import '../widgets/crv.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  static List<Widget> _views = [Profile()];
  static const List<Widget> tabs = [];
  late TabController _controller;

  @override
  void _onItemTapped(int index) {
    setState(() => _page = index);
  }

  Widget Ctab(pagenum, title, Function() onpress) {
    return InkWell(
      onTap: () => setState(() => {_page = pagenum, onpress}),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              color: Colors.blue),
          child: Text(title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    UserData? userData = Provider.of<UserData?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Ctab(0, "Profile", () => print(userData!.name)),
            Ctab(1, "Turn in Cans", () => print(userData!.totalCans)),
            Ctab(0, "Leaderboard", () => print("async get function here"))
          ],
        ),
      ),
      body: _views[_page],
    );
  }
}
