import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PDFGenerator {
  void generate(List<DocumentSnapshot> histories) async {
    final Document pdf = Document();
    initializeDateFormatting("pt_BR", null)
        .then((_) => print("Data inicializada"));
    if (histories != null) {
    } else {
      print("No PDFGen, histories is null!");
    }
    histories.forEach((history) => {
          pdf.addPage(Page(
              pageFormat: PdfPageFormat.a5,
              build: (Context context) {
                return _buildHistoryCard(history);
              }))
        });
    await Printing.sharePdf(
        bytes: pdf.save(), filename: "Relatório de Infusões.pdf");
  }

  Widget _buildHistoryCard(DocumentSnapshot history) {
    String infusionType = history.data["infusionType"];
    int dosage = history.data["dosage"];
    Timestamp date = history.data["dateTime"];
    bool recurring = history.data["recurring"];
    String description = history.data["description"];
    var format = new DateFormat("d MMMM y, 'às' H:mm ", "pt_BR");
    var dateFormatted =
        new DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    return Container(
        height: 220,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: PdfColors.white,
          borderRadius: 4,
        ),
        width: PdfPageFormat.a5.width - 20,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Procedimento: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text("$infusionType", style: TextStyle(fontSize: 20))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Dosagem: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      "$dosage UI",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:
                              dosage > 2000 ? PdfColors.red : PdfColors.black),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Data: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      "${format.format(dateFormatted)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Recorrência: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      "${recurring ? "SIM" : "NÃO"}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              recurring ? PdfColors.red : PdfColors.blueAccent),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Descrição: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Flexible(
                        child: Text(
                      "${description != null ? description : "Descrição não informada pelo paciente."}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ))
                  ]),
            ]));
  }
}
