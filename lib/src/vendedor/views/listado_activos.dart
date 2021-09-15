import 'dart:async';

import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';

class ListadoActivos extends StatefulWidget {
  ListadoActivos({Key? key}) : super(key: key);

  @override
  _ListadoActivosState createState() => _ListadoActivosState();
}

class _ListadoActivosState extends State<ListadoActivos> {
  List<Servicio>? servicios;
  StreamSubscription<Event>? addAlumnos;


  //Instancias Firebase
  final  String? email = FirebaseAuth.instance.currentUser!.email;
  final  _serviciosRef = FirebaseDatabase.instance.reference().child('servicios').orderByChild('status').equalTo('activo');
  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicios = [];

    addAlumnos = _serviciosRef.onChildAdded.listen(_addServicio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ListView.builder(
         itemCount: servicios!.length,
         padding: EdgeInsets.only(top: 12.0),
         itemBuilder: (context, position){
           return Column(
             children: [
               Divider(height: 7.0,),
               Card(
                 child: Row(
                   children: [
                     SizedBox(
                       height: 150.0,
                       width: 100.0,
                       child: Image.asset(
                         "assets/login.png",
                         fit: BoxFit.contain,
                       ),
                     ),
                     Column(
                       children: [
                         Text('${servicios?[position].nombre}'),
                         Text('\$${servicios?[position].precio}'),
                       ],
                     ),
                     TextButton(onPressed: (){}, child: Text('Hola'))
                   ],
                 ),
               )
             ],
           );
         },
       ),
    );
  }

  _addServicio(Event evento){
    setState(() {
      servicios!.add(new Servicio.fromSnapshot(evento.snapshot));
    });
  }
}