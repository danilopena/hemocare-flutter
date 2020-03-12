import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  StockHandler stockHandler = new StockHandler();
  String _quantity = "0";
  var _quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,

      body: ListView(
        shrinkWrap: true,

        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    // blue: '#64D7EB',
                    //green: '#55D0B2',
//                      height: (MediaQuery.of(context).size.height) / 2,
//                      width: (MediaQuery.of(context).size.width) - 40,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Seu Estoque",
                            style: GoogleFonts.raleway(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: stockHandler.getStock(),
                            builder: (context, snapshot) {
                              print(snapshot.data);
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {

                                return Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "Você já usou ${snapshot.data["percentageUsed"]}% do seu estoque",
                                        style: GoogleFonts.raleway(fontSize: 20),
                                      ),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 270.0,
                                      animation: true,
                                      animationDuration: 2000,
                                      lineWidth: 40.0,
                                      percent: snapshot.data["percentageUsed"]/100.0,

                                      arcBackgroundColor: ColorTheme.lightPurple,
                                      arcType: ArcType.FULL,
                                      circularStrokeCap: CircularStrokeCap.round,
                                      animateFromLastPercent: true,
                                      backgroundColor: Colors.transparent,
                                      progressColor: ColorTheme.blue,

                                      footer: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Seu estoque atual:",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text(
                                                " ${snapshot.data["quantity"]} UI",
                                                style: GoogleFonts.raleway(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
//blur
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ],
                      )),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Ações",
                        style: GoogleFonts.raleway(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Utils.gradientPatternButton("Nova infusão", () {
                        //abrir novo alert
                        _showDialog(context, _quantityController, _quantity).show();
                      }, context),
                      SizedBox(height: 10,),
                      Utils.gradientPatternButton("Profilaxia", () {}, context),
                      SizedBox(height: 10,),
                      Utils.gradientPatternButton(
                          "Entrega/Busca de Fator", () {}, context),
                      SizedBox(height: 10,),
                      Utils.gradientPatternButton(
                          "Retirada Automática", () {}, context),
                    ],
                  )
                ]),
          ),
        ],
      )
    );
  }
}

String validateQuantity(String value) {
  if (double.parse(value) < 0) {
    return "Por favor, informe valores maior que 0";
  }
}

Alert _showDialog(
    BuildContext context, TextEditingController controller, String quantity) {
  bool add;
  return Alert(
      title: "Nova infusão",
      context: context,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width) / 4,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Quantidade"),
              controller: controller,
              onChanged: (value) => quantity = value,
              keyboardType: TextInputType.number,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    add = true;
                  },
                  child: Text(
                    "+",
                    style:
                        GoogleFonts.raleway(fontSize: 48, color: Colors.black),
                  )),
              InkWell(
                  onTap: () {
                    add = false;
                  },
                  child: Text(
                    "-",
                    style:
                        GoogleFonts.raleway(fontSize: 48, color: Colors.black),
                  )),
            ],
          )
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Salvar",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          onPressed: () {
            String operation = add ? "Adicionar" : "Remover";
            print("Operação É: $operation");
            double quantityDouble = double.parse(quantity);
            add ? addStock(quantityDouble) : removeStock(quantityDouble);
            Navigator.of(context).pop();
          },
          gradient:
              LinearGradient(colors: [ColorTheme.lightPurple, ColorTheme.blue]),
        ),
        DialogButton(
          child: Text(
            "Cancelar",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          gradient:
              LinearGradient(colors: [ColorTheme.lightPurple, ColorTheme.blue]),
        )
      ]);
}

void addStock(double quantityInt) async {
  StockHandler sh = new StockHandler();
  Response response = await sh.addStock(quantityInt);
  print("Response add: $response");
}

void removeStock(double quantityInt) async {
  StockHandler sh = new StockHandler();
  Response response = await sh.removeStock(quantityInt);
  print("Response remove: $response");
}
