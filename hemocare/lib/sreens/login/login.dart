import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hemocare/sreens/ColorTheme.dart';
import 'package:hemocare/sreens/login/forgot-password.dart';
import 'package:hemocare/sreens/login/register.dart';
import 'package:hemocare/sreens/layout-utils/app-bar.dart';
import 'package:hemocare/utils/utils.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _txtSenha;
  String _txtUsername;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarTheme(title: "Login"),
      body: Form(
        key: this._formKey,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    cursorColor: ColorTheme.blue,
                    autovalidate: false,
                    onSaved: (value) => this._txtUsername = value,
                    textAlign: TextAlign.center,
                    onFieldSubmitted: (value) {
                      //Fazer trocar o foco do campo para o abaixo.
                    },
                    decoration: InputDecoration(
                        hintText: "Seu nome de usuário ou e-mail",
                        icon: Icon(
                          Icons.email,
                          color: ColorTheme.blue,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: ColorTheme.blue),
                        )),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Preencha o campo de e-mail para prosseguir";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "E-mail inválido, tente novamente.";
                      }

                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                      cursorColor: ColorTheme.blue,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onFieldSubmitted: (value) {
                        _entrar(context);
                      },
                      onSaved: (value) => this._txtSenha = value,
                      validator: (value) =>
                          value.isEmpty ? "Insira uma senha" : null,
                      decoration: InputDecoration(
                          hintText: "Sua senha",
                          icon: Icon(
                            Icons.lock,
                            color: ColorTheme.blue,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: ColorTheme.blue,
                            ),
                          )))),
              SizedBox(
                height: 40,
              ),
              Utils.gradientPatternButton('Entrar', () {
                _entrar(context);
              }, context),
              SizedBox(
                height: 20,
              ),
              createButtonForgotPassword()
            ],
          ),
        ),
      ),
    );
  }

  void _entrar(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //TO-DO Remover apontamento para o registro
      Navigator.of(context).push(CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => Register()));
    }
  }

  Widget createButtonForgotPassword() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => ForgotPassword()));
      },
      color: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        padding: const EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 12.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: ColorTheme.lightPurple)),
        child: Text(
          'Esqueci a senha',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: ColorTheme.lightPurple),
        ),
      ),
    );
  }
}
