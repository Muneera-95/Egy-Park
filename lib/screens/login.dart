import 'package:egy_park/screens/map_screen.dart';
import 'package:egy_park/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  TextEditingController mailController = TextEditingController(),
      passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("./assets/images/small_logo.png"),
              SizedBox(
                height: 35,
              ),
              TextField(
                controller: mailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Enter your email address",
                  hintText: "test@test.com",
                  icon: Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Enter your password",
                  icon: Icon(Icons.security),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/signup');
                    },
                    child: Text("create new account"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (mailController.text != null &&
                            passController.text != null) {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: mailController.text,
                                    password: passController.text);

                            Navigator.popAndPushNamed(context, '/maps');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              _showToast(
                                  'No user found for that email.', Colors.red);
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              _showToast(
                                  'Wrong password provided for that user.',
                                  Colors.red);
                            }
                          }
                        } else {
                          _showToast(
                              "you have to fill all fields !!", Colors.black);
                        }
                      },
                      child: Text("Login")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(text, bkColor) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: bkColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
