import 'package:flutter/material.dart';

class MyAppBarTheme extends AppBar {
  MyAppBarTheme({Key key, String title})
      : super(
            key: key,
            title: Text(
              title,
              style: TextStyle(color: Color(0xFF767BA0)),
            ),
            iconTheme: IconThemeData(color: Color(0xFF767BA0)),
            backgroundColor: Colors.white);
}
