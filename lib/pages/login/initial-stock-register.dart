import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
          automaticallyImplyLeading: false,
          title: Text(
            "Informações iniciais",
            style: GoogleFonts.raleway(fontSize: 24),
          ),
        ),
        // TODO remover o futurebuilder. Não permite push de tela.

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
                  onSaved: (value) => _commonDosage = value,
                ),
                SizedBox(
                  height: 30,
                ),
                Utils.gradientPatternButton("Pronto", () {
                  _submit(_formKey, initialStock, _commonDosage, context);
                }, context)
              ],
            ),
          ),
        ));
  }
}

String stockValidator(String value) {
  double stockValue;
  try {
    stockValue = double.parse(value);
  } on Exception catch (e) {
    return "Por gentileza, insira um valor";
  }
  if (stockValue < 0) {
    return "Estoque inicial não pode ser negativo";
  } else if (stockValue == null) {
    return "Não é possível submeter o campo vazio";
  }
}

String dosageValidator(String value) {
  double dosageValue;
  try {
    dosageValue = double.parse(value);
  } on Exception catch (e) {
    return "Por gentileza, insira um valor";
  }
  if (dosageValue < 0) {
    return "Estoque inicial não pode ser negativo";
  } else if (dosageValue == null) {
    return "Não é possível submeter o campo vazio";
  }
}

void _submit(GlobalKey<FormState> _formKey, String _initialStock,
    String _commonDosage, BuildContext context) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
  }
  fillStock(_initialStock, _commonDosage, context);
}

void fillStock(
    String initialStock, String commonDosage, BuildContext context) async {
  StockHandler sh = new StockHandler();
  LocalStorageWrapper ls = LocalStorageWrapper();
  String userKey = ls.retrieve("logged_id");
  final databaseReference = Firestore.instance;
  await databaseReference.collection("users").document(userKey).updateData({
    "initialStock": int.parse(initialStock),
    "dosage": int.parse(commonDosage),
    "percentageUsed": 0
  }).then((success) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => TabBarController())));
}

Future _hasStock() async {
  StockHandler sh = new StockHandler();
  DocumentSnapshot response = await sh.getStock();

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
