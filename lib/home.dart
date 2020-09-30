import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position = CameraPosition(target: LatLng(-24.720739, -53.713464), zoom: 10);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  _onMapCreate(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _recuperarLocalizacao() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Marker marker = Marker(
      markerId: MarkerId("marker"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Posicao: '+position.latitude.toString() +' - '+ position.longitude.toString()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      _position = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 10);
      markers[MarkerId("marker")] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Geolocalização"),),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _position,
          onMapCreated: _onMapCreate,
          markers: Set<Marker>.of(markers.values)
        ),
      ),
    );
  }
}
