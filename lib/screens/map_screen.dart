import 'dart:async';

import 'package:egy_park/screens/booked.dart';
import 'package:egy_park/widgets/floating_appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  double _lat = 30.026258;
  double _lng = 31.492128;
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _currentPosition;

  String bookedSlotData;

  Map<dynamic, dynamic> data;

  messagingConfig() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void haveBookedSlot() {
    DateTime now = DateTime.now();
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        Map<dynamic, dynamic> slots = snapshot.value["slots"];
        slots.forEach((key, value) {
          if (value['booked by'].toString().contains("hani")) {
            // log("\n\n ${value['date'].toString()} \n  ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString()} \n\n\n");
            if (value['date'].toString() ==
                DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)
                    .toString()) {
              // log("heeerrrrrreeeeee");
              if (now.hour >= int.parse(value['from'].toString()) ||
                  now.hour <= int.parse(value['to'].toString())) {
                print(
                    "$key ///  ${value['booked by']}=> ${value['from']} : ${value['to']}");

                bookedSlotData = " ${value['booked by']},$key";
              }
            }
          }
        });
        // log(slots.toString());
      });
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  initLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await FirebaseMessaging.instance.subscribeToTopic('egypark');
  }

  @override
  initState() {
    initLocalNotification();

    super.initState();
    messagingConfig();
    _locateMe();
    haveBookedSlot();
    _currentPosition = CameraPosition(
      target: LatLng(_lat, _lng),
      zoom: 12,
    );
  }

  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // await location.getLocation().then((res) async {
    //   final GoogleMapController controller = await _controller.future;
    //   final _position = CameraPosition(
    //     target: LatLng(res.latitude, res.longitude),
    //     zoom: 12,
    //   );
    //   controller.animateCamera(CameraUpdate.newCameraPosition(_position));
    //   setState(() {
    //     _lat = res.latitude;
    //     _lng = res.longitude;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _currentPosition,
              markers: {
                Marker(
                  markerId: MarkerId('marker1'),
                  position: LatLng(30.026258, 31.492128),
                  onTap: () {
                    Navigator.of(context).pushNamed("/details");
                  },
                ),
                // Marker(
                //   markerId: MarkerId('marker2'),
                //   position: LatLng(_lat - 0.0225, _lng - 0.0305),
                //   onTap: () {
                //     Navigator.of(context).pushNamed("/details");
                //   },
                // )
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: FloatingAppBar(),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(Icons.my_location),
            onPressed: () => _locateMe(),
          ),
          SizedBox(
            height: 10,
          ),
          bookedSlotData == null
              ? Container(
                  width: 15,
                )
              : FloatingActionButton(
                  child: Icon(Icons.qr_code),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BookedScreen(bookedSlotData)))
                        .then((value) => haveBookedSlot());
                  },
                ),
        ],
      ),
    );
  }
}
