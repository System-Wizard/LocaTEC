import 'dart:io';

import 'package:beta/src/pages/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/button_app.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  MapController _con = new MapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonDrawer(),
                    _buttonPosition()
                  ],
                ),
                Expanded(child: Container()),
                _buttonConnect()

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonConnect() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      //alignment: Alignment.bottomCenter,
      child: ButtonApp(
        text: 'Iniciar', /*onPressed: (){},
          text: _con.isConnect ?  'Parar' : 'Iniciar', color: _con.isConnect ? Colors.grey[300] : Colors.amber, textColor: Colors.black,*/
      ),
    );
  }

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu, color: Colors.transparent,),
      ),
    );
  }

  Widget _buttonDrawertwo()
  {
    return IconButton(
        onPressed: (){
          Scaffold.of(context).openDrawer();
    },
         icon: Icon(Icons.menu, color: Colors.white,));
  }



  Widget _buttonPosition()
  {
    return GestureDetector(
      onTap: _con.centerPosition,

    //  alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          color: Colors.black,
        elevation: 4.0,
        shape: CircleBorder(),
        child: Container(padding: EdgeInsets.all(10), child: Icon(Icons.location_searching, color: Colors.grey[100], size: 20,)),
        ),
      ),
    );
  }

  Widget _googleMapsWidget(){
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _con.initialPosition,
        onMapCreated: _con.onMapCreated,
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(_con.markers.values),);
  }


  Widget _drawer()
  {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(child: Text('UbicaTEC', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1)
            ),
              SizedBox(height: 30), //Separacion entre texcto e imagen
            Container(child: Text('Bienvenido a UbicaTEC', style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.bold), maxLines: 1)
            )
          ],),
            decoration: BoxDecoration(
              color: Colors.amber
            ),
          ),
          ListTile(
            title: Text('Salir'),
            leading: Icon(Icons.power_settings_new),
            onTap: ()=> exit(0),
          )
        ],
      ),
    );
  }


  Widget _cardGooglePlaces()
  {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        child: Column(
          children: [Text('Desde', )],
        )
        ,
      ),
    );

  }

  void refresh()
  {
    setState(() {});
  }
  }



