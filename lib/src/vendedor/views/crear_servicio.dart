import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
  PickedFile? pickFile;

  Position? position;
  Completer<GoogleMapController> mapController = new Completer();

  //Controllers
  TextEditingController? nombreController;
  TextEditingController? descripController;
  TextEditingController? noContactoController;
  TextEditingController? precioController;
  File? imageFile;

  //Instancias de Firebase
  final DatabaseReference _serviciosRef = FirebaseDatabase.instance.reference().child('servicios');
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  imagecard(imageFile),
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
                  SizedBox(
                    height: 26.0,
                  ),
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
        onPressed: () => registrar(),
        child: Text("Crear Servicio",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget mapaView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
      ),
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) =>
          mapController.complete(controller),
    );
  }

  Widget imagecard(File? imageFile) {
    return GestureDetector(
      onTap: () => showAlert(),
      child: (imageFile != null)
          ? Card(
              child: Container(
                height: 150.0,
                child: Image.file(imageFile),
              ),
            )
          : Card(
              child: Container(
                height: 150.0,
                child: Image.asset(
                  "assets/product_placeholder.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
    );
  }
  //metodos aparte

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

  void showAlert() {
    Widget galleryButton = ElevatedButton(
      onPressed: () => seleccionarImagen(ImageSource.gallery),
      child: Text('Galeria'),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () => seleccionarImagen(ImageSource.camera),
      child: Text('Camara'),
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Seleccione una opcion'),
      actions: [cameraButton, galleryButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  Future seleccionarImagen(ImageSource imgSrc) async {
    pickFile = await ImagePicker().getImage(source: imgSrc);
    if (imgSrc != null) {
      imageFile = File(pickFile!.path);
    }

    Navigator.of(context).pop();

    setState(() {});
  }

  int validaciones() {
    if (nombreController!.text.isEmpty ||
        descripController!.text.isEmpty ||
        noContactoController!.text.isEmpty ||
        precioController!.text.isEmpty) {
      return 0;
    }
    return 1;
  }

  void customSnack(String texto) {
    final snack = SnackBar(
      content: Text('$texto'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  registrar() async{
    int resultado = validaciones();
    if (resultado != 1) {
      customSnack('No puede haber campos vacios');
    } else {
      TaskSnapshot snapshot = await subirArchivo(pickFile!);
      String imageUrl = await snapshot.ref.getDownloadURL();
      _location.getLocation().then((value) {
        _locationData = value;
        lat = _locationData.latitude.toString();
        long = _locationData.longitude.toString();
        _serviciosRef.push().set({
          'nombre' : nombreController!.text,
          'descripcion' : descripController!.text,
          'noContacto' : noContactoController!.text,
          'latitud' : lat,
          'longitud' : long,
          'imgUrl' : imageUrl,
          'precio' : precioController!.text,
          'correoVend' : _auth.currentUser!.email
        }).then((value){
          nombreController!.text = '';
          precioController!.text = '';
          descripController!.text = '';
          noContactoController!.text = '';
          lat = '';
          long = '';
          imageFile = null;
        });

      });
    }
  }

  Future<TaskSnapshot> subirArchivo(PickedFile file) async {
    String nombre = '${UniqueKey().toString()}.jpg';

    Reference ref = FirebaseStorage.instance.ref().child('servicios').child('/$nombre');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path':file.path}
    );

    UploadTask uploadTask = ref.putFile(File(file.path), metadata);
    return uploadTask;
  }
}
