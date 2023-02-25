import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recyclehub/screens/user_login_screen.dart';

import '../widgets/text_field_input.dart';
import '../widgets/userdata.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   _nameController.dispose();
  // }

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
                      defaultZip: 95053)
                  .toJson()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Container(), flex: 2),
                      const SizedBox(height: 64),
                      //text field for name
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

                      const SizedBox(height: 24),
                      //login button
                      InkWell(
                        onTap: () async => signUpUser(),
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                color: Colors.blue),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  )
                                : const Text('Sign up')),
                      ),
                      const SizedBox(height: 12),
                      Flexible(child: Container(), flex: 2),

                      //sign up button
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
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserLoginScreen())),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const Text("Login"),
                              ),
                            ),
                          ])
                    ]))));
    ;
  }
}
