import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyclehub/screens/turn_cans.dart';

import '../widgets/text_field_input.dart';
import '../widgets/userdata.dart';

class TurnCans extends StatefulWidget {
  const TurnCans({super.key});

  @override
  State<TurnCans> createState() => _TurnCansState();
}

class _TurnCansState extends State<TurnCans> {
  final TextEditingController _turnCanin = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void saveCan() async {
    num cans = 0;
    late UserData receiver;
    if (_turnCanin.text.isNotEmpty && _emailController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: _emailController.text)
          .get()
          .then((snap) => {
                receiver = UserData.fromFirestore(snap.docs[0]),
                cans = receiver.totalCans
              });
      DocumentReference<Map<String, dynamic>> ref =
          FirebaseFirestore.instance.collection("Users").doc(receiver.uid);
      await ref
          .get()
          .then((snap) => cans = UserData.fromFirestore(snap).totalCans);
      cans += int.parse(_turnCanin.value.text);
      await ref.update({"totalCans": cans});
    }
    print(
        'confirmed gave ${receiver.name} ${_turnCanin.text} cans! total: ${cans}');
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    return Scaffold(
        body: Center(
            child: userData.crvauth
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    width: MediaQuery.of(context).size.width > 500
                        ? 500
                        : double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 32),
                          const Text("Turn in Cans",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 9),
                          //text field for email
                          TextFieldInput(
                              textEditingController: _emailController,
                              hintText: "Enter user's email",
                              textInputType: TextInputType.emailAddress),
                          //add space between the text fields
                          const SizedBox(height: 24),
                          //text field for Trash Can
                          TextFieldInput(
                              textEditingController: _turnCanin,
                              hintText: 'Enter the number of Cans',
                              textInputType: TextInputType.name),
                          const SizedBox(height: 24),
                          //Proceed Button
                          InkWell(
                            onTap: () async => saveCan(),
                            child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    color: Colors.green),
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        'Proceed',
                                        style: TextStyle(color: Colors.black),
                                      )),
                          ),
                          const SizedBox(height: 12),
                          Flexible(child: Container(), flex: 2),
                        ]))
                : Container(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "To Recycle for Points:",
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          "Go to your local center and give them your Rehub Email",
                          style: TextStyle(fontSize: 30),
                        ),
                        Spacer()
                      ],
                    ),
                  )));
    //return const Placeholder();
  }
}
