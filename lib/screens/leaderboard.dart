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
    print(Leaders);
    List<Widget> widgetlist = [];
    widgetlist.add(const Padding(
        padding: EdgeInsets.all(45),
        child: Text(
          "Leaderboard",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        )));
    widgetlist.add(
      SizedBox(
        height: MediaQuery.of(context).size.height / 8,
      ),
    );
    widgetlist.add(const Text(
      "Here is a leaderboard of the top RecycleHub users.",
      style: TextStyle(fontSize: 20),
    ));
    widgetlist.add(
      SizedBox(
        height: 40,
      ),
    );
    widgetlist.add(const Text(
      "Have fun competing to help our planet!",
      style: TextStyle(fontSize: 20),
    ));
    widgetlist.add(
      SizedBox(
        height: MediaQuery.of(context).size.height / 8,
      ),
    );

    widgetlist.add(const Text(
      "Top 50 Users",
      style: TextStyle(fontSize: 20),
    ));
    widgetlist.add(
      SizedBox(
        height: 20,
      ),
    );
    widgetlist.add(Divider());
    Leaders.forEach((usr) {
      widgetlist.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
            Text(usr.name),
            Spacer(),
            Text('${usr.totalCans.toString()} cans'),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
          ])));

      widgetlist.add(Divider());
    });
    // widgetlist.insertAll(
    //     1,
    //     Leaders.map((usr) => Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Container(
    //           margin: const EdgeInsets.all(15.0),
    //           padding: const EdgeInsets.all(3.0),
    //           decoration:
    //               BoxDecoration(border: Border.all(color: Colors.blueAccent)),
    //           child: Row(children: [
    //             const Spacer(),
    //             Text(usr.name),
    //             const Spacer(),
    //             Text(usr.totalCans.toString()),
    //             const Spacer(),
    //           ]),
    //         ))));
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetlist),
      ),
    )));
  }
}
