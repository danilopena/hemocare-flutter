import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/login/initial-stock-register.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/calendar.dart';
import 'package:hemocare/utils/dialog.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> with WidgetsBindingObserver {
  StockHandler stockHandler = new StockHandler();
  String _quantity = "0";
  var _quantityController = TextEditingController();
  String uid;
  bool _isLoading;
  bool _withoutStock;
  Stream stream;
  Future future;

  final LocalStorage localStorage = new LocalStorage('hemocare');

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _withoutStock = false;
    future = FirebaseAuth.instance.currentUser();
  }

  void listenWithoutStock() {
    if (_withoutStock) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InitialStockRegister()));
    }
  }

  void getUserId() async {
    _isLoading = false;

    await localStorage.ready;

    uid = localStorage.getItem("logged_id");

    stream =
        Firestore.instance.collection("users").document(uid).get().asStream();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      stream = Firestore.instance
          .collection("users")
          .where("userId", isEqualTo: uid)
          .snapshots();
    }
    if (state == AppLifecycleState.detached) {
      stream = Firestore.instance
          .collection("users")
          .where("userId", isEqualTo: uid)
          .snapshots();
    }
  }

  Widget doneConnectionFuture(AsyncSnapshot<FirebaseUser> futureSnapshot) {
    if (futureSnapshot.data != null) {
      stream = Firestore.instance
          .collection("users")
          .document(futureSnapshot.data.uid)
          .get()
          .asStream();
      return StreamBuilder(
        stream: stream,
        initialData: [],
        builder: (context, AsyncSnapshot documentSnapshot) {
          switch (documentSnapshot.connectionState) {
            case ConnectionState.none:
              return Text("Sem conexão de rede ativa");
              break;
            case ConnectionState.waiting:
              return CircularProgressIndicator();
              break;
            case ConnectionState.active:
              return Text("Conexão ativa");
              break;
            case ConnectionState.done:
              if (documentSnapshot.data != null) {
                if (documentSnapshot.data.data["percentageUsed"] == null) {
                  myCallback(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InitialStockRegister()));
                  });
                } else {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Você já usou ${documentSnapshot.data["percentageUsed"].truncate()}% do seu estoque",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(fontSize: 20),
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 270.0,
                        animation: true,
                        animationDuration: 2000,
                        lineWidth: 40.0,
                        percent: documentSnapshot.data["percentageUsed"] / 100,
                        arcBackgroundColor: ColorTheme.lightPurple,
                        arcType: ArcType.FULL,
                        circularStrokeCap: CircularStrokeCap.round,
                        animateFromLastPercent: true,
                        backgroundColor: Colors.transparent,
                        progressColor: ColorTheme.blue,

                        footer: Column(
                          children: <Widget>[
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
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
                                      " ${double.parse(documentSnapshot.data["initialStock"].toString()).truncate()} UI",
                                      style: GoogleFonts.raleway(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ],
                        ),
//blur
                      ),
                    ],
                  );
                }
              } else {
                return CircularProgressIndicator();
              }

              break;
          }
          return Text("Carregando");
        },
      );
    } else {
      return Center(
          child: Text(
              "Erro durante o processamento. Per gentileza, tentar novamente."));
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserId();

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
                                FutureBuilder<FirebaseUser>(
                                  future: future,
                                  builder: (context,
                                      AsyncSnapshot<FirebaseUser>
                                          futureSnapshot) {
                                    switch (futureSnapshot.connectionState) {
                                      case ConnectionState.done:
                                        return doneConnectionFuture(
                                            futureSnapshot);
                                        break;
                                      case ConnectionState.waiting:
                                        return CircularProgressIndicator();
                                        break;
                                      case ConnectionState.none:
                                        return Text(
                                            "Nenhuma conexão de rede ativa");
                                        break;
                                      case ConnectionState.active:
                                        return Text("Conexão ativa");
                                        break;
                                    }
                                    return Text("Something went really wrong");
                                  },
                                )
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
                                      _quantity,
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
