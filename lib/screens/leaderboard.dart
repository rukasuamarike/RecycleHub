import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/userdata.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    Future<List<UserData>> Leaders = FirebaseFirestore.instance
        .collection("Users")
        .orderBy("totalCans", descending: true)
        .limit(50)
        .get()
        .then((snap) =>
            snap.docs.map((doc) => UserData.fromFirestore(doc)).toList());
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("Users")
                          .orderBy("totalCans", descending: true)
                          .limit(50)
                          .get(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List<UserData> usrlist = snapshot.data
                              .map((doc) => UserData.fromFirestore(doc))
                              .toList();
                          return Container(
                              child: ListView.builder(
                                  itemCount: usrlist.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(usrlist[index].name);
                                  }));
                        }
                      })),
              const Text(
                "Leaderboard",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
