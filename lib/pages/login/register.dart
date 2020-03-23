import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/initial-stock-register.dart';
import 'package:hemocare/pages/login/login.dart';
import 'package:hemocare/pages/login/use-terms.dart';
import 'package:hemocare/services/authentication.dart';
import 'package:hemocare/services/local_storage.dart';
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
                  ),
                  SizedBox(
                    height: 10,
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
  return value.length < 2 ? "Nome muito curto. Inválido" : null;
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

    register(_email, _name, _password, _pathology, _agreeToTerms, context);
  }
}

String validatePassword(String value) {
  if (value.length < 5)
    return 'Por favor insira uma senha mais forte';
  else
    return null;
}

void register(String email, String name, String password, String pathology,
    bool agreeToTerms, BuildContext context) async {
  LocalStorageWrapper ls = LocalStorageWrapper();
  // register com o firebase
  Auth auth = new Auth();
  final databaseReference = Firestore.instance;
  try {
    String loggedUser = await auth.signUp(email, password);
    // gravar info do usuario no DB  {firebase.uid && pathology}
    await databaseReference
        .collection("users")
        .document(loggedUser)
        .setData({'email': email, 'name': name, 'pathology': pathology});
    ls.save("logged_id", loggedUser);
    print(loggedUser);
  } catch (e) {
    print(e);
  }

  // setLocalStorage o ID e push route
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => InitialStockRegister()));
}
