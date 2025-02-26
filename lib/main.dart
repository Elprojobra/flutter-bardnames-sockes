import 'package:flutter/material.dart';
import 'package:flutter_curso_2/services/socket_service.dart';
import 'package:flutter_curso_2/src/pages/home.dart';
import 'package:flutter_curso_2/src/pages/status.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute:'home',
        routes: {
          'home':(_)=>HomePage(),
          'status':(_)=>StatusPage()
        },
      ),
    );
  }
}