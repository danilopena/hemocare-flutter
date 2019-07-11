import 'package:flutter/material.dart';
import 'package:hemocare/sreens/layout-utils/app-bar.dart';

class UseTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarTheme(title: "Termos de uso"),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
