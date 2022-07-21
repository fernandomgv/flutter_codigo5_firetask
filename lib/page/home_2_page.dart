

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home2Page extends StatefulWidget {

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  StreamController<int>  _myStreamController = StreamController.broadcast();

  final CollectionReference _tasColletion = FirebaseFirestore.instance.collection("tasks");

 int task=0;

  Stream<int> getNumberStream() async* {
    for(int i=10; i>0; i--){
      await Future.delayed(Duration(seconds: 2));
      yield (i);
    }
    yield (0);

  }

  futureControler()async{
    for (int i= 0; i<=10; i++ ) {
      print("dentro del futurecontroler");
     await Future.delayed(Duration(seconds: 2));
      _myStreamController.add(i);
    }
  }

  @override void initState()  {
    // TODO: implement initState
    super.initState();
    _myStreamController.stream.listen((event) {
      print("ESCUCHANDO 1:::: $event");
    },
    onDone: (){
      print("TERMINE DE ESCUCHAR:::::");
    });
    print("antes del futurecontroler");
   // futureControler();

  }

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    _myStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: _myStreamController.stream,
          builder: (BuildContext context , AsyncSnapshot snap){
            if(snap.hasData){
              int dato = snap.data;
              return Center(
                child: Text("Task (${dato.toString()})",
                  style: TextStyle(
                      fontSize: 14
                  ),
                ),
              );
            }
            return Text("Iniciando");
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          task++;
          _myStreamController.add(task);
        },
        child: Icon(Icons.add),
      ),
      body: /*StreamBuilder(
        stream: _tasColletion.snapshots() ,
        builder: (BuildContext context , AsyncSnapshot snap){
          QuerySnapshot colletion = snap.data;
          if(snap.hasData){
            print(colletion.docs.length);
          }

          return Text("Hola");
        },
      ),*/
      /*
      StreamBuilder(
        stream: getNumberStream() ,
        builder: (BuildContext context , AsyncSnapshot snap){

          if(snap.hasData){
            int dato = snap.data;
            return Center(
              child: Text(dato.toString(),
              style: TextStyle(
                fontSize: 40
              ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),*/

      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _myStreamController.stream,
              builder: (BuildContext context , AsyncSnapshot snap){
                if(snap.hasData){
                  int dato = snap.data;
                  return Center(
                    child: Text(dato.toString(),
                      style: TextStyle(
                          fontSize: 40
                      ),
                    ),
                  );
                }
                return Text("Iniciando");
              },
            )
          ],
        ),
      ),
    );
  }
}
