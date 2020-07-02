import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hemocare/models/hemocentro_model.dart';
import 'package:hemocare/pages/logged/hemocentros/hemocentro_tile.dart';
import 'package:hemocare/stores/hemocentros/hemocentros_store.dart';
import 'package:hemocare/utils/custom_text_field.dart';

class HemocentrosScreen extends StatefulWidget {
  @override
  _HemocentrosScreenState createState() => _HemocentrosScreenState();
}

class _HemocentrosScreenState extends State<HemocentrosScreen> {
  HemocentrosStore hemocentrosStore;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hemocentrosStore = HemocentrosStore();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    hemocentrosStore = HemocentrosStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 16,
                child: CustomTextField(
                  hint: 'Buscar por estado',
                  controller: controller,
                  prefix: Icon(Icons.directions),
                  textInputType: TextInputType.text,
                  onChanged: hemocentrosStore.setSearch,
                )),
          ),
          Observer(
            builder: (BuildContext context) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: hemocentrosStore.filteredHemocentros.length,
                  itemBuilder: (_, int index) {
                    final Hemocentro item =
                        hemocentrosStore.filteredHemocentros[index];
                    return HemocentroTile(
                      hemocentro: item,
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
