import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/login/initial-stock-register.dart';
import 'package:hemocare/pages/login/login.dart';
import 'package:hemocare/pages/login/use-terms.dart';
import 'package:hemocare/services/authentication.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/utils/AuthErrors.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/app-bar.dart';
import 'package:hemocare/utils/utils.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _textFieldController = TextEditingController();
  TapGestureRecognizer _loginTapRecognizer;
  final _formKey = GlobalKey<FormState>();
  var _emailFocus = FocusNode();
  var _passwordFocus = FocusNode();
  var _nameFocus = FocusNode();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _nameController = TextEditingController();
  String _name;
  String _email;
  String _password;
  String _pathology;
  bool _selfValidate = false;
  bool _agreeToTerms = false;

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
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBarTheme(title: "Faça seu cadastro"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    focusNode: _nameFocus,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nome",
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: nameValidator,
                    autovalidate: _selfValidate,
                    onSaved: (value) => _name = value,
                    onChanged: (value) => _name = value,
                    onFieldSubmitted: (value) => _emailFocus.requestFocus(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onTap: () => _emailFocus.requestFocus(),
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
                    onChanged: (value) => _email = value,
                    onFieldSubmitted: (value) => _passwordFocus.requestFocus(),
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
                    onChanged: (value) => _password = value,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      color: Colors.white,
                      child: DropDownFormField(
                        titleText: 'Coagulopatia',
                        hintText: "Selecione sua coagulopatia",
                        value: _pathology,
                        onSaved: (value) {
                          setState(() {
                            _pathology = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _pathology = value;
                          });
                        },
                        dataSource: [
                          {
                            "display": "Hemofilia A",
                            "value": "Hemofilia A",
                          },
                          {
                            "display": "Hemofilia B",
                            "value": "Hemofilia B",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Concordar com os termos de uso?",
                        style: GoogleFonts.raleway(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Switch.adaptive(
                        value: _agreeToTerms,
                        onChanged: (newValue) =>
                            setState(() => _agreeToTerms = newValue),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Text(
                        'Termos de uso',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorTheme.lightPurple),
                      ),
                      onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => UseTerms())),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Utils.gradientPatternButton("Pronto", () {
                    _submit(_formKey, _name, _email, _password, _pathology,
                        _agreeToTerms, context);
                  }, context)
                ],
              ),
            ),
          ),
        ));
  }
}

String nameValidator(String value) {
  return value.length < 2 ? "Nome muito curto." : null;
}

void _submit(
    GlobalKey<FormState> _formKey,
    String _name,
    String _email,
    String _password,
    String _pathology,
    bool _agreeToTerms,
    BuildContext context) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();

    if (_agreeToTerms == false) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: "AVISO!",
              desc: 'Para criar sua conta, concorde com os termos de uso',
              btnOkOnPress: () {})
          .show();
      return;
    } else {
      register(_email, _name, _password, _pathology, _agreeToTerms, context);
    }
  }
}

String validatePassword(String value) {
  if (value.length < 5)
    return 'Por favor insira uma senha mais forte';
  else if (value.length == 0)
    return "Insira uma senha";
  else
    return null;
}

void register(String email, String name, String password, String pathology,
    bool agreeToTerms, BuildContext context) async {
  LocalStorageWrapper ls = LocalStorageWrapper();
  // register com o firebase
  Auth auth = new Auth();
  final databaseReference = Firestore.instance;
  String loggedUser = "";
  try {
    loggedUser = await auth.signUp(email, password);
    // gravar info do usuario no DB  {firebase.uid && pathology}
    await databaseReference.collection("users").document(loggedUser).setData({
      'email': email,
      'name': name,
      'pathology': pathology,
      'userId': loggedUser
    });
    ls.save("logged_id", loggedUser);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => InitialStockRegister()));
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

  // setLocalStorage o ID e push route
}
