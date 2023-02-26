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
import 'package:recyclehub/screens/leaderboard.dart';
import 'package:recyclehub/screens/profile.dart';
import 'package:recyclehub/screens/turn_cans.dart';
import 'package:recyclehub/widgets/userdata.dart';
import '../widgets/crv.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  static List<Widget> _views = [Profile(), TurnCans(), Leaderboard()];
  static const List<Widget> tabs = [];

  @override
  void _onItemTapped(int index) {
    setState(() => _page = index);
  }

  Widget Ctab(pagenum, title) {
    return InkWell(
      onTap: () => setState(() => _page = pagenum),
      child: Container(
          width: MediaQuery.of(context).size.width / 5,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              color: Colors.green),
          child: Text(title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    UserData? userData = Provider.of<UserData?>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ctab(0, "Profile"),
            SizedBox(width: MediaQuery.of(context).size.width / 10),
            Ctab(1, "Turn in Cans"),
            SizedBox(width: MediaQuery.of(context).size.width / 10),
            Ctab(2, "Leaderboard")
          ],
        ),
      ),
      body: _views[_page],
    );
  }
}
