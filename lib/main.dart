import 'package:beta/src/pages/home/home_page.dart';
import 'package:beta/src/pages/map/map_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Eliminar etiqueta de debug
      debugShowCheckedModeBanner: false,
      title: 'UbicTec',
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'Roboto'

      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'map': (BuildContext context) => MapPage(),
      },
    );
  }
}
