import 'package:egy_park/screens/booked.dart';
import 'package:egy_park/screens/login.dart';
import 'package:egy_park/screens/map_screen.dart';
import 'package:egy_park/screens/park_details.dart';
import 'package:egy_park/screens/signup.dart';
import 'package:egy_park/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    print('Initialized default app $app');
  }

  @override
  Widget build(BuildContext context) {
    initializeDefault();
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Egy Park',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/maps': (context) => MapScreen(),
        '/details': (context) => ParkScreen(),
      },
    );
  }
}
