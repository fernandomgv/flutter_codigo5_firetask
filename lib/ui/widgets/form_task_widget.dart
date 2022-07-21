

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_fire_task/ui/general/colors.dart';
import 'package:flutter_codigo5_fire_task/ui/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';

import '../../models/task_model.dart';
//import 'package:intl/locale.dart';

class FormTaskWidget extends StatefulWidget {
  //const FormTaskWidget({Key? key}) : super(key: key);
  TaskModel? task;
  FormTaskWidget({
    this.task,
});
  @override
  State<FormTaskWidget> createState() => _FormTaskWidgetState();
}

class _FormTaskWidgetState extends State<FormTaskWidget> {
  String selectedType = "Personal";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();


  CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  selectDate() async{

    DateTime? dateSelected = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        cancelText: "Cancelar",
        confirmText: "Aceptar",
        helpText:"Selecciona la fecha de la tarea",
        locale:  Locale("es"),
        builder: (BuildContext context, Widget? widget){
        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)
              )
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.green)
              )
              ),


            colorScheme: ColorScheme.light(
              primary: Colors.deepPurpleAccent
            )
          ),
          child: widget!,
        );

        }
    );


      final DateTime now = dateSelected != null ? dateSelected : DateTime.now();
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formatted = formatter.format(now);
      this._dateController.text = formatted;

      this._dateController.text !="" ? this._dateController.text : formatted;

  }
  addTask(Map<String, dynamic> data) {
    if (_formKey.currentState!.validate()) {
      _tasksCollection.add(data).then((value) {
        if(value!=null){
          Navigator.pop(context);
        }
      }
      );
      //setState(() {});
    }
  }

  updateTask() {
    if (_formKey.currentState!.validate()) {
      _tasksCollection
          .doc(this.widget.task!.id)
          .update(
        {
          "title": _titleController.text,
          "description": _descriptionController.text,
          "type": selectedType,
          "date": _dateController.text,
        },
      )
          .then(
            (value) {},
      )
          .whenComplete(
            () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.task != null)
      {
        selectedType=this.widget.task!.type;
        _dateController.text = this.widget.task!.date;
        _titleController.text = this.widget.task!.title;
        _descriptionController.text = this.widget.task!.description;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.0),
          topRight: Radius.circular(14.0),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Agregar nueva tarea"),
              TextFieldWidget(
                hintText: "Título",
                icon: Icons.text_fields,
                textController: _titleController,
              ),
              TextFieldWidget(
                hintText: "Descripción",
                icon: Icons.description,
                maxLines: 4,
                textController: _descriptionController,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10.0,
                children: [
                  FilterChip(
                    selected: selectedType== "Personal",
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    selectedColor: typeColorMap[selectedType],
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedType == "Personal" ? Colors.white : kFontPrimaryColor.withOpacity(0.7),
                    ),
                    label: Text("Personal"),
                    onSelected: (bool value) {
                      selectedType = "Personal";
                      setState(() {

                      });
                    },
                  ),
                  FilterChip(
                    selected: selectedType== "Trabajo",
                    backgroundColor: kBrandPrimaryColor,
                    selectedColor: typeColorMap[selectedType],
                    checkmarkColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    labelStyle: TextStyle(
                      color:  selectedType == "Trabajo" ? Colors.white : kFontPrimaryColor.withOpacity(0.7),
                    ),
                    label: Text(
                      "Trabajo",
                    ),
                    onSelected: (bool value) {
                      selectedType = "Trabajo";
                      setState(() {

                      });
                    },
                  ),
                  FilterChip(
                    selected: selectedType== "Otro",
                    backgroundColor: kBrandPrimaryColor,
                    selectedColor: typeColorMap[selectedType],
                    checkmarkColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    labelStyle: TextStyle(
                      color: selectedType == "Otro" ? Colors.white : kFontPrimaryColor.withOpacity(0.7),
                    ),
                    label: Text(
                      "Otro",
                    ),
                    onSelected: (bool value) {
                      selectedType = "Otro";
                      setState(() {

                      });
                    },
                  ),
                ],
              ),
              TextFieldWidget(
                hintText: "Fecha",
                icon: Icons.date_range,
                isDatePicker: true,
                textController: _dateController,
                onTap: (){
                  selectDate();
                },
              ),

              const SizedBox(
                height: 12.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (this.widget.task == null) {
                      String Id = "MicodigoAleatorio";
                      Map<String, dynamic> data = {
                        "title": _titleController.text,
                        "description": _descriptionController.text,
                        "date": _dateController.text,
                        "type": selectedType,
                        "finished": false,
                      };
                      addTask(data);
                    } else {
                      updateTask();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    primary: kFontPrimaryColor,
                  ),
                  icon: const Icon(
                    Icons.save,
                  ),
                  label: Text(
                    this.widget.task == null ? "Agregar tarea" : "Actualizar tarea",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
