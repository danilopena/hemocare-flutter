import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/graph.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
    );
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
