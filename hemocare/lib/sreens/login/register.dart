import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hemocare/sreens/layout-utils/app-bar.dart';
import 'package:hemocare/sreens/ColorTheme.dart';
import 'package:hemocare/sreens/login/login.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:flutter/gestures.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _textFieldController = TextEditingController();
  TapGestureRecognizer _loginTapRecognizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(CupertinoPageRoute(
            fullscreenDialog: true, builder: (context) => Login()));
      };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarTheme(title: "Registro"),
      body: Center(
          child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 10.0),
                  child: TextField(
                      controller: _textFieldController,
                      cursorColor: ColorTheme.blue,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "Seu nome completo",
                          icon: Icon(
                            Icons.person,
                            color: ColorTheme.blue,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: ColorTheme.blue),
                          )))),
              Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 10.0),
                  child: TextField(
                      controller: _textFieldController,
                      cursorColor: ColorTheme.blue,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "Seu telefone",
                          icon: Icon(
                            Icons.smartphone,
                            color: ColorTheme.blue,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: ColorTheme.blue),
                          )))),
              Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 10.0),
                  child: TextField(
                      controller: _textFieldController,
                      cursorColor: ColorTheme.blue,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "Seu email",
                          icon: Icon(
                            Icons.email,
                            color: ColorTheme.blue,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: ColorTheme.blue),
                          )))),
              Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 10.0),
                  child: TextField(
                      controller: _textFieldController,
                      cursorColor: ColorTheme.blue,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Sua senha",
                          icon: Icon(
                            Icons.lock,
                            color: ColorTheme.blue,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: ColorTheme.blue),
                          )))),
              SizedBox(
                height: 30,
              ),
              Utils.gradientPatternButton('Cadastrar', () {}, context),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                      child: RichText(
                    text: TextSpan(
                      text: 'Já possui cadastro? ',
                      style: TextStyle(color: ColorTheme.lightPurple),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Entre agora',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorTheme.lightPurple),
                          recognizer: _loginTapRecognizer,
                        ),
                      ],
                    ),
                  ))),
              SizedBox(
                height: 30,
              )
            ],
          )
        ],
      )),
    );
  }
}
