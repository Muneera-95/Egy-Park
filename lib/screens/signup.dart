import 'package:Q_park/screens/login.dart';
import 'package:Q_park/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupState();
  }
}

class _SignupState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController(),
      phoneController = TextEditingController(),
      mailController = TextEditingController(),
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
          padding: EdgeInsets.only(top: 100, right: 25, left: 25, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("./assets/images/small_logo.png"),
              SizedBox(
                height: 35,
              ),
              Expanded(
                  child: ListView(
                children: [
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Enter your full name",
                      icon: Icon(Icons.person),
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
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter your phone number",
                      hintText: "01xxxxxxxxx",
                      icon: Icon(Icons.phone),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/login');
                        },
                        child: Text("already have account?"),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (mailController.text != null &&
                                passController.text != null &&
                                nameController.text != null &&
                                phoneController.text != null) {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                  email: mailController.text,
                                  password: passController.text,
                                );

                                Navigator.popAndPushNamed(context, '/maps');
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                  _showToast(
                                      'The password provided is too weak.',
                                      Colors.red);
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                  _showToast(
                                      'The account already exists for that email.',
                                      Colors.red);
                                }
                              } catch (e) {
                                print(e);
                                _showToast(e.toString(), Colors.black);
                              }
                            } else {
                              _showToast("you have to fill all fields !!",
                                  Colors.black);
                            }
                          },
                          child: Text("Sign up")),
                    ],
                  )
                ],
              ))
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
