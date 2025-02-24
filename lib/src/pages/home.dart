import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curso_2/src/pages/models/band.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1' , name: 'Johan' , votes: 1),
    Band(id: '2' , name: 'Alexis' , votes: 1),
    Band(id: '3' , name: 'Isra' , votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames ' ,style: TextStyle( color: Colors.black12),),
        backgroundColor: Colors.black12,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder:(BuildContext context , int index){
          return _bandTile(bands[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile( Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ){
        print('direction: $direction');
        //TODO llamar el borrado en el server;
        print('id: ${band.id}');
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text( band.name),
            trailing: Text('${ band.votes}', style: TextStyle(fontSize: 20),),
            onTap: (){
              print( band.name);
            },
          ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New bad new'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('add'),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
      if (Platform.isAndroid){
        return showDialog(
        context: context,
        builder: ( context ){
          return AlertDialog(
            title: Text('New bad'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList( textController.text)
              ),
            ],
          );
        },
      );
      }
  }
  


  void addBandToList ( String name) {
        if ( name.length > 1 ){
           //Podemos agregar
           this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
            setState(() {});
        }
        Navigator.pop(context);
      }
}