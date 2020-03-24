import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hemocare/pages/forgot-password.dart';
import 'package:hemocare/pages/graph.dart';
import 'package:hemocare/services/authentication.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/app-bar.dart';
import 'package:hemocare/utils/utils.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Scaffold(
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
                    onSaved: (value) => _email = value,
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
                    onSaved: (value) => _password = value,
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
                    _submit(_formKey, _email, _password, context);
                  }, context)
                ],
              ),
            ),
          ),
        ));
  }
}

String nameValidator(String value) {
  return value.length < 2 ? "Nome muito curto. Inválido" : null;
}

void _submit(GlobalKey<FormState> _formKey, String _email, String _password,
    BuildContext context) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
  }
  login(_email, _password, context);
}

String validatePassword(String value) {
  if (value.length < 5)
    return 'Por favor insira uma senha mais forte';
  else
    return null;
}

void login(String email, String password, BuildContext context) async {
  LocalStorageWrapper ls = new LocalStorageWrapper();
  Auth auth = new Auth();
  String loggedUser = await auth.signIn(email, password);
  if (loggedUser != null) {
    ls.save("logged_id", loggedUser);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Graph()));
  } else {
    print("Erro no login");
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
