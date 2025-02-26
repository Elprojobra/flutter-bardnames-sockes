import 'package:flutter/material.dart';
import 'package:flutter_curso_2/services/socket_service.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    
    


    return Scaffold(
      appBar: AppBar(
        title: Text('Status Page'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
        onPressed: (){
          socketService.socket.emit('nuevo-mensaje', {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'}
        );      
      }),
    );
  }
}
