import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/services/stock.dart';
import 'package:hemocare/utils/ColorTheme.dart';
import 'package:hemocare/utils/my-dropdown.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Infusions extends StatefulWidget {
  @override
  _InfusionsState createState() => _InfusionsState();
}

class _InfusionsState extends State<Infusions> {
  String _infusionType = '';
  int dosage = 0;
  //form
  bool validate = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //dosage
  final FocusNode _dosageFocus = FocusNode();
  final TextEditingController _dosageController = TextEditingController();
  //recorrente
  bool _recurring;
  //descricao
  String description = "";
  final FocusNode _descriptionFocus = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  //calendar
  final DateFormat format = DateFormat("dd/MM/yyy 'às' HH:mm");
  DateTime dateTime;
  bool _isLoading;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _recurring = false;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      color: Colors.white,
      isLoading: _isLoading,
      progressIndicator: Loading(
        color: ColorTheme.lightPurple,
        indicator: BallSpinFadeLoaderIndicator(),
      ),
      child: Scaffold(
        body: SafeArea(
            child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const FittedHeader(),
                // container de tipo de infusao
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MyDropDown(
                          titleText: 'Selecione uma opção',
                          hintText: 'Selecione o tipo de infusão',
                          value: _infusionType,
                          autovalidate: false,
                          validator: (value) {
                            if (value == null) {
                              return 'Escolha um tipo de infusao ';
                            }
                            return null;
                          },
                          required: true,
                          onSaved: (value) {
                            setState(() {
                              _infusionType = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _infusionType = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Profilaxia ",
                              "value": "Profilaxia",
                            },
                            {
                              "display": "Sob demanda",
                              "value": "Sob demanda",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          focusNode: _dosageFocus,
                          controller: _dosageController,
                          decoration: InputDecoration(
                              labelText: 'Ex: 2000',
                              hintText: 'Dosagem utilizada',
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.healing),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.number,
                          validator: validateDosage,
                          onChanged: (value) => dosage = int.parse(value),
                          onSaved: (value) => dosage = int.parse(value),
                          onFieldSubmitted: (value) =>
                              dosage = int.parse(value),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Essa queixa é recorrente?',
                                textScaleFactor: 1,
                                style: GoogleFonts.raleway(fontSize: 18),
                              ),
                              Switch.adaptive(
                                value: _recurring,
                                onChanged: (newValue) {
                                  setState(() {
                                    _recurring = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _recurring,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: _descriptionFocus,
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Ex: Ao jogar futebol, torci o tornozelo.',
                                  labelText: 'Coloque uma descrição do fato',
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(Icons.description),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (value) => description = value,
                                onSaved: (value) => description = value,
                              )
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        //datepicker
                        DateTimeField(
                          format: format,
                          decoration: InputDecoration(
                            hintText:
                                'Escolha o dia e a hora que você aplicou o fator',
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onShowPicker: (context, currentValue) async {
                            final DateTime date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final TimeOfDay time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              dateTime = DateTimeField.combine(date, time);
                              return dateTime;
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Utils.gradientPatternButton("Pronto!", () {
                  _submit(_formKey, _infusionType, dosage, _recurring,
                      description, dateTime, context, _switchVisibility);
                }, context)
              ],
            ),
          ],
        )),
      ),
    );
  }

  _switchVisibility() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}

class FittedHeader extends StatelessWidget {
  const FittedHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Adicionar infusão",
                  textScaleFactor: 1,
                  style: GoogleFonts.raleway(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    "Registre rapidamente sua infusão\n para análises futuras",
                    textScaleFactor: 1,
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

String validateDosage(String value) {
  print("Dosage on validator: $value");
  if (int.parse(value) <= 0)
    return 'Por favor insira valores positivos na dosagem';
  if (int.parse(value) == null) return 'Informe a dosagem';
  if (value.isEmpty) return 'Informe a dosagem';
  return null;
}

void _submit(
    GlobalKey<FormState> _formKey,
    String infusionType,
    int dosage,
    bool recurring,
    String description,
    DateTime datetime,
    BuildContext context,
    Function _switchVisibility) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
  }

  if (recurring) {
    if (infusionType == null ||
        dosage == null ||
        description == null ||
        datetime == null) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: "AVISO!",
              desc: 'Por favor, informe todos os campos obrigatórios',
              btnOkOnPress: () {})
          .show();
    } else {
      _switchVisibility();
      createInfusion(infusionType, dosage, recurring, description, datetime,
          context, _switchVisibility);
    }
  } else {
    if (infusionType == null || dosage == null || datetime == null) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: "AVISO!",
              desc: 'Por favor, informe todos os campos obrigatórios',
              btnOkOnPress: () {})
          .show();
    } else {
      _switchVisibility();
      createInfusion(infusionType, dosage, recurring, description, datetime,
          context, _switchVisibility);
    }
  }
}

void createInfusion(
    String infusionType,
    int dosage,
    bool recurring,
    String description,
    DateTime datetime,
    BuildContext context,
    Function _switchVisibility) async {
  LocalStorageWrapper ls = new LocalStorageWrapper();
  String userId = ls.retrieve("logged_id");
  await Firestore.instance.collection("histories").add({
    "userId": userId,
    "infusionType": infusionType,
    "dosage": dosage,
    "recurring": recurring,
    "description": description,
    "dateTime": datetime,
  }).then((success) {
    print("Will remove");
    StockHandler sh = new StockHandler();
    sh.removeStock(dosage).then((success) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'Sucesso',
          desc: 'Novo registro adicionado com sucesso',
          btnOkOnPress: () {
            _switchVisibility();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TabBarController()));
          }).show();
    });
  });
}

String validateInfusionType(String _infusionType) {
  if (_infusionType == null || _infusionType.isEmpty) {
    return "O tipo de infusão deve ser informado";
  }
  return null;
}
