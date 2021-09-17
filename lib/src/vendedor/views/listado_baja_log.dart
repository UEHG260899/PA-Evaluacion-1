import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';

class ListadoBaja extends StatefulWidget {
  ListadoBaja({Key? key}) : super(key: key);

  @override
  _ListadoBajaState createState() => _ListadoBajaState();
}

class _ListadoBajaState extends State<ListadoBaja> {
  List<Servicio>? servicios;
  StreamSubscription<Event>? addServicio;

  //Instancias firebase
  final _inactivosRef = FirebaseDatabase.instance
      .reference()
      .child('servicios')
      .orderByChild('status')
      .equalTo('inactivo');

  final _dbRef = FirebaseDatabase.instance.reference().child('servicios');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicios = [];

    addServicio = _inactivosRef.onChildAdded.listen(_addServicio);
  }

  @override
  void dispose() {
    addServicio!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: servicios!.length,
        padding: EdgeInsets.only(top: 12.0),
        itemBuilder: (context, position) {
          return Column(
            children: [
              Card(
                child: Row(
                  children: [
                    SizedBox(
                      height: 150.0,
                      width: 100.0,
                      child: FadeInImage(
                         image: NetworkImage("${servicios![position].imgUrl}"),
                         placeholder: AssetImage("assets/loading.png"),
                      )
                    ),
                    SizedBox(width: 20.0,),
                    Column(
                      children: [
                        Text("${servicios![position].nombre}"),
                        Text("\$${servicios![position].precio}")
                      ],
                    ),
                    SizedBox(width: 10.0,),
                    TextButton(onPressed: () => _openModal(servicios![position], position), child: Text('Eliminar', style: TextStyle(color: Colors.red),)),
                    TextButton(onPressed: () => _activarServicio(servicios![position]), child: Text('Activar', style: TextStyle(color: Colors.green),)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  //Metodos aparte
  _addServicio(Event evento){
    setState(() {
      servicios!.add(new Servicio.fromSnapshot(evento.snapshot));
    });
  }

  _openModal(Servicio servicio, int pos){

    Widget btnAceptar = new TextButton(
      onPressed: () => _borrarServicio(servicio, pos),
      child: Text('Aceptar'),
    );

    Widget btnCancelar = new TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('Cancelar'),
    );    
    
    AlertDialog alerta = new AlertDialog(
      title: Text('Esta seguro que desea borrar al registro?'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Nombre: ${servicio.nombre}'),
            Text('Precio: \$${servicio.precio}'),
            Text('Descripción: ${servicio.descripcion}'),
            Text('No. Contacto ${servicio.noContacto}'),
          ],
        ),
      ),
      actions: [btnAceptar, btnCancelar],
    );

    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return alerta;
      }
    );

    
  }

  _borrarServicio(Servicio servicio, int pos) async{
    await _dbRef.child(servicio.id!).remove().then((value){
      Navigator.of(context).pop();
      setState(() {
        servicios!.removeAt(pos);
      });
    });
  }

  _activarServicio(Servicio servicio){
    _dbRef.child(servicio.id!).set({
      'nombre' : servicio.nombre,
      'latitud' : servicio.latitud,
      'longitud' : servicio.longitud,
      'correoVend' : servicio.correoVend,
      'imgUrl' : servicio.imgUrl,
      'noContacto' : servicio.noContacto,
      'precio' : servicio.precio,
      'descripcion' : servicio.descripcion,
      'status' : 'activo'
    }).then((value){
      setState(() {
        servicios!.removeAt(servicios!.indexOf(servicio));
      });
    });
  }
}
