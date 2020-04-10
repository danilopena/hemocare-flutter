import 'package:add_to_calendar/add_to_calendar.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
              await LocalStorage("hemocare").setItem(
                  "notification_days", selectedDays.toList().toString());
              await LocalStorage("hemocare")
                  .setItem("notification_hour", dateTime.toString());
              // pegar o dia 1
              var day1 = selectedDays
                  .toString()
                  .split(",")[0]
                  .replaceAll("[", "")
                  .replaceAll(" ", "");
              var day2 = selectedDays
                  .toString()
                  .split(",")[1]
                  .replaceAll("]", "")
                  .replaceAll(" ", "");
              print("$day1 && $day2");
              DateTime now = new DateTime.now();
              /**
               * Passos a seguir:
               *
               * 1) Pegar os dias que o user escolheu (até 2 ocorrências de 1 a 7)
               * 2) Criar uma ocorrência para repetir a cada 7 dias,
               * 3) Os dias no calendario vão de 1 a 31
               * 4) A questão é: como fazer os dias do calendário
               * conversarem com os dias que o cara escolheu.
               *
               * Ex: Escolho terça e quinta: (dias 2 e 4)
               * Hoje, 07/04 é terça
               *
               *
               */
              return;
              AddToCalendar.addToCalendar(
                title: "Profilaxia",
                startTime: new DateTime.now(),
                description: "Realizar Profilaxia",
                isAllDay: true,
                frequencyType: FrequencyType.WEEKLY,
              );
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

void showNotification() async {
  String days;
  String hour;
  int firstDay;
  int secondDay;
  await LocalStorage("hemocare").ready.then((ready) {
    days = LocalStorage("hemocare").getItem("notification_days");
    hour = LocalStorage("hemocare").getItem("notification_hour");
  });
  print("Dias e hora: $days || $hour");
  var day1 = days.split(",")[0].replaceAll("[", "").replaceAll(" ", "");
  var day2 = days.split(",")[1].replaceAll("]", "").replaceAll(" ", "");
  //hour  0001-01-01 11:30:00.000
  var parsedDate = DateTime.parse(hour);

  /*
       static const Sunday = Day(1);
  static const Monday = Day(2);
  static const Tuesday = Day(3);
  static const Wednesday = Day(4);
  static const Thursday = Day(5);
  static const Friday = Day(6);
  static const Saturday = Day(7);

     */
  switch (day1) {
    case "days.monday":
      firstDay = 2;
      break;

    case "days.tuesday":
      firstDay = 3;
      break;
    case "days.wednesday":
      firstDay = 4;
      break;
    case "days.thursday":
      firstDay = 5;
      break;
    case "days.friday":
      firstDay = 6;
      break;
    case "days.saturday":
      firstDay = 7;
      break;
    case "days.sunday":
      firstDay = 1;
      break;
  }
  switch (day2) {
    case "days.monday":
      secondDay = 2;
      break;
    case "days.tuesday":
      secondDay = 3;
      break;
    case "days.wednesday":
      secondDay = 4;
      break;
    case "days.thursday":
      secondDay = 5;
      break;
    case "days.friday":
      secondDay = 6;
      break;
    case "days.saturday":
      secondDay = 7;
      break;
    case "days.sunday":
      secondDay = 1;
      break;
  }
  // mesmo dia e mesmo horario - notifica once
  if (secondDay == null) {
    print("First ${new Day(firstDay)}");

    await _notificate(firstDay, parsedDate.hour, parsedDate.minute);
  } else {
    print("First ${new Day(firstDay)} && second: ${new Day(secondDay)}");
    await _notificate(firstDay, parsedDate.hour, parsedDate.minute, secondDay);
  }
}

Future<void> _notificate(int firstDay, int hour, int minute,
    [int secondDay]) async {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails("Hemocare",
      "Profilaxia", "Notificar os usuarios sobre profilaxias agendadas",
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'Profilaxia');
  var iosChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, iosChannelSpecifics);
  if (secondDay != null) {
    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        "Profilaxia",
        "Hoje é dia de realizar a sua profilaxia ",
        new Day(firstDay),
        new Time(hour, minute),
        platformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        "Profilaxia",
        "Hoje é dia de realizar a sua profilaxia! Vamos lá?",
        new Day(secondDay),
        new Time(hour, minute),
        platformChannelSpecifics);
  } else {
    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        "Profilaxia",
        "Hoje é dia de realizar a sua profilaxia! Vamos lá?",
        new Day(firstDay),
        new Time(hour, minute),
        platformChannelSpecifics);
  }
}

int getDay(String value) {
  switch (value) {
    case "days.monday":
      return 1;
      break;
    case "days.tuesday":
      return 2;
      break;
    case "days.wednesday":
      return 3;
      break;
    case "days.thursday":
      return 4;
      break;
    case "days.friday":
      return 5;
      break;
    case "days.saturday":
      return 6;
      break;
    case "days.sunday":
      return 7;
      break;
  }
}
