
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');
  List<QueryDocumentSnapshot>? myDocs;
  List<Map<String, dynamic>> myTasks = [];

  getDocuments() async {
    _tasksCollection.get().then((QuerySnapshot collection) {
      collection.docs.forEach((element) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        print("${key}: ${value}");
      });
    });

      myDocs = collection.docs;
      List<QueryDocumentSnapshot> docs = myDocs as List<QueryDocumentSnapshot>;

      docs.forEach((element) {
        Map<String, dynamic> myMap = element.data() as Map<String, dynamic>;
        myTasks.add(myMap);
      });

      myDocs!.forEach((element) {
        print(element.id);
        print(element.data());
      });
      setState(() {

      });

    });
    /*
    DocumentSnapshot snapshot = await tasks.doc("CEVBb2ZLyEs2OTG0RE6Y").get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data.forEach((key, value) {
      print("${key}: ${value}");
    });
     */
  }

  createDocumento(){
    _tasksCollection.add({
      "title":"Segundo metodo de creación de documentos",
      "status":true,
      "created_date": DateTime.now(),
    }).then((value) {
      print(value.id);
    }
    ).catchError((error){
      print(error);
    }
    );
  }

updateDocumento(String id, Map<String, dynamic> update){
    _tasksCollection.doc(id).update(
      update,
    ).catchError((error){
      print(error);
    });
}

deleteDocumento(String id){
    _tasksCollection.doc(id).delete().whenComplete(() {
      print("Se ha eliminado el documento $id");
    }
    ).catchError((error){
      print(error);
    });

}

createDocumento2(String id, Map<String, dynamic> data){
    _tasksCollection.doc(id).set(data);
}
  @override void initState() {
    // TODO: implement initState
    super.initState();
    getDocuments();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child:Column(
          children: [
            Container(
              child: Text(
                "Mis Tareas",
                style: TextStyle(
                    fontSize: 22.0
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: /*ListView.builder(
                itemCount: myTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(myTasks[index]["title"]),
                    subtitle: Text("Estado: ${myTasks[index]["status"]} / Fecha: ${(myTasks[index]["created_date"] as Timestamp).toDate()}"),
                  );
                },
              ),
              */
              FutureBuilder(
                future: _tasksCollection.get(),
                builder: (BuildContext context, AsyncSnapshot snap )
                {
                  if (snap.hasData) {

                    List<Map<String, dynamic>> tasks = [];

                    QuerySnapshot collection = snap.data;
                    collection.docs.forEach((element) {
                      String id = element.id;
                      Map<String, dynamic> datos = element.data() as Map<String, dynamic>;
                      datos["id"]=id;

                      tasks.add( datos);
                    });

                    return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text(tasks[index]["title"],),
                            subtitle: Text("Estado: ${tasks[index]["status"]} / Fecha: ${(tasks[index]["created_date"] as Timestamp).toDate()}"),
                            trailing: IconButton(
                              onPressed: (){
                                deleteDocumento(tasks[index]["id"]);
                                setState(() {

                                });
                              },
                              icon: Icon(Icons.delete),

                            ),

                          );
                        }
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }

              )
            ),
      Expanded(
          flex: 2,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              Column(
                children:
                myDocs != null ?
                myDocs!.map((e)
                {
                  return Text(e!.data().toString());
                }).toList()
                    :
                [],
              ),*/

              ElevatedButton(
                  onPressed: (){
                    getDocuments();
                  },
                  child: Text("Get data")),
              ElevatedButton(
                  onPressed: (){
                    createDocumento();
                  },
                  child: Text("Create Documento")),
              ElevatedButton(
                  onPressed: (){
                    updateDocumento("Ud1s5yvTfhDuiAot93rD",
                        {"title": "Ir al cine despues de aprender firebase"});
                  },
                  child: Text("Update Documento")),
              ElevatedButton(
                  onPressed: (){
                    deleteDocumento("Ud1s5yvTfhDuiAot93rD");
                  },
                  child: Text("Delete Documento")),
              ElevatedButton(
                  onPressed: (){
                    createDocumento2("MicodigoAleatorio", {
                      "title":"Segundo metodo de creación de documentos",
                      "status":true,
                      "created_date": DateTime.now(),
                    });
                  },
                  child: Text("Create 2 Documento")),
            ],
          ),
      ),
          ]
        )


      ),
    );
  }
}
