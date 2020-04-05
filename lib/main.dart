import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/pages/login/initial-stock-register.dart';
import 'package:hemocare/pages/login/login.dart';
import 'package:hemocare/pages/login/register.dart';
import 'package:hemocare/pages/login/use-terms.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/services/social-authentication.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:localstorage/localstorage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, home: new Initial());
  }
}

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  var currentPage = 0;
  var loggedUser;

  //notifications
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification() async {
    String days;
    String hour;
    int firstDay;
    int secondDay;
    await LocalStorage("hemocare").ready.then((ready) {
      days = LocalStorage("hemocare").getItem("notification_days");
      hour = LocalStorage("hemocare").getItem("notification_hour");
      print("D $days");
      print("H $hour");
    });
    print("Dias e hora: ${days} ]] $hour");
    var day1 = days.split(",")[0].replaceAll("[", "");
    var day2 = days.split(",")[1].replaceAll("]", "");
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
      await _notificate(
          firstDay, parsedDate.hour, parsedDate.minute, secondDay);
    }
  }

  Future<void> _notificate(int firstDay, int hour, int minute,
      [int secondDay]) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails("Hemocare",
        "Profilaxia", "Notificar os usuarios sobre profilaxias agendadas",
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'Profilaxia');
    var iosChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iosChannelSpecifics);
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

  @override
  void initState() {
    currentPage = 0;
    super.initState();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');

    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    if (_flutterLocalNotificationsPlugin.pendingNotificationRequests != null) {
      _showNotification();
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint("Notification payload $payload");
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                )
              ],
            ));
  }

  final imgs = ['doctor', 'doctor-man', 'hemophilia'];
  final titles = [
    'Bem vindo ao Hemocare!',
    'Somos a melhor equipe.',
    'Te deixaremos antenado no mundo da Hemofilia.'
  ];

  final subtitles = [
    'Nós te ajudamos a cuidar da sua saúde.',
    'Com nosso time, você terá uma qualidade de vida excelente.',
    'Saiba tudo sobre sua patologia, vem com a gente.'
  ];

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//      statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
//    ));

    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                  child: Text("Nao foi possivel conectar ao banco de dados"));
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return TabBarController();
              } else {
                return SafeArea(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: null,
                    body: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.40,
                              child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  onPageChanged: (index) {
                                    setState(() => currentPage = index);
                                  },
                                  itemBuilder: (context, position) {
                                    return createTopScrollableElement(
                                        context,
                                        imgs[position],
                                        titles[position],
                                        subtitles[position]);
                                  }),
                            ),
                            DotsIndicator(
                              dotsCount: 3,
                              position: currentPage.roundToDouble(),
                              decorator: DotsDecorator(
                                color: Colors.black87,
                                activeColor: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 26),
                            Utils.gradientPatternButton('Criar conta', () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => Register()));
                            }, context),
                            SizedBox(height: 10),
                            createButtonLogin(),
                            SizedBox(height: 40),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            createSocialMediaButtons(),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                child: Text(
                                  'Termos de uso',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorTheme.lightPurple),
                                ),
                                onTap: () => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => UseTerms())),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          }
          return null;
        });
  }

  Widget createButtonLogin() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
            fullscreenDialog: true, builder: (context) => Login()));
      },
      color: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        padding: const EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 12.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: ColorTheme.lightPurple)),
        child: Text(
          'Já possuo login',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: ColorTheme.lightPurple),
        ),
      ),
    );
  }

  Widget createSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            height: 60,
            width: 60,
            child: RaisedButton(
              child: Image.asset(
                'assets/google.png',
                width: 30,
                height: 30,
              ),
              shape: StadiumBorder(
                  side: BorderSide(color: ColorTheme.lightPurple)),
              color: Colors.white,
              onPressed: () {
                try {
                  new SocialAuth().loginWithGoogle();
                  _redirect();
                } catch (e) {
                  print("e $e");
                }
              },
            ),
          ),
        ),
        SizedBox(width: 26),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            height: 60,
            width: 60,
            child: RaisedButton(
              child: Image.asset(
                'assets/facebook.png',
                width: 30,
                height: 30,
              ),
              shape: StadiumBorder(
                  side: BorderSide(color: ColorTheme.lightPurple)),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }

  Widget createTopScrollableElement(context, imgTitle, title, subtitle) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/" + imgTitle + ".jpg"),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          height: 20,
        ),
        Text(title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Futura', color: Colors.black, fontSize: 24)),
        SizedBox(
          height: 10,
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
          child: Text(subtitle,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Futura', color: Colors.grey, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _redirect() {
    print("Has been called! ");
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        print("Snapshot ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.done) {
          print("Snapshot in redirect done> ${snapshot.data}");

          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.hasData) {
            print("Snapshot in redirect> ${snapshot.data}");
            LocalStorageWrapper ls = new LocalStorageWrapper();
            ls.save("logged_id", snapshot.data.uid);
            return InitialStockRegister();
          }
        }
        return Login();
      },
    );
  }
}
