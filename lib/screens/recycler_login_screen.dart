import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recyclehub/screens/turn_cans.dart';

import '../widgets/text_field_input.dart';

class RecyclerLogin extends StatefulWidget {
  const RecyclerLogin({super.key});

  @override
  State<RecyclerLogin> createState() => _RecyclerLoginState();
}

class _RecyclerLoginState extends State<RecyclerLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool auth = false;
    void loginCenter() async {
      await FirebaseFirestore.instance
          .collection("Centers")
          .where("authEmail", isEqualTo: _emailController.text)
          .get()
          .then((doc) {
        print(doc.docs.map((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          if (data["authEmail"] == "()") {
            print("snackbar that says ur not center user");
          } else {
            auth = true;
          }
        }));
      });
      if (auth) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TurnCans()));
      }
    }

    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Container(), flex: 2),
                      //add logo
                      const SizedBox(height: 64),
                      //text field for email
                      TextFieldInput(
                          textEditingController: _emailController,
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress),
                      //add space between the text fields
                      const SizedBox(
                        height: 24,
                      ),
                      //text field for pw
                      TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        isPass: true,
                      ),

                      const SizedBox(height: 24),
                      //login button
                      InkWell(
                        onTap: () => loginCenter(),
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                color: Colors.blue),
                            child: const Text('Log in as a Recycling Center')),
                      ),
                      const SizedBox(height: 12),
                      Flexible(child: Container(), flex: 2),
                    ]))));
  }
}
