import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:hemocare/utils/my-dropdown.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Loading(
        indicator: BallSpinFadeLoaderIndicator(),
        color: ColorTheme.lightPurple,
      ),
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: MyAppBarTheme(title: "Faça seu cadastro"),
            body: Padding(
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
                      onFieldSubmitted: (value) =>
                          _passwordFocus.requestFocus(),
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
                    MyDropDown(
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
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
                            ])),
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
                          _agreeToTerms, context, _switchVisibility);
                      _switchVisibility();
                    }, context)
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _switchVisibility() {
    setState(() {
      _isLoading = !_isLoading;
    });
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
    BuildContext context,
    Function _switchVisibility) {
  if (_name == null ||
      _email == null ||
      _password == null ||
      _pathology == null ||
      _agreeToTerms == null) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        tittle: "Aviso!",
        desc: 'Todos os campos sao obrigatorios',
        btnOkOnPress: () {
          _switchVisibility();
        }).show();
    return;
  }
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();

    if (_agreeToTerms == false) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          tittle: "AVISO!",
          desc: 'Para criar sua conta, concorde com os termos de uso',
          btnOkOnPress: () {
            _switchVisibility();
          }).show();
      return;
    } else {
      register(_email, _name, _password, _pathology, _agreeToTerms, context,
          _switchVisibility);
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
    bool agreeToTerms, BuildContext context, Function _switchVisibility) async {
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
      'userId': loggedUser,
    }).catchError((error) => _switchVisibility);
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
        btnOkOnPress: () {
          _switchVisibility();
        }).show();
  }

  // setLocalStorage o ID e push route
}
