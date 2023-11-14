import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;



class MapController {
  BuildContext? contex;
  Function? refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(target: LatLng(18.4379874, -97.3996149), zoom: 20.0);

  late Position _position;
  late StreamSubscription<Position> _positionStream;

  BitmapDescriptor? markerDriver;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  Future? init(BuildContext context, Function refresh) async {
    this.contex = contex;
    this.refresh = refresh;
    markerDriver = await createMakerImageFromAsset('assets/img/Cardenal.png');
    checkGPS();
  }

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType": "geometry", "stylers": [{"color": "#1d2c4d"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#8ec3b9"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#1a3646"}]},{"featureType": "administrative.country","elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#64779e"}]},{"featureType": "administrative.province","elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},{"featureType": "landscape.man_made","elementType": "geometry.stroke","stylers": [{"color": "#334e87"}]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#023e58"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#283d6a"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#6f9ba5"}]},{ "featureType":"poi", "elementType":"labels.text.stroke", "stylers":[ { "color":"#1d2c4d" } ] }, { "featureType":"poi.park", "elementType":"geometry.fill", "stylers":[ { "color":"#023e58" } ] }, { "featureType":"poi.park", "elementType":"labels.text.fill", "stylers":[ { "color":"#3C7680" } ] }, { "featureType":"road", "elementType":"geometry", "stylers":[ { "color":"#304a7d" } ] }, { "featureType":"road", "elementType":"labels.text.fill", "stylers":[ { "color":"#98a5be" } ] }, { "featureType":"road", "elementType":"labels.text.stroke", "stylers":[ { "color":"#1d2c4d" } ] }, { "featureType":"road.highway", "elementType":"geometry", "stylers":[ { "color":"#2c6675" } ] }, { "featureType":"road.highway", "elementType":"geometry.stroke", "stylers":[ { "color":"#255763" } ] }, { "featureType":"road.highway", "elementType":"labels.text.fill", "stylers":[ { "color":"#b0d5ce" } ] }, { "featureType":"road.highway", "elementType":"labels.text.stroke", "stylers":[ { "color":"#023e58" } ] }, { "featureType":"transit", "elementType":"labels.text.fill", "stylers":[ { "color":"#98a5be" } ] }, { "featureType":"transit", "elementType":"labels.text.stroke", "stylers":[ { "color":"#1d2c4d" } ] }, { "featureType":"transit.line", "elementType":"geometry.fill", "stylers":[ { "color":"#283d6a" } ] }, { "featureType":"transit.station", "elementType":"geometry", "stylers":[ { "color":"#3a4762" } ] }, { "featureType":"water", "elementType":"geometry", "stylers":[ { "color":"#0e1626" } ] }, { "featureType":"water", "elementType":"labels.text.fill", "stylers":[ { "color":"#4e6d70" } ] } ]' );
    _mapController.complete(controller);
  }

  Future<void> checkGPS() async {
    bool isLocalitationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocalitationEnabled){
      print('gps activado');
      updateLocation();
    }
    else{
      print('gps desactivado');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS){
        updateLocation();
        print('Activo el GPS');
      }
    }
  }

  void updateLocation() async {
    try{
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();

      addMarker('user', _position.latitude, _position.longitude, 'Tu posicion','',markerDriver!);
      refresh!();
      _positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best, distanceFilter: 1).listen((Position position) {
        _position = position;
        addMarker('user', _position.latitude, _position.longitude, 'Tu posicion','',markerDriver!);
        animateCameraToPosition(_position.latitude, _position.longitude);
      });
    }
    catch(error){
      print('Error en la localizacion: $error');
    }
  }

  void centerPosition(){
    if(_position != null)
    {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
    else
      {
        /*Fluttertoast.showToast(
            msg: "Activa gps para obtener la posicion",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if(controller != null)
      {
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(bearing: 0,
            target: LatLng(latitude, longitude),
              zoom: 17
            )
        ));
      }
  }

  Future<BitmapDescriptor> createMakerImageFromAsset(String path) async
  {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapHelper = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapHelper;
    //markerDriver =
  }

  void addMarker(String markerId, double lat, double lng, String title, String content, BitmapDescriptor iconMarker)
  {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(markerId: id, icon: iconMarker, position: LatLng(lat,lng), infoWindow: InfoWindow(title: title, snippet: content), draggable: false, zIndex: 2, flat: true, anchor: Offset(0.5,0.5), rotation: _position.heading);
    markers[id] = marker;
  }


  void openDrawer()
  {
    key.currentState?.openDrawer();

  }

}

