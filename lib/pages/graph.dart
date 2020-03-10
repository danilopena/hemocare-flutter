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
    return Material(
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(children: <Widget>[
                Container(
                    // blue: '#64D7EB',
                    //green: '#55D0B2',
                    height: (MediaQuery.of(context).size.height) / 2,
                    width: (MediaQuery.of(context).size.width) - 40,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Seu Estoque",
                          style: GoogleFonts.raleway(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: stockHandler.getStock(),
                          builder: (context, snapshot) {
                            print(snapshot.data);
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Column(
                                children: <Widget>[
                                  Text(
                                    "Você já usou ${snapshot.data["percentageUsed"]}% do seu estoque",
                                    style: GoogleFonts.raleway(fontSize: 24),
                                  ),
                                  CircularPercentIndicator(
                                    radius: 270.0,
                                    animation: true,
                                    animationDuration: 2000,
                                    lineWidth: 40.0,
                                    percent:
                                        snapshot.data["percentageUsed"] / 100,
                                    arcBackgroundColor: ColorTheme.lightPurple,
                                    arcType: ArcType.FULL,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    animateFromLastPercent: true,
                                    backgroundColor: Colors.transparent,
                                    progressColor: ColorTheme.blue,
                                    footer: Row(
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
                                          " ${snapshot.data["quantity"]}UI",
                                          style: GoogleFonts.raleway(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Utils.gradientPatternButton("Nova infusão", () {
                      //abrir novo alert
                      _showDialog(context, _quantityController, _quantity)
                          .show();
                    }, context),
                    SizedBox(
                      height: 20,
                    ),
                    Utils.gradientPatternButton("Profilaxia", () {}, context),
                    SizedBox(
                      height: 20,
                    ),
                    Utils.gradientPatternButton(
                        "Entrega/Busca de Fator", () {}, context),
                    SizedBox(
                      height: 20,
                    ),
                    Utils.gradientPatternButton(
                        "Retirada Automática", () {}, context),
                  ],
                )
              ]),
            ),
          ),
        ],
      ),
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
  return Alert(
      title: "Nova infusão",
      context: context,
      type: AlertType.info,
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
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Container(
                  height: 56,
                  width: 56,
                  child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            ColorTheme.lightPurple,
                            ColorTheme.blue
                          ])),
                          child: Text("+"))),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 44,
                  width: 44,
                  child: Center(child: Text("-")),
                ),
              )
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
          onPressed: () {},
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
