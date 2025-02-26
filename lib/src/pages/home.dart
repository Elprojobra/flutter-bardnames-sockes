import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curso_2/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
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
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    // TODO: implement initState
    super.initState();
  }

  _handleActiveBands( dynamic payload){
    this.bands = (payload as List).map( (band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames ' ,style: TextStyle( color: Colors.black12),),
        backgroundColor: Colors.black12,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: 
              Icon(
              Provider.of<SocketService>(context).serverStatus == ServerStatus.Online 
                ? Icons.check_circle 
                : Icons.offline_bolt, 
              color: Provider.of<SocketService>(context).serverStatus == ServerStatus.Online 
                ? Colors.green 
                : Colors.red,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
                itemBuilder:(BuildContext context , int index){
                      return _bandTile(bands[index]);
                    }
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile( Band band) {

    final socketService = Provider.of<SocketService>(context , listen: false); ;

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', {'id': band.id}),
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
            onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),                
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
        builder: ( context ) => AlertDialog(
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
          ),
      );
      }
  }
  


  void addBandToList ( String name) {
        if ( name.length > 1 ){

          print( name);
           //Podemos agregar
           //emitir: add-band
           //{ name de la banda}

           final socketService = Provider.of<SocketService>(context, listen: false);
           socketService.socket.emit('add-band', {'name': name});
        }
        Navigator.pop(context);
      }

    //Mostrar grafica
    Widget _showGraph() {

    Map<String, double> dataMap =  new Map();
    {
      bands.forEach((band) {
        dataMap[band.name] = band.votes.toDouble();
        /*setState(() {
        });*/
      });

      }
      return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(dataMap: dataMap ));
    }
}