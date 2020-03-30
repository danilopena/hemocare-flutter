import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';
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
  String uid;
  bool _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    uid = new LocalStorageWrapper().retrieve("logged_id");
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.white,
      progressIndicator: Loading(
        indicator: BallSpinFadeLoaderIndicator(),
        color: ColorTheme.lightPurple,
      ),
      child: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: SafeArea(
            child: ListView(
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
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection("users")
                                      .where("userId", isEqualTo: uid)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return Text("No connection found");
                                      case ConnectionState.active:
                                        final DocumentSnapshot document =
                                            snapshot.data.documents[0];
                                        var percent = document
                                                    .data["percentageUsed"] !=
                                                null
                                            ? document.data["percentageUsed"]
                                            : 0.0;

                                        return Column(
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                "Você já usou ${document.data["percentageUsed"]}% do seu estoque",
                                                style: GoogleFonts.raleway(
                                                    fontSize: 20),
                                              ),
                                            ),
                                            CircularPercentIndicator(
                                              radius: 270.0,
                                              animation: true,
                                              animationDuration: 2000,
                                              lineWidth: 40.0,
                                              percent: percent / 100,
                                              arcBackgroundColor:
                                                  ColorTheme.lightPurple,
                                              arcType: ArcType.FULL,
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              animateFromLastPercent: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              progressColor: ColorTheme.blue,

                                              footer: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "Seu estoque atual:",
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 24,
                                                        ),
                                                      ),
                                                      Text(
                                                        " ${double.parse(document.data["initialStock"].toString()).truncate()} UI",
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontSize: 28,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
//blur
                                            ),
                                          ],
                                        );
                                      default:
                                        return Center(
                                            child: Text(
                                                "Tivemos problemas ao buscar seus dados. Tentando novamente..."));
                                    }
                                  },
                                )
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Gatilhos para te ajudar",
                              style: GoogleFonts.raleway(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Utils.gradientPatternButton("Manter Estoque", () {
                              //abrir novo alert
                              _showDialog(context, _quantityController,
                                      _quantity, _switchVisibility)
                                  .show();
                            }, context),
                            SizedBox(
                              height: 10,
                            ),
                            Utils.gradientPatternButton(
                                "Profilaxia", () {}, context),
                            SizedBox(
                              height: 10,
                            ),
                            Utils.gradientPatternButton(
                                "Entrega/Busca de Fator", () {}, context),
                            SizedBox(
                              height: 10,
                            ),
                            Utils.gradientPatternButton(
                                "Retirada Automática", () {}, context),
                          ],
                        )
                      ]),
                ),
              ],
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

String validateQuantity(String value) {
  if (double.parse(value) < 0) {
    return "Por favor, informe valores maior que 0";
  }
}

Alert _showDialog(BuildContext context, TextEditingController controller,
    String quantity, Function _switchVisibility) {
  bool add;
  controller.clear();
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: ColorTheme.darkGray,
          )),
      titleStyle: TextStyle(color: ColorTheme.lightPurple));
  return Alert(
      title: "Nova infusão",
      context: context,
      style: alertStyle,
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
              onSubmitted: (value) => quantity = value,
              keyboardType: TextInputType.number,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    add = true;
                    addStock(double.parse(quantity), context).then((success) {
                      DocumentSnapshot ds = success;
                      if (ds.data.length != null) {
                        Navigator.of(context).pop();
                      }
                    });
                    controller.clear();
                  },
                  child: Text(
                    "+",
                    style:
                        GoogleFonts.raleway(fontSize: 48, color: Colors.black),
                  )),
              InkWell(
                  onTap: () {
                    removeStock(double.parse(quantity), context)
                        .then((success) {
                      DocumentSnapshot ds = success;
                      if (ds.data.length != null) {
                        Navigator.of(context).pop();
                      }
                    });
                    controller.clear();
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
            "CANCELAR",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          gradient:
              LinearGradient(colors: [ColorTheme.lightPurple, ColorTheme.blue]),
        )
      ]);
}

Future addStock(double quantityInt, BuildContext context) async {
  StockHandler sh = new StockHandler();
  DocumentSnapshot response;
  if (quantityInt == null || quantityInt <= 0) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            tittle: "Erro!",
            desc: 'Informe um valor positivo e maior que zero para a dosagem',
            btnOkOnPress: () {})
        .show();
    return;
  }
  try {
    response = await sh.addStock(quantityInt);
  } on PlatformException catch (e) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            tittle: "Erro!",
            desc: 'Erro em ${e.code}',
            btnOkOnPress: () {})
        .show();
    return;
  }

  return response;
}

Future removeStock(double quantityInt, BuildContext context) async {
  StockHandler sh = new StockHandler();
  DocumentSnapshot response;
  if (quantityInt == null || quantityInt <= 0) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            tittle: "Erro!",
            desc: 'Informe um valor positivo e maior que zero para a dosagem',
            btnOkOnPress: () {})
        .show();
    return;
  }
  try {
    response = await sh.removeStock(quantityInt);
  } on PlatformException catch (e) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            tittle: "Erro!",
            desc: 'Erro em ${e.code}',
            btnOkOnPress: () {})
        .show();
    return;
  }

  return response;
}
