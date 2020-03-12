import 'package:dio/dio.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/initial-stock-register.dart';
import 'package:hemocare/pages/login/login.dart';
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
        appBar: MyAppBarTheme(title: "Registro"),
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
                    height: 20,
                  ),
                  Container(
                      color: Colors.white,
                      child: DropDownFormField(
                        titleText: 'Coagulopatia',
                        hintText: "Escolha a sua coagulopatia",
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
                  Utils.gradientPatternButton("Cadastrar", () {
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
  try {
    Response response = await Dio().post(
        "https://hemocare-backend.herokuapp.com/api/user/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "pathology": pathology,
          "agreeToTerms": agreeToTerms
        });
    /**
     * user: willian@dev.com
     * pass: 123456
     * response: {jwt_Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZTY0ZmRlZDI1YWU4NTAwMjQ3MWU4NmUiLCJpYXQiOjE1ODM2NzY5MDksImV4cCI6MTU4NDAzNjkwOX0.NAbdXVEkj1hg-AGOKeYwMz9fle8lFZgJ-Ki24JEU8U0, id: 5e64fded25ae85002471e86e}
     * Retorno response OK: {"jwt_Token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZGQ1YTRiMDIxNTE2NjA2YTZkZTAwMzIiLCJpYXQiOjE1ODE1NDY1NDYsImV4cCI6MTU4MTkwNjU0Nn0.PAng-tkoOI_mZ-mYpfdhEr_wMhPu6z4VeVIQ_7czrBU","id":"5dd5a4b021516606a6de0032"}
     * Forma de handle os retornos: response.data["nomePropriedade"]
     */
    print(response.data);
    if (response != null) {
      // setLocalStorage o ID e push route
      ls.save("logged_id", response.data["id"]);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InitialStockRegister()));
    }
  } catch (e) {
    print(e);
  }
}
