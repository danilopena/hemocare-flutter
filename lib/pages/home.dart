import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/graph.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double percent = 0.5;
  String initialStock;
  var _initialStockFocus = FocusNode();
  var _commonDosageFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _commonDosage;
  var _initialStockController = TextEditingController();
  var _commonDosageController = TextEditingController();
  bool _selfValidate = false;
  var result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hasStock().then((value) => result = value);
  }

  @override
  Widget build(BuildContext context) {
    //todo  resolver stock loading em primeiro lugar - só arruma o valor na segunda vez.
    print("Ress: $result");

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Informações iniciais",
            style: GoogleFonts.raleway(fontSize: 24),
          ),
        ),
        // TODO remover o futurebuilder. Não permite push de tela.

        body: 1 > 0
            ? Text("Cunt bitch")
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        focusNode: _initialStockFocus,
                        controller: _initialStockController,
                        decoration: InputDecoration(
                            labelText: "Qual seu estoque atual?",
                            hintText: "Ex.: 20000 UI",
                            labelStyle: GoogleFonts.raleway(fontSize: 28),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.local_hospital),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        keyboardType: TextInputType.number,
                        validator: stockValidator,
                        autovalidate: _selfValidate,
                        onSaved: (value) => initialStock = value,
                      ),
                      TextFormField(
                        focusNode: _commonDosageFocus,
                        controller: _commonDosageController,
                        decoration: InputDecoration(
                            labelText: "Qual a sua dosagem padrão?",
                            hintText: "Ex.: 3000 UI",
                            labelStyle: GoogleFonts.raleway(fontSize: 28),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.healing),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        keyboardType: TextInputType.number,
                        validator: dosageValidator,
                        autovalidate: _selfValidate,
                        onSaved: (value) => _commonDosage = value,
                      ),
                      Utils.gradientPatternButton("Pronto!", () {
                        _submit(_formKey, initialStock, _commonDosage, context);
                      }, context)
                    ],
                  ),
                ),
              ));
  }
}

String stockValidator(String value) {
  double stockValue = double.parse(value);
  if (stockValue < 0) {
    return "Estoque inicial não pode ser negativo";
  }
}

String dosageValidator(String value) {
  double stockValue = double.parse(value);
  if (stockValue < 100) {
    return "Dosagem padrão não pode ser menor que 100";
  }
}

void _submit(GlobalKey<FormState> _formKey, String _initialStock,
    String _commonDosage, BuildContext context) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();

    fillStock(_initialStock, _commonDosage, context);
  }
}

void fillStock(
    String initialStock, String commonDosage, BuildContext context) async {
  StockHandler sh = new StockHandler();
  Response response = await sh.createStock(initialStock, commonDosage);
  if (response.data != null) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Graph()));
  }
}

Future _hasStock() async {
  StockHandler sh = new StockHandler();
  Response response = await sh.getStock();
  print("Minha fodendo response: $response");

  return response;
}

Widget showDialog(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "RFLUTTER ALERT",
    desc: "Flutter is more awesome with RFlutter Alert.",
    buttons: [
      DialogButton(
        child: Text(
          "COOL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}
