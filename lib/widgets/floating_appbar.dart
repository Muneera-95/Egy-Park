import 'package:flutter/material.dart';

class FloatingAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "./assets/images/small_logo.png",
              height: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "Egy Park",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: Container()),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
              ),
            ),
          ],
        ),
      ),
    );
  }

}