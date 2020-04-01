import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/pages/login/initial-stock-register.dart';
import 'package:hemocare/pages/login/login.dart';
import 'package:hemocare/pages/login/register.dart';
import 'package:hemocare/pages/login/use-terms.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/services/social-authentication.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/utils.dart';

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

  @override
  void initState() {
    currentPage = 0;
    super.initState();
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
