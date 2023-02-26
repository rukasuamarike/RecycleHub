import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../widgets/userdata.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    List<UserData> Leaders = Provider.of<List<UserData>>(context);
    List<Widget> widgetlist = [];
    widgetlist.add(const Text(
      "Leaderboard",
      style: TextStyle(fontSize: 30),
    ));
    widgetlist.insertAll(
        1,
        Leaders.map((usr) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(children: [
                Text(usr.name),
                Spacer(),
                Text(usr.totalCans.toString())
              ]),
            )));
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SafeArea(child: Column(children: widgetlist))],
          ),
        ),
      ),
    );
  }
}
