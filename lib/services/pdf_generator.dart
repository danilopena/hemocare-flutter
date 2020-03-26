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
      print(histories[0]);
    } else {
      print("No PDFGen, histories is null!");
    }
    histories.forEach((history) => {
          pdf.addPage(Page(
              pageFormat: PdfPageFormat.a4,
              build: (Context context) {
                return _buildHistoryCard(history);
              }))
        });
    print("Finished");
    await Printing.sharePdf(
        bytes: pdf.save(), filename: "Relatorio Infusoes.pdf");
  }

  Widget _buildHistoryCard(DocumentSnapshot history) {
    String infusionType = history.data["infusionType"];
    int dosage = history.data["dosage"];
    Timestamp date = history.data["dateTime"];
    bool recurring = history.data["recurring"];
    String description = history.data["description"];
    var format = new DateFormat("d MMM, hh:mm a");
    var dateFormatted =
        new DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    return Container(
        height: 220,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: PdfColors.white,
          borderRadius: 4,
        ),
        width: PdfPageFormat.a4.width - 20,
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
                    Text("$infusionType", style: TextStyle(fontSize: 18))
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
                      "$dosage",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              dosage > 4000 ? PdfColors.red : PdfColors.black),
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
                        fontSize: 18,
                      ),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Recorrencia: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      "${recurring ? "SIM" : "NAO"}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Descricao: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Flexible(
                        child: Text(
                      "$description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ))
                  ]),
            ]));
  }
}
