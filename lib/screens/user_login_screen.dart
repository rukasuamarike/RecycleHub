import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recyclehub/screens/home.dart';
import 'package:recyclehub/screens/user_signup_screen.dart';
import 'package:recyclehub/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recyclehub/widgets/userdata.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isNewUser = false;
  // @override
  // void dispose() {

  //   _emailController.dispose();
  //   _passwordController.dispose();
  // }

  void loginUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  void signUpUser() async {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((cred) async => await FirebaseFirestore.instance
              .collection("Users")
              .doc(cred.user!.uid)
              .set(UserData(
                      uid: cred.user!.uid,
                      name: _nameController.text,
                      totalCans: 0,
                      defaultCenter: "",
                      defaultZip: 0)
                  .toJson()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: _isNewUser
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    width: MediaQuery.of(context).size.width > 500
                        ? 500
                        : double.infinity,
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
                            onTap: () async =>
                                {loginUser(), Navigator.of(context).pop()},
                            child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    color: Colors.blue),
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                    : const Text('Log in')),
                          ),
                          const SizedBox(height: 12),
                          Flexible(child: Container(), flex: 2),

                          //sign up button
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _isNewUser = !_isNewUser;
                                  }),
                                  child: Container(
                                    child: Text("Sign up"),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ])
                        ]))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    width: MediaQuery.of(context).size.width > 500
                        ? 500
                        : double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFieldInput(
                              textEditingController: _nameController,
                              hintText: 'Enter your name',
                              textInputType: TextInputType.name),
                          //for spacing
                          const SizedBox(height: 24),
                          //text field for email
                          TextFieldInput(
                              textEditingController: _emailController,
                              hintText: 'Enter your email',
                              textInputType: TextInputType.emailAddress),
                          //add space between the text fields
                          const SizedBox(height: 24),
                          //text field for pw
                          TextFieldInput(
                            textEditingController: _passwordController,
                            hintText: 'Enter your password',
                            textInputType: TextInputType.text,
                            isPass: true,
                          ),
                          const SizedBox(height: 12),

                          //sign up button
                          InkWell(
                            onTap: () async =>
                                {signUpUser(), Navigator.of(context).pop()},
                            child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    color: Colors.blue),
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : const Text('Sign up')),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _isNewUser = !_isNewUser;
                                  }),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: const Text("Login"),
                                  ),
                                ),
                              ])
                        ]))));
  }
}
