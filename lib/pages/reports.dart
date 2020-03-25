import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/services/local_storage.dart';
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
        .then((_) => print("Data inicializada"));
  }

  @override
  Widget build(BuildContext context) {
    LocalStorageWrapper ls = new LocalStorageWrapper();
    String userId = ls.retrieve("logged_id");
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Center(
              child: Text(
            "Geração de Relatório",
            style:
                GoogleFonts.raleway(fontSize: 36, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("histories")
                .where("userId", isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Expanded(
                child: ListView.builder(
                    itemExtent: 150,
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
                      var format = new DateFormat("d MMM, hh:mm a");
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

Widget _buildHistoryCard(BuildContext context, String infusionType, int dosage,
    DateTime dateFormatted, bool recurring, String description) {
  var format = new DateFormat("d MMMM y, 'às' H:mm ", "pt_BR");
  var date = new DateTime.fromMillisecondsSinceEpoch(
      dateFormatted.millisecondsSinceEpoch);
  return Container(
      height: 140,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                style: GoogleFonts.raleway(fontSize: 18),
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
                style: GoogleFonts.raleway(fontSize: 18),
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
              Text(
                "${description != null ? description : "Não informada pelo paciente"}",
                style: GoogleFonts.raleway(fontSize: 18),
              )
            ],
          ),
        ],
      ));
}
