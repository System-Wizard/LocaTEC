import 'package:beta/src/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatelessWidget {
  HomeController _con = new HomeController();
  //const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    _con.init(context); // Inicializacion de controlador
    return Scaffold(
      //colors: [Color(0xFFC20000), Color(0xFFFF0000), Color(0xFFFF7676)]backgroundColor: Color(0xFFE9344C),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFFC20000), Color(0xFFFF0000), Color(0xFFFF7676)]
            )
          ),
          child: Column(
            children: [
              _bannerApp(context),

              SizedBox(height: 50), //Separacion entre imagen y texto

              _textMapUser(),

              SizedBox(height: 30), //Separacion entre texcto e imagen

              //Imagen circular
              _imageTypeUser('assets/img/map_icon.png'),

              SizedBox(height: 10,),

              _textTypeUser('Mapa')

            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerApp(BuildContext context){
    return ClipPath(
      clipper: WaveClipperTwo(flip: true),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                //colors: [Color(0xFFE9344C), Colors.purple, Colors.blue]
                //colors: [Color(0xFF845EC2C), Color(0xFF845EC2), Color(0xFFE4B7FF), Color(0xFF5E3C9C), Color(0xFF05004C), Color(0xFFFFD6FF)]
                //colors: [Color(0xFF845EC2), Color(0xFFBF33B5), Color(0xFFD43725)] , Color(0xFF008F7A) , Color(0xFF008E9B  Color(0xFF845EC2C),
                //colors: [ Color(0xFF2C73D2), Color(0xFF0081CF), Color(0xFF0089BA), Color(0xFF008E9B), Color(0xFF008F7A)]
                colors: [ Color(0xFF000036), Color(0xFF00003F), Color(0xFF2000063), Color(0xFF000090), Color(0xFF0000FC)]
            )
        ),
        height: MediaQuery.of(context).size.height * 0.30,
        //color: Color(0xFFF3ED79),
        child: Row(
          //Espaciar los elementos
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/img/LogoApp.png', width: 200, height: 150,),
            Text('UbicaTec', style: TextStyle(fontFamily: 'Pacifico', fontSize: 45, fontWeight: FontWeight.w700, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _textMapUser(){
    return Text('Abre el mapa', style: TextStyle(fontSize: 20, fontFamily: 'OneDay', fontWeight: FontWeight.bold, color: Colors.white), );
  }

  Widget _textTypeUser(String typeUser){
    return Text(typeUser, style: TextStyle(color: Colors.white70, fontSize: 16),);
  }

  Widget _imageTypeUser(String image)
  {
    return GestureDetector(
      onTap: _con.goToLoginPage,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(image),
        radius: 50,

        // Usar hexadecimal = backgroundColor: Color(0xFF00CBF3),

       // backgroundColor: Colors.black,
      ),
    );
  }


}
