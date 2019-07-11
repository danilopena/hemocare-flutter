import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hemocare/sreens/login/login.dart';
import 'package:hemocare/sreens/login/use-terms.dart';
import 'package:hemocare/sreens/login/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new Initial());
  }
}

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  var currentPage = 0;

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                  position: currentPage,
                  decorator: DotsDecorator(
                    color: Colors.black87,
                    activeColor: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 26),
                createButtonRegister(),
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
                          color: Color(0xFF8EA1F0)),
                    ),
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(
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

  Widget createButtonRegister() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
            fullscreenDialog: true, builder: (context) => Register()));
      },
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        padding: const EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 12.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                colors: <Color>[Color(0xFF64D7EB), Color(0xFF8EA1F0)])),
        child: Text(
          'Criar conta',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
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
            border: Border.all(width: 1, color: Color(0xFF8EA1F0))),
        child: Text(
          'Já possuo login',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Color(0xFF8EA1F0)),
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
              shape: StadiumBorder(side: BorderSide(color: Color(0xFF8EA1F0))),
              color: Colors.white,
              onPressed: () {},
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
              shape: StadiumBorder(side: BorderSide(color: Color(0xFF8EA1F0))),
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
