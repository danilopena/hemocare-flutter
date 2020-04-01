import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/pages/login/forgot-password.dart';
import 'package:hemocare/services/authentication.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/utils/AuthErrors.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/app-bar.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _emailFocus = FocusNode();
  var _passwordFocus = FocusNode();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  String _email;
  String _password;
  bool _selfValidate = false;
  bool _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.white,
      progressIndicator: Loading(
        indicator: BallSpinFadeLoaderIndicator(),
        color: ColorTheme.lightPurple,
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MyAppBarTheme(title: "Faça seu login"),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autofocus: true,
                      focusNode: _emailFocus,
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateMail,
                      autovalidate: _selfValidate,
                      onChanged: (value) => _email = value,
                      onFieldSubmitted: (value) {
                        _email = value;
                        _passwordFocus.requestFocus();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _passwordFocus,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "Senha",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: validatePassword,
                      autovalidate: _selfValidate,
                      onChanged: (value) => _password = value,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorTheme.lightPurple),
                        ),
                        onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => ForgotPassword())),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Utils.gradientPatternButton("Pronto", () {
                      _submit(_formKey, _email, _password, context,
                          _switchVisibility);
                      _switchVisibility();
                    }, context)
                  ],
                ),
              ),
            ),
          )),
    );
  }

  _switchVisibility() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}

String nameValidator(String value) {
  return value.length < 2 ? "Nome muito curto. Inválido" : null;
}

void _submit(GlobalKey<FormState> _formKey, String _email, String _password,
    BuildContext context, Function _switchVisibility) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
    if (_email == null || _password == null) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              tittle: "Erro!",
              desc: 'Informe todos os dados, por gentileza!',
              btnOkOnPress: () {})
          .show();
      return;
    } else {
      login(_email, _password, context, _switchVisibility);
    }
  }
}

String validatePassword(String value) {
  if (value.length == 0) return "Senha não pode ser vazia";
  if (value.length < 5)
    return 'Por favor insira uma senha mais forte';
  else
    return null;
}

void login(String email, String password, BuildContext context,
    Function _switchVisibility) async {
  LocalStorageWrapper ls = new LocalStorageWrapper();
  Auth auth = new Auth();
  String loggedUser = "";

  try {
    await auth.signIn(email, password).then((value) {
      loggedUser = value;
      ls.save("logged_id", loggedUser);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TabBarController()));
    });
  } on PlatformException catch (e) {
    print(e.code);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        tittle: "AVISO!",
        desc: '${AuthErrors.show(e.code)}',
        btnOkOnPress: () {
          _switchVisibility();
        }).show();
    return;
  }
}

String validateMail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Por favor insira um email válido';
  else
    return null;
}
