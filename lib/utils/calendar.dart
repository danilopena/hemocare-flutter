import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekday_selector_formfield/weekday_selector_formfield.dart';

class CustomCalendar {
  CustomCalendar();

  static Alert showCalendar(BuildContext context) {
    DateTime dateTime;
    List<days> selectedDays;
    final anotherFormat = DateFormat("HH:mm");
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
              format: anotherFormat,
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
                  return dateTime;
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
              saveNotification(selectedDays, dateTime);
              Navigator.pop(context);
            },
            gradient: LinearGradient(
                colors: [ColorTheme.lightPurple, ColorTheme.blue]),
          ),
          DialogButton(
            child: Text(
              "CANCELAR",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
            gradient: LinearGradient(
                colors: [ColorTheme.lightPurple, ColorTheme.blue]),
          )
        ]);
  }
}

void saveNotification(List<days> selectedDays, DateTime dateTime) async {
  await LocalStorage("hemocare").ready.then((ready) {
    LocalStorage("hemocare")
        .setItem("notification_days", selectedDays.toString());
    LocalStorage("hemocare").setItem("notification_hour", dateTime.toString());
  });
}
