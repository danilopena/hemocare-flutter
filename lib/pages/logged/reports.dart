import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/logged/new-infusion.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/services/pdf_generator.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting("pt_BR", null)
        .then((_) => print("Data inicializada no Report"));
  }

  @override
  Widget build(BuildContext context) {
    LocalStorageWrapper ls = new LocalStorageWrapper();
    String userId = ls.retrieve("logged_id");
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                    child: Text(
                  "Relatório",
                  style: GoogleFonts.raleway(
                      fontSize: 36, fontWeight: FontWeight.bold),
                )),
                IconButton(
                  icon: Icon(FontAwesomeIcons.filePdf),
                  tooltip: "Gerar PDF",
                  iconSize: 32,
                  onPressed: () {
                    _generatePDF(userId);
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("histories")
                .where("userId", isEqualTo: userId)
                .where("dateTime",
                    isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width - 50,
                          child: SvgPicture.asset("assets/empty.svg"),
                        ),
                        FittedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Você ainda não tem infusões cadastradas! Que tal registrar a ",
                                style: GoogleFonts.raleway(fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => Infusions()));
                                },
                                child: Text(
                                  "primeira?",
                                  style: GoogleFonts.raleway(
                                      color: ColorTheme.lightPurple,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                    itemExtent: 230,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      String infusionType =
                          snapshot.data.documents[index]["infusionType"];
                      int dosage = snapshot.data.documents[index]["dosage"];
                      Timestamp date =
                          snapshot.data.documents[index]["dateTime"];
                      bool recurring =
                          snapshot.data.documents[index]["recurring"];
                      String description =
                          snapshot.data.documents[index]["description"];
                      var dateFormatted =
                          new DateTime.fromMillisecondsSinceEpoch(
                              date.millisecondsSinceEpoch);

                      return Column(
                        children: <Widget>[
                          _buildHistoryCard(context, infusionType, dosage,
                              dateFormatted, recurring, description),
                        ],
                      );
                    }),
              );
            },
          ),
        ]),
      ),
    );
  }
}

void _generatePDF(String userId) async {
  //pegar os dados das infusoes
  List<DocumentSnapshot> histories;
  await Firestore.instance
      .collection("histories")
      .where("userId", isEqualTo: userId)
      .where("dateTime",
          isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
      .snapshots()
      .first
      .then((docs) => histories = docs.documents);
  new PDFGenerator().generate(histories);
}

Widget _buildHistoryCard(BuildContext context, String infusionType, int dosage,
    DateTime dateFormatted, bool recurring, String description) {
  var format = new DateFormat("d MMMM y, 'às' H:mm ", "pt_BR");
  var date = new DateTime.fromMillisecondsSinceEpoch(
      dateFormatted.millisecondsSinceEpoch);
  return Container(
      height: 220,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 1)
          ]),
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Procedimento: ",
                style: GoogleFonts.raleway(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "$infusionType",
                style: GoogleFonts.raleway(fontSize: 18),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Dosagem: ",
                style: GoogleFonts.raleway(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "$dosage",
                style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: dosage > 4000 ? Colors.red : Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Data: ",
                style: GoogleFonts.raleway(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "${format.format(date)}",
                style: GoogleFonts.raleway(fontSize: 18),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Recorrência: ",
                style: GoogleFonts.raleway(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "${recurring ? "SIM" : "NÃO"}",
                style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        recurring ? ColorTheme.blue : ColorTheme.lightPurple),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Descrição: ",
                style: GoogleFonts.raleway(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text(
                  "${description != null ? description : "Não informada pelo paciente"}",
                  style: GoogleFonts.raleway(fontSize: 18),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ],
      ));
}
