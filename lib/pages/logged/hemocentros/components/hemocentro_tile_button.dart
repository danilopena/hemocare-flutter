import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                ? InkWell(
                    onTap: () async {
                      if (await canLaunch('tel://$phone')) {
                        await launch('tel://$phone');
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Ligar',
                          style: GoogleFonts.raleway(fontSize: 14),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          color: ColorTheme.green,
                          iconSize: 24,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: null,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Indisponível',
                          style: GoogleFonts.raleway(fontSize: 14),
                        ),
                        IconButton(
                          icon: Icon(Icons.call_end),
                          onPressed: () {},
                          tooltip: 'Telefone não encontrado',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  )),
        Container(
          height: 56,
          width: MediaQuery.of(context).size.width * 0.3,
          child: InkWell(
            onTap: () async {
              if (await canLaunch(coordinates)) {
                await launch(coordinates);
              }
            },
            child: Row(
              children: <Widget>[
                Text(
                  'Ver no mapa',
                  style: GoogleFonts.raleway(fontSize: 14),
                ),
                IconButton(
                  icon: Icon(
                    Icons.pin_drop,
                    color: ColorTheme.darkGray,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
