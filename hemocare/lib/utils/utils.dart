import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hemocare/sreens/ColorTheme.dart';

class Utils {
  static Widget gradientPatternButton(
      String title, VoidCallback onPressed, BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        padding: const EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 12.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                colors: <Color>[ColorTheme.blue, ColorTheme.lightPurple])),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
