import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';

class EditarServicio extends StatefulWidget {
  final Servicio servicio;
  EditarServicio(this.servicio);

  @override
  _EditarServicioState createState() => _EditarServicioState();
}

class _EditarServicioState extends State<EditarServicio> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController? nombreController;
  TextEditingController? descripController;
  TextEditingController? noContactoController;
  TextEditingController? precioController;
  String? latitud;
  String? longitud;
  String? imgUrlVieja;
  bool bandera = false;
  File? imageFile;
  PickedFile? pickFile;

  //Instancias de Firebase
  final _dbRef = FirebaseDatabase.instance.reference().child('servicios');
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombreController = new TextEditingController(text: widget.servicio.nombre);
    descripController =
        new TextEditingController(text: widget.servicio.descripcion);
    noContactoController =
        new TextEditingController(text: widget.servicio.noContacto);
    precioController = new TextEditingController(text: widget.servicio.precio);
    latitud = widget.servicio.latitud;
    longitud = widget.servicio.longitud;
    imgUrlVieja = widget.servicio.imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edición de registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageCard(imageFile),
                  SizedBox(
                    height: 26.0,
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
                  SizedBox(height: 26.0),
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
                  btnEditar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Widgets
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

  Widget mapaView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(latitud!), double.parse(longitud!)),
        zoom: 15.0,
      ),
      mapType: MapType.normal,
    );
  }

  Widget btnEditar() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => _registrar(),
        child: Text("Editar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget imageCard(File? imageFile) {
    return GestureDetector(
      onTap: () => _showAlert(),
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
                  child: FadeInImage(
                    image: NetworkImage("${widget.servicio.imgUrl}"),
                    placeholder: AssetImage("assets/loading.png"),
                  )),
            ),
    );
  }

  //Funciones aparte
  _registrar() async {
    int resultado = validaciones();
    if (resultado != 1) {
      customSnack('No puede haber campos vacios');
    } else {
      if (bandera) {
        TaskSnapshot snapshot = await subirArchivo(pickFile!);
        String imageUrl = await snapshot.ref.getDownloadURL();
        _dbRef.child(widget.servicio.id!).set({
          'nombre': nombreController!.text,
          'descripcion': descripController!.text,
          'noContacto': noContactoController!.text,
          'latitud': latitud,
          'longitud': longitud,
          'imgUrl': imageUrl,
          'precio': precioController!.text,
          'correoVend': _auth.currentUser!.email,
          'status': 'activo'
        }).then((value) => Navigator.of(context).pop());
      }else{
        _dbRef.child(widget.servicio.id!).set({
          'nombre': nombreController!.text,
          'descripcion': descripController!.text,
          'noContacto': noContactoController!.text,
          'latitud': latitud,
          'longitud': longitud,
          'imgUrl': imgUrlVieja,
          'precio': precioController!.text,
          'correoVend': _auth.currentUser!.email,
          'status': 'activo'
        }).then((value) => Navigator.of(context).pop());
      }
    }
  }

  void _showAlert() {
    Widget galleryButton = ElevatedButton(
      onPressed: () => _seleccionarImagen(ImageSource.gallery),
      child: Text('Galeria'),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () => _seleccionarImagen(ImageSource.camera),
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

  Future _seleccionarImagen(ImageSource imgSrc) async {
    bandera = true;
    pickFile = await ImagePicker().getImage(source: imgSrc);
    if (imgSrc != null) {
      imageFile = File(pickFile!.path);
    }

    Navigator.of(context).pop();

    setState(() {});
  }

  Future<TaskSnapshot> subirArchivo(PickedFile file) async {
    String nombre = '${UniqueKey().toString()}.jpg';

    Reference ref =
        FirebaseStorage.instance.ref().child('servicios').child('/$nombre');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    UploadTask uploadTask = ref.putFile(File(file.path), metadata);
    return uploadTask;
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
}
