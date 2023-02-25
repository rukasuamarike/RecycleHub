import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recyclehub/screens/user_signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width / 4),

          //button to login as a recycling center
          ElevatedButton(
              onPressed: () {},
              child: const Text("Login as a Recycling Center")),
          const SizedBox(height: 48),

          ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserSignUpScreen())),
              child: const Text("Sign Up or Login as a User"))
        ],
      ),
    ));
  }
}
