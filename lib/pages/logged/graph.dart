import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/login/initial-stock-register.dart';
import 'package:hemocare/stores/stock_store.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/calendar.dart';
import 'package:hemocare/utils/dialog.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> with WidgetsBindingObserver {
  bool _isLoading = false;
  StockStore store;
  TextEditingController _quantityController = new TextEditingController();
  int _quantity = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    store = StockStore();
    store.setUid();
    store.setStockData();

//    if (store?.stockData?.data["name"] == "testebug") {
//      print(store?.stockData?.data["name"]);
//      Navigator.of(context).push(
//          MaterialPageRoute(builder: (context) => InitialStockRegister()));
//    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    autorun((_) {
      store.setUid();
      store.setStockData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Seu Estoque",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.raleway(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Observer(
                                  builder: (_) {
                                    return Text(
                                      "${store.isOkToRender}",
                                      style:
                                          GoogleFonts.montserrat(fontSize: 32),
                                    );
                                  },
                                ),
                                Observer(
                                  builder: (_) {
                                    return store?.isOkToRender
                                        ? Column(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  "Você já usou ${store?.stockData?.data["percentageUsed"]?.truncate()}% do seu estoque",
                                                  textScaleFactor: 1,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 20),
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 270.0,
                                                animation: true,
                                                animationDuration: 2000,
                                                lineWidth: 40.0,
                                                percent: store?.stockData?.data[
                                                        "percentageUsed"] /
                                                    100,
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
                                                    FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Seu estoque atual:",
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                fontSize: 24,
                                                              ),
                                                            ),
                                                            Text(
                                                              " ${double.parse(store?.stockData?.data["initialStock"].toString()).truncate()} UI",
                                                              style: GoogleFonts.raleway(
                                                                  fontSize: 28,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
//blur
                                              ),
                                            ],
                                          )
                                        : AlertDialog(
                                            title: Text("Erro"),
                                            content: Text(
                                                "Dados de estoque invalidos"),
                                            actions: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InitialStockRegister()));
                                                },
                                                icon: Icon(Icons.home),
                                              )
                                            ],
                                          );
                                  },
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Gatilhos para te ajudar",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.raleway(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Utils.gradientPatternButton("Manter Estoque", () {
                              //abrir novo alert
                              CustomDialog.showDialog(
                                      context,
                                      _quantityController,
                                      _quantity.toString(),
                                      _switchVisibility)
                                  .show();
                            }, context),
                            SizedBox(
                              height: 10,
                            ),
                            Utils.gradientPatternButton("Profilaxia", () {
                              CustomCalendar.showCalendar(context).show();
                            }, context),
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
  return null;
}
