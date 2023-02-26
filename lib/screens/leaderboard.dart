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
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(
                  child: Column(children: [
                ListView.builder(
                    itemCount: Leaders.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        Text(Leaders[index].name)),
                const Text(
                  "Leaderboard",
                  style: TextStyle(fontSize: 30),
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
