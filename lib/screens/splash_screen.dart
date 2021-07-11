import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      FirebaseAuth auth = FirebaseAuth.instance;
      _checkSigned();
    });
  }

  _checkSigned() {
    Future.delayed(Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
          Navigator.of(context).popAndPushNamed("/login");
        } else {
          print('User is signed in!');
          Navigator.of(context).popAndPushNamed("/maps");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
