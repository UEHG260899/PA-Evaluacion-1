import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class CrearServicio extends StatefulWidget {
  CrearServicio({Key? key}) : super(key: key);

  @override
  _CrearServicioState createState() => _CrearServicioState();
}

class _CrearServicioState extends State<CrearServicio> {
  //Estilos
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  Location _location = Location();
  late LocationData _locationData;
  String? lat;
  String? long;

  Position? position;
  Completer<GoogleMapController> mapController = new Completer();

  //Controllers
  TextEditingController? nombreController;
  TextEditingController? descripController;
  TextEditingController? noContactoController;
  TextEditingController? precioController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombreController = new TextEditingController();
    descripController = new TextEditingController();
    noContactoController = new TextEditingController();
    precioController = new TextEditingController();
    this.localizacion();
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      "assets/product_placeholder.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 26.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Agrega información de tu servicio',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  nombreField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  descripField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  contactoField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  precioField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  Container(
                    child: Stack(
                      children: [
                        mapaView(),
                        Container(
                          child: Icon(Icons.location_history),
                          alignment: Alignment.center,
                        )
                      ],
                    ),
                    height: 200.0,
                  ),
                  SizedBox(height: 26.0,),
                  btnCrear(),
                ]),
          ),
        ),
      ),
    );
  }

  Widget nombreField() {
    return TextField(
      controller: nombreController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Nombre del servicio',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget descripField() {
    return TextField(
      controller: descripController,
      keyboardType: TextInputType.text,
      maxLines: 3,
      maxLength: 255,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Descripción del texto',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget contactoField() {
    return TextField(
      controller: noContactoController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Número de contacto',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget precioField() {
    return TextField(
      controller: precioController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Precio',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget btnCrear() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Crear Servicio",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget mapaView() {
    _location.getLocation().then((value) {
      _locationData = value;
      lat = _locationData.latitude.toString();
      long = _locationData.longitude.toString();
      print(long);
      print(lat);
    });

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
      ),
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) =>
          mapController.complete(controller),
    );
  }

  Future animarCamara(double lat, double long) async {
    GoogleMapController controller = await mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 16.0)));
    }
  }

  localizacion() async {
    position = await Geolocator.getCurrentPosition();
    animarCamara(position!.latitude, position!.longitude);
  }
}
