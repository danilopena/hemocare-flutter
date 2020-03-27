import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hemocare/utils/AuthErrors.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/app-bar.dart';
import 'package:hemocare/utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String email;
    TextEditingController _emailController;
    return Scaffold(
      appBar: MyAppBarTheme(title: "Esqueci a senha"),
      body: Center(
        child: Form(
          key: this._formKey,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Basta digitar o e-mail cadastrado e em minutos receberá as próximas instruções.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorTheme.darkGray,
                        fontSize: 17.0),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      cursorColor: ColorTheme.blue,
                      autovalidate: false,
                      onChanged: (value) => email = value,
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      onSaved: (value) => email = value,
                      onFieldSubmitted: (value) {
                        email = value;
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
                SizedBox(
                  height: 40,
                ),
                Utils.gradientPatternButton('Redefinir senha', () {
                  _sendForgot(email, context);
                }, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendForgot(String email, BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    _recoveryPassword(email, context);
  }
}

Future<void> _recoveryPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((sent) => {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      tittle: "Enviado!",
                      desc:
                          'Email de recuperação enviado. Cheque sua caixa de entrada.',
                      btnOkOnPress: () {})
                  .show()
            });
  } on PlatformException catch (e) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            tittle: "AVISO!",
            desc: '${AuthErrors.show(e.code)}',
            btnOkOnPress: () {})
        .show();
  }
}
