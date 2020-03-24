import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hemocare/pages/main-screen.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:hemocare/utils/utils.dart';
import 'package:intl/intl.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Adicionar infusão",
                      style: GoogleFonts.raleway(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
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
                    Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: DropDownFormField(
                          titleText: 'Selecione uma opção',
                          hintText: "Selecione o tipo de infusão",
                          value: _infusionType,
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
                        )),
                    Divider(),
                    TextFormField(
                      focusNode: _dosageFocus,
                      controller: _dosageController,
                      decoration: InputDecoration(
                          labelText: "Dosagem",
                          hintText: "Dosagem utilizada",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.healing),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.number,
                      validator: validateDosage,
                      onChanged: (value) => dosage = int.parse(value),
                      onSaved: (value) => dosage = int.parse(value),
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
                          onChanged: (newValue) =>
                              setState(() => _recurring = newValue),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: _descriptionFocus,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: "Caso deseje, informe uma descrição",
                        labelText: "Descrição",
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.healing),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => description = value,
                      onSaved: (value) => description = value,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //datepicker
                    DateTimeField(
                      format: format,
                      decoration: InputDecoration(
                          labelText: "Escolher a data e horario",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
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

            Utils.gradientPatternButton("Pronto!", () {
              _submit(_formKey, _infusionType, dosage, _recurring, description,
                  dateTime, context);
            }, context)
          ],
        ),
      ),
    );
  }
}

String validateDosage(String value) {
  if (int.parse(value) < 0)
    return 'Por favor insira valores positivos na dosagem';
  else
    return null;
}

void _submit(
    GlobalKey<FormState> _formKey,
    String infusionType,
    int dosage,
    bool recurring,
    String description,
    DateTime datetime,
    BuildContext context) {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();

    createInfusion(
        infusionType, dosage, recurring, description, datetime, context);
  }
}

void createInfusion(String infusionType, int dosage, bool recurring,
    String description, DateTime datetime, BuildContext context) async {
  LocalStorageWrapper ls = new LocalStorageWrapper();
  String userId = ls.retrieve("logged_id");
  await Firestore.instance.collection("histories").add({
    "userId": userId,
    "infusionType": infusionType,
    "dosage": dosage,
    "recurring": recurring,
    "description": description,
    "dateTime": datetime,
  }).then((sucess) => AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      tittle: 'Sucesso',
      desc: 'Novo registro adicionado com sucesso',
      btnOkOnPress: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }).show());
}

String validateInfusionType(String _infusionType) {
  if (_infusionType == null || _infusionType.isEmpty) {
    return "O tipo de infusão deve ser informado";
  }
  return "Sem erros";
}
