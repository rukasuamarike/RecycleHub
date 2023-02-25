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
      if (userData!.defaultZip == 0) {
        showDialog(
            context: context,
            builder: (BuildContext) => _SetZipDialog(context, userData));
      } else {
        await FirebaseFirestore.instance
            .collection("api")
            .where("PostalCode", isEqualTo: userData.defaultZip)
            .get()
            .then((snap) => snap.docs.map((e) => CRV.fromFirestore(e)))
            .then((crvs) => showDialog(
                context: context,
                builder: (BuildContext) => _CRVDialog(context, crvs)));
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
  final zipController = TextEditingController(text: uData.name);
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
              UserData temp = uData;
              if (zipController.text.isNotEmpty &&
                  zipController.text.length < 6) {
                temp.defaultZip = int.parse(zipController.text);
              }
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(uData.uid)
                  .update(uData.toJson())
                  .then((k) => Navigator.of(context).pop());
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

Widget _CRVDialog(BuildContext context, Iterable<CRV> datas) {
  List<CRV> lv = datas.toList();
  return AlertDialog(
    title: Text("Select shop"),
    content: SafeArea(
      child: ListView.builder(
          itemCount: lv.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(lv[index].FacilityName),
              subtitle: TextButton(
                onPressed: () async {
                  String query = Uri.encodeComponent(
                      '${lv[index].StreetAddress}, ${lv[index].City},CA ');
                  html.window.open(
                      'https://www.google.com/maps/search/?api=1&query=centurylink+field?api=1&query=${query}',
                      "bob");
                },
                child: Text('${lv[index].StreetAddress}, ${lv[index].City}'),

                ///
                /// TODO: upload resume button
                ///
              ),
            );
          }),
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
