import 'package:flutter/material.dart';
import 'package:hemocare/utils/ColorTheme.dart';

class MyAppBarTheme extends AppBar {
  MyAppBarTheme({Key key, String title})
      : super(
            key: key,
            elevation: 0.0,
            bottom: PreferredSize(
                child: Container(color: ColorTheme.lightGray, height: 1.0),
                preferredSize: Size.fromHeight(1.0)),
            title: Text(
              title,
              style: TextStyle(color: Color(0xFF767BA0)),
            ),
            iconTheme: IconThemeData(color: Color(0xFF767BA0)),
            backgroundColor: Colors.white);
}
