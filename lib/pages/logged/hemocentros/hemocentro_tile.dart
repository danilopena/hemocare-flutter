import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/models/hemocentro_model.dart';
import 'package:hemocare/pages/logged/hemocentros/components/hemocentro_tile_button.dart';

class HemocentroTile extends StatelessWidget {
  final Hemocentro hemocentro;
  //TODO filtrar lista de estados e apresentar card
  HemocentroTile({this.hemocentro});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Card(
        elevation: 16,
        child: Container(
          height: 200,
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                hemocentro.name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.raleway(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                'Endereço: ${hemocentro.address}',
                style: GoogleFonts.raleway(fontSize: 14),
              ),
              Text(
                'Estado: ${hemocentro.state}',
                style: GoogleFonts.raleway(fontSize: 14),
              ),
              HemocentroTileButton(
                coordinates: hemocentro.googleUrl,
                phone: hemocentro.phones != null
                    ? hemocentro.phones[0] as String
                    : '',
              )
            ],
          ),
        ),
      ),
    );
  }
}
