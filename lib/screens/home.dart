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
import 'package:recyclehub/widgets/userdata.dart';
import '../widgets/crv.dart';

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

    void mapuri() async {
      print(userData!.defaultZip);
      if (userData.defaultZip == 0) {
        showDialog(
            context: context,
            builder: (context) => _SetZipDialog(context, userData));
      } else {
        List<num> ziprange = [];
        for (int i = 0; i < 5; i++) {
          ziprange.add(userData.defaultZip + i);
          ziprange.add(userData.defaultZip - i);
        }
        await FirebaseFirestore.instance
            .collection("api")
            .where("PostalCode", whereIn: ziprange)
            .get()
            .then((snap) => snap.docs.map((e) => CRV.fromFirestore(e)).toList())
            .then((crvs) => showDialog(
                context: context,
                builder: (context) => _CRVDialog(context, crvs, userData)));
      }
    }

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width / 16),
          //need to get the user's name from firebase
          Text(userData!.name,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.width / 32),
          InkWell(
            child: const Text("My Recycling Center"),
            //on tap launch a google maps link
            onTap: () async {
              mapuri();
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 32),

          //need to get the nubmer of cans from firebase
          Text(userData.totalCans.toString()),

          SizedBox(height: MediaQuery.of(context).size.width / 32),

          Text(user!.providerData[0].email as String)
        ],
      ),
    ));
  }
}

Widget _SetZipDialog(BuildContext context, UserData uData) {
  final zipController =
      TextEditingController(text: uData.defaultZip.toString());
  return AlertDialog(
    title: Text("Set zipcode"),
    content: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: zipController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Enter your zipcode"),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          TextButton(
            onPressed: () async {
              num temp = 0;
              if (zipController.text.isNotEmpty &&
                  zipController.text.length < 6) {
                temp = int.parse(zipController.text);
              }
              //update userzip
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(uData.uid)
                  .update({"defaultZip": temp}).then(
                      (k) => Navigator.of(context).pop());
            },
            child: Text("Set"),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel")),
    ],
  );
}

Widget _CRVDialog(BuildContext context, List<CRV> datas, UserData usr) {
  print(datas);
  return AlertDialog(
      title: Text("Select Recycle Center"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
      ],
      content: Center(
          child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: datas.map((e) => CustomTile(context, e, usr.uid)).toList(),
        ),
      )));
}

Widget CustomTile(BuildContext context, CRV c, String uid) {
  return ListTile(
    title: Text(c.FacilityName),
    onTap: () async => await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .update({
      "defaultCenter": c.FacilityName,
      "defaultZip": c.PostalCode
    }).then((value) => Navigator.of(context).pop()),
    subtitle: TextButton(
      onPressed: () async {
        String query = Uri.encodeComponent('${c.FacilityName} ${c.City}');
        html.window.open(
            'https://www.google.com/maps/search/?api=1&query=${query}', "bob");
      },
      child: Text('${c.StreetAddress}, ${c.City}'),
    ),
  );
}
