import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookedScreen extends StatefulWidget {
  String data;
  BookedScreen(this.data);
  @override
  State<StatefulWidget> createState() {
    return _BookedScreenState();
  }
}

class _BookedScreenState extends State<BookedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Successfully"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImage(
              data: widget.data,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "You have booked the slot Successfully !!",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
