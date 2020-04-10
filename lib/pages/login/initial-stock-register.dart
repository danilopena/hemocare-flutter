import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/AuthErrors.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';

class InitialStockRegister extends StatefulWidget {
  @override
  _InitialStockRegisterState createState() => _InitialStockRegisterState();
}

class _InitialStockRegisterState extends State<InitialStockRegister> {
  double percent = 0.5;
  String initialStock;
  var _initialStockFocus = FocusNode();
  var _commonDosageFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _commonDosage;
  var _initialStockController = TextEditingController();
  var _commonDosageController = TextEditingController();
  bool _selfValidate = false;
  bool _isLoading;
  var result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hasStock().then((value) => result = value);
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.white,
      progressIndicator: Loading(
        color: ColorTheme.lightPurple,
        indicator: BallSpinFadeLoaderIndicator(),
      ),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Informações iniciais",
              style: GoogleFonts.raleway(fontSize: 24),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    focusNode: _initialStockFocus,
                    controller: _initialStockController,
                    decoration: InputDecoration(
                        labelText: "Qual seu estoque atual?",
                        hintText: "Ex: 2000",
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => initialStock = value,
                    onFieldSubmitted: (value) {
                      _commonDosageFocus.requestFocus();
                    },
                    validator: stockValidator,
                    autovalidate: _selfValidate,
                    onSaved: (value) => initialStock = value,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    focusNode: _commonDosageFocus,
                    controller: _commonDosageController,
                    decoration: InputDecoration(
                        labelText: "Qual a sua dosagem padrão?",
                        hintText: "Ex: 3000",
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    keyboardType: TextInputType.number,
                    validator: dosageValidator,
                    autovalidate: _selfValidate,
                    onChanged: (value) => _commonDosage = value,
                    onSaved: (value) => _commonDosage = value,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Utils.gradientPatternButton("Pronto", () {
                    _submit(_formKey, initialStock, _commonDosage, context,
                        _switchVisibility);
                  }, context)
                ],
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

String stockValidator(String value) {
  double stockValue;
  try {
    stockValue = double.parse(value);
  } on Exception catch (e) {
    print(e);
    return "Por gentileza, insira um valor";
  }
  if (stockValue < 0) {
    return "Estoque inicial não pode ser negativo";
  } else if (stockValue == null) {
    return "Não é possível submeter o campo vazio";
  }
  return null;
}

String dosageValidator(String value) {
  double dosageValue;
  try {
    dosageValue = double.parse(value);
  } on Exception catch (e) {
    print(e);
    return "Por gentileza, insira um valor";
  }
  if (dosageValue < 0) {
    return "Estoque inicial não pode ser negativo";
  } else if (dosageValue == null) {
    return "Não é possível submeter o campo vazio";
  }
  return null;
}

void _submit(GlobalKey<FormState> _formKey, String _initialStock,
    String _commonDosage, BuildContext context, Function _switchVisibility) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
    _switchVisibility();
    fillStock(_initialStock, _commonDosage, context, _switchVisibility);
  } else {
    if (_initialStock == null || _commonDosage == null) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              tittle: "Erro!",
              desc: 'Informe todos os dados, por gentileza!',
              btnOkOnPress: () {})
          .show();
      return;
    }
  }
}

void fillStock(String initialStock, String commonDosage, BuildContext context,
    Function _switchVisibility) async {
  StockHandler sh = new StockHandler();

  try {
    sh.createStock(initialStock, commonDosage).then((success) {
      _switchVisibility();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TabBarController()));
    });
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
    return;
  }
}

Future _hasStock() async {
  StockHandler sh = new StockHandler();
  DocumentSnapshot response = await sh.getStock();

  return response;
}
