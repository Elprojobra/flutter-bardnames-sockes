
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { 
  Online, 
  Offline, 
  Connecting
} 

class SocketService with ChangeNotifier { 

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {

          // Dart client
  this._socket = IO.io('http://localhost:3000', {
  'transports': ['websocket'],
  'autoConnect': true
  });
  this._socket.onConnect((_) {
    this._serverStatus = ServerStatus.Online;
    notifyListeners();
  });

  this._socket.onDisconnect((_) { 
  this._serverStatus = ServerStatus.Online;
  notifyListeners();
  });

 /* socket.on('nuevo-mensaje', (payload) {
    debugPrint('nuevo-mensaje: ');
    debugPrint('nombre: ${payload['nombre']}');
    debugPrint('mensaje: ${payload['mensaje']}');
    debugPrint(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
  });*/
  
  }

}