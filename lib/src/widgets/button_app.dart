import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  //const ButtonApp({Key? key}) : super(key: key);

 // Color color;
  //Color textColor;
  String text;
  IconData icon;


  ButtonApp({
   // this.color = Colors.black,
    required this.text,
    this.icon = Icons.arrow_forward_ios
    //this.textColor =Colors.white
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: elevatedButtonStyle,
        onPressed: (){},
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 40,
              alignment: Alignment.center,
                child: Text(text)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                child: Icon(icon, color: Colors.black,), backgroundColor: Colors.white,
              ),
            ),
          )
        ],));
  }

  final elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.black,
    onPrimary: Colors.white70,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
  );

}
