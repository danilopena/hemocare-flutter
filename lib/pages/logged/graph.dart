import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekday_selector_formfield/weekday_selector_formfield.dart';

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
  Stream stream;
  final LocalStorage localStorage = new LocalStorage('hemocare');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("Iniciado ou reattached");
    _isLoading = false;
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
                                Text(
                                  "Seu Estoque",
                                  style: GoogleFonts.raleway(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder<FirebaseUser>(
                                  future: FirebaseAuth.instance.currentUser(),
                                  builder: (context,
                                      AsyncSnapshot<FirebaseUser>
                                          futureSnapshot) {
                                    switch (futureSnapshot.connectionState) {
                                      case ConnectionState.done:
                                        if (futureSnapshot.data != null) {
                                          print(
                                              "FirebaseUser ${futureSnapshot.data.uid}");
                                          stream = Firestore.instance
                                              .collection("users")
                                              .document(futureSnapshot.data.uid)
                                              .get()
                                              .asStream();

                                          return StreamBuilder<
                                              DocumentSnapshot>(
                                            stream: stream,
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    documentSnapshot) {
                                              switch (documentSnapshot
                                                  .connectionState) {
                                                case ConnectionState.none:
                                                  return Text(
                                                      "Sem conexao de rede ativa");
                                                  break;
                                                case ConnectionState.waiting:
                                                  return CircularProgressIndicator();
                                                  break;
                                                case ConnectionState.active:
                                                  return Text("Conexao ativa");
                                                  break;
                                                case ConnectionState.done:
                                                  if (documentSnapshot
                                                          .data.data !=
                                                      null) {
                                                    return Column(
                                                      children: <Widget>[
                                                        Center(
                                                          child: Text(
                                                            "Você já usou ${documentSnapshot.data.data["percentageUsed"]}% do seu estoque",
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        ),
                                                        CircularPercentIndicator(
                                                          radius: 270.0,
                                                          animation: true,
                                                          animationDuration:
                                                              2000,
                                                          lineWidth: 40.0,
                                                          percent: documentSnapshot
                                                                      .data
                                                                      .data[
                                                                  "percentageUsed"] /
                                                              100,
                                                          arcBackgroundColor:
                                                              ColorTheme
                                                                  .lightPurple,
                                                          arcType: ArcType.FULL,
                                                          circularStrokeCap:
                                                              CircularStrokeCap
                                                                  .round,
                                                          animateFromLastPercent:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          progressColor:
                                                              ColorTheme.blue,

                                                          footer: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Seu estoque atual:",
                                                                    style: GoogleFonts
                                                                        .raleway(
                                                                      fontSize:
                                                                          24,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${double.parse(documentSnapshot.data.data["initialStock"].toString()).truncate()} UI",
                                                                    style: GoogleFonts.raleway(
                                                                        fontSize:
                                                                            28,
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                    return CircularProgressIndicator();
                                                  }
                                                  break;
                                              }
                                              return Text("Loading");
                                            },
                                          );
                                        } else {
                                          print("Snapshot error");
                                          return Text("Erro na bagaca");
                                        }
                                        break;
                                      case ConnectionState.waiting:
                                        return CircularProgressIndicator();
                                        break;
                                      case ConnectionState.none:
                                        return Text(
                                            "Nenhuma conexao de rede ativa");
                                        break;
                                      case ConnectionState.active:
                                        return Text("Conexao ativa");
                                        break;
                                    }
                                    return Text("My wai");
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
                            Utils.gradientPatternButton("Profilaxia", () {
                              _showCalendar(context).show();
                            }, context),
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

Alert _showCalendar(BuildContext context) {
  DateTime dateTime;
  List<days> selectedDays;
  final format = DateFormat("dd HH:mm");
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
  final values = List.filled(7, true);
  return Alert(
      title: "PROFILAXIA",
      context: context,
      style: alertStyle,
      content: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8),
            child: WeekDaySelectorFormField(
              initialValue: [],
              borderRadius: 20,
              fillColor: Colors.white,
              selectedFillColor: ColorTheme.blue,
              borderSide: BorderSide(color: ColorTheme.lightPurple, width: 2),
              language: lang.pt,
              onChange: (days) {
                selectedDays = days;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DateTimeField(
            format: format,
            decoration: InputDecoration(
              hintText: "Escolha o horário",
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.watch),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              if (time != null) {
                dateTime = DateTimeField.convert(time);
              }
              return currentValue;
            },
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "AGENDAR",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            String formattedDate = new DateFormat.Hm().format(dateTime);
            await LocalStorage("hemocare")
                .setItem("notification_days", selectedDays.toList().toString());
            await LocalStorage("hemocare")
                .setItem("notification_hour", dateTime.toString());
            Navigator.pop(context);
          },
          gradient:
              LinearGradient(colors: [ColorTheme.lightPurple, ColorTheme.blue]),
        )
      ]);
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
