import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:recyclehub/screens/home.dart';
import 'dart:html' as html;
import '../widgets/crv.dart';
import '../widgets/userdata.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
            .then((crvs) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(CustomSnack("no nearby recycle centers"));
          showDialog(
              context: context,
              builder: (context) => _CRVDialog(context, crvs, userData));
          if (crvs.isEmpty) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Center(
                        child: Text("no nearby recycle centers"),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"))
                      ],
                    ));
          }
        });
      }
    }

    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width / 16),
          //need to get the user's name from firebase
          Text(userData!.name,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.width / 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("My Default Recycling Center: "),
              TextButton(
                onPressed: () async {
                  String query = Uri.encodeComponent(userData.defaultCenter);
                  html.window.open(
                      'https://www.google.com/maps/search/?api=1&query=${query}',
                      "bob");
                },
                child: Text(userData.defaultCenter.isEmpty
                    ? "Not set yet"
                    : userData.defaultCenter),
              ),
            ],
          ),

          TextButton(
            onPressed: () => mapuri(),
            child: Text(userData.defaultCenter.isEmpty ? "Set" : "Update"),
          ),

          SizedBox(height: MediaQuery.of(context).size.width / 32),

          //need to get the nubmer of cans from firebase
          Text('Total Cans: ${userData.totalCans.toString()}'),

          SizedBox(height: MediaQuery.of(context).size.width / 32),

          Text('Email: ${user!.providerData[0].email.toString()}')
        ],
      ),
    );
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

SnackBar CustomSnack(String message) {
  return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'CRV locations',
        onPressed: () {
          html.window.open(
              "https://www2.calrecycle.ca.gov/BevContainer/RecyclingCenters/",
              "recycle");
        },
      ));
}

Widget _CRVDialog(BuildContext context, List<CRV> datas, UserData usr) {
  print(datas);
  bool hidden = true;
  TextEditingController _zipcontrol = TextEditingController();

  return StatefulBuilder(builder: (context, setState) {
    return AlertDialog(
        title: Text("Select Recycle Center"),
        actions: [
          TextButton(
              onPressed: () => setState(() {
                    hidden = false;
                  }),
              child: const Text("Update Zipcode")),
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
              children: hidden
                  ? datas.map((e) => CustomTile(context, e, usr.uid)).toList()
                  : [
                      TextField(controller: _zipcontrol),
                      TextButton(
                        onPressed: () async {
                          num temp = 0;
                          if (_zipcontrol.text.isNotEmpty &&
                              _zipcontrol.text.length < 6) {
                            temp = int.parse(_zipcontrol.text);
                          }
                          //update userzip
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(usr.uid)
                              .update({"defaultZip": temp}).then(
                                  (k) => Navigator.of(context).pop());
                        },
                        child: Text("Set"),
                      )
                    ]),
        )));
  });
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