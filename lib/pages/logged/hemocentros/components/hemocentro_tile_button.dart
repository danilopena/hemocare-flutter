import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:url_launcher/url_launcher.dart';

class HemocentroTileButton extends StatelessWidget {
  final String phone;
  final String coordinates;

  const HemocentroTileButton({Key key, this.phone, this.coordinates})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.3,
            child: phone.length > 5
                ? Row(
                    children: <Widget>[
                      Text('Ligar'),
                      IconButton(
                        icon: Icon(Icons.phone),
                        color: ColorTheme.green,
                        iconSize: 24,
                        onPressed: () async {
                          await launch('tel://$phone');
                        },
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
//                      const Text('Não disponível'),
                      IconButton(
                        icon: Icon(Icons.call_end),
                        onPressed: () {},
                        tooltip: 'Telefone não encontrado',
                        color: Colors.red,
                      ),
                    ],
                  )),
        Container(
          height: 56,
          width: MediaQuery.of(context).size.width * 0.25,
          child: Row(
            children: <Widget>[
              Text('Navegar'),
              IconButton(
                icon: Icon(Icons.directions),
                onPressed: () async {
                  if (await canLaunch(coordinates)) {
                    await launch(coordinates);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
