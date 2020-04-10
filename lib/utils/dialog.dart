import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/services/stock.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'ColorTheme.dart';

class CustomDialog {
  static Alert showDialog(
      BuildContext context,
      TextEditingController controller,
      String quantity,
      Function _switchVisibility) {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      addStock(double.parse(quantity), context).then((success) {
                        DocumentSnapshot ds = success;
                        if (ds.data.length != null) {
                          Navigator.of(context).pop();
                        }
                      });
                      controller.clear();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: ColorTheme.lightPurple,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "+",
                          style: GoogleFonts.raleway(
                              fontSize: 32, color: Colors.white),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
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
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: ColorTheme.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "-",
                          style: GoogleFonts.raleway(
                              fontSize: 40, color: Colors.white),
                        ),
                      ),
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
            gradient: LinearGradient(
                colors: [ColorTheme.lightPurple, ColorTheme.blue]),
          )
        ]);
  }

  CustomDialog();
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
