import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egy_park/screens/booked.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class BottomBookingSheet extends StatefulWidget {
  final String slotId;

  BottomBookingSheet({this.slotId});

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetState();
  }
}

class _BottomSheetState extends State<BottomBookingSheet> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  TimeRange _result;
  String email;
  final databaseReference = FirebaseDatabase.instance.reference();
  List<String> payMethods = ["Bank Card", "Vodafone Cash", "Smart Wallet"];
  String _dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    // CollectionReference slots = FirebaseFirestore.instance.collection('slots');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (auth.currentUser != null) {
      print(auth.currentUser.email);
      email = auth.currentUser.email;
    } else {
      Navigator.popAndPushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          AppBar(
            title: Text(
              "Booking Slot ${widget.slotId} ",
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    TimeRange result = await showTimeRangePicker(
                      context: context,
                      interval: Duration(hours: 1),
                      labels: [
                        "12 pm",
                        "3 am",
                        "6 am",
                        "9 am",
                        "12 am",
                        "3 pm",
                        "6 pm",
                        "9 pm"
                      ].asMap().entries.map((e) {
                        return ClockLabel.fromIndex(
                            idx: e.key, length: 8, text: e.value);
                      }).toList(),
                    );
                    setState(() {
                      _result = result;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _result != null
                          ? "Duration (from: " +
                              _result.startTime.hour.toString() +
                              ":" +
                              _result.startTime.minute.toString() +
                              " - to: " +
                              _result.endTime.hour.toString() +
                              ":" +
                              _result.endTime.minute.toString() +
                              ")"
                          : "Duration",
                      style: TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey.shade300,
                  ),
                ),
                _result != null
                    ? Text(
                        "Cost: ${calcCost(_result.startTime.hour, _result.endTime.hour)}")
                    : Container(),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: DropdownButton(
                    value: _dropdownValue,
                    icon: Icon(Icons.payment),
                    isExpanded: true,
                    items: payMethods
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String data) {
                      setState(() {
                        _dropdownValue = data;
                      });
                    },
                    hint: Text("Payment Method"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _bookSlot(_result.startTime.hour.toString(),
                          _result.endTime.hour.toString());
                    },
                    child: Text("Book")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bookSlot(from, to) {
    databaseReference.child('slots').child(widget.slotId).update({
      'booked by': email,
      'from': from,
      "to": to,
      "date": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    });
    showNotification();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookedScreen("$email,${widget.slotId}")));
  }

  double calcCost(from, to) {
    double hourCost;
    if (widget.slotId == "A" || widget.slotId == "B")
      hourCost = 25;
    else
      hourCost = 50;

    return ((to - from) * hourCost).abs();
  }

  showNotification() async {
    var time = new DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, _result.endTime.hour - 1, 45); //at 3.30
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'EgyPark channel id', 'EgyPark channel name', 'EgyPark description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'EgyPark',
        'Your booked parking-slot about to end in 15 minutes',
        time,
        platformChannelSpecifics);
    log("scheduled notification at ${time.hour}/${time.minute}");
  }
}
