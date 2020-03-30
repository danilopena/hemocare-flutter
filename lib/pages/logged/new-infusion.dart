import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/logged/tab-bar-controller.dart';
import 'package:hemocare/services/local_storage.dart';
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
  String _infusionType = "";
  int dosage = 0;
  //form
  bool validate = true;
  final _formKey = GlobalKey<FormState>();
  //dosage
  FocusNode _dosageFocus = new FocusNode();
  TextEditingController _dosageController = new TextEditingController();
  //recorrente
  bool _recurring = false;
  //descricao
  String description;
  FocusNode _descriptionFocus = new FocusNode();
  TextEditingController _descriptionController = new TextEditingController();
  //calendar
  final format = DateFormat("yyyy-MM-dd HH:mm");
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Adicionar infusão",
                          style: GoogleFonts.raleway(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: Text(
                            "Registre rapidamente sua infusão para análises futuras",
                            style: GoogleFonts.raleway(
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          hintText: "Selecione o tipo de infusão",
                          value: _infusionType,
                          autovalidate: false,
                          validator: (value) {
                            if (value == null) {
                              return "Escolha um tipo de infusao ";
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          focusNode: _dosageFocus,
                          controller: _dosageController,
                          decoration: InputDecoration(
                              labelText: "Ex: 2000",
                              hintText: "Dosagem utilizada",
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Essa queixa é recorrente?",
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
                        Visibility(
                          visible: _recurring,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: _descriptionFocus,
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText:
                                      "Ex: Ao jogar futebol, torci o tornozelo.",
                                  labelText: "Coloque uma descrição do fato",
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

                        SizedBox(
                          height: 20,
                        ),
                        //datepicker
                        DateTimeField(
                          format: format,
                          decoration: InputDecoration(
                            hintText: "Escolha a hora que você aplicou o fator",
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.perm_contact_calendar),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
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
                SizedBox(
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
    _switchVisibility();
    createInfusion(infusionType, dosage, recurring, description, datetime,
        context, _switchVisibility);
  }
  if (infusionType == null ||
      dosage == null ||
      recurring == null ||
      description == null ||
      datetime == null) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            tittle: "AVISO!",
            desc: 'POR FAVOR INFORME TODOS OS CAMPOS',
            btnOkOnPress: () {})
        .show();
  } else {}
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
  }).then((success) => AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      tittle: 'Sucesso',
      desc: 'Novo registro adicionado com sucesso',
      btnOkOnPress: () {
        _switchVisibility();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TabBarController()));
      }).show());
}

String validateInfusionType(String _infusionType) {
  if (_infusionType == null || _infusionType.isEmpty) {
    return "O tipo de infusão deve ser informado";
  }
  return null;
}
