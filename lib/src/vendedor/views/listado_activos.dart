import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';

class ListadoActivos extends StatefulWidget {
  ListadoActivos({Key? key}) : super(key: key);

  @override
  _ListadoActivosState createState() => _ListadoActivosState();
}

class _ListadoActivosState extends State<ListadoActivos> {
  List<Servicio>? servicios;
  StreamSubscription<Event>? addServicio;  


  //Instancias Firebase
  final  _serviciosRef = FirebaseDatabase.instance.reference().child('servicios').orderByChild('status').equalTo('activo');
  final _dbRef = FirebaseDatabase.instance.reference().child('servicios');
  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicios = [];

    addServicio = _serviciosRef.onChildAdded.listen(_addServicio);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addServicio!.cancel();
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
                       child: FadeInImage(
                         image: NetworkImage("${servicios![position].imgUrl}"),
                         placeholder: AssetImage("assets/loading.png"),
                       )
                     ),
                     SizedBox(width: 10.0,),
                     Column(
                       children: [
                         Text('${servicios?[position].nombre}'),
                         Text('\$${servicios?[position].precio}'),
                       ],
                     ),
                     SizedBox(width: 10.0,),
                     TextButton(onPressed: () => _openModal(servicios![position], position), child: Text('Eliminar', style: TextStyle(color: Colors.red),),),
                     TextButton(onPressed: () => _desactivarServicio(servicios![position]), child: Text('Baja lógica', style: TextStyle(color: Colors.orange),)),
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



  _openModal(Servicio servicio, int pos){

    Widget btnAceptar = new TextButton(
      onPressed: () => _borrarRegistro(servicio, pos),
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

  _borrarRegistro(Servicio servicio, int pos) async {
    await _dbRef.child(servicio.id!).remove().then((value){
      Navigator.of(context).pop();
      setState(() {
        servicios!.removeAt(pos);
      });
    });
  }
  
  _desactivarServicio(Servicio servicio){
    _dbRef.child(servicio.id!).set({
      'nombre' : servicio.nombre,
      'latitud' : servicio.latitud,
      'longitud' : servicio.longitud,
      'correoVend' : servicio.correoVend,
      'imgUrl' : servicio.imgUrl,
      'noContacto' : servicio.noContacto,
      'precio' : servicio.precio,
      'descripcion' : servicio.descripcion,
      'status' : 'inactivo'
    }).then((value){
      Navigator.of(context).pop();
      setState(() {
        servicios!.removeAt(servicios!.indexOf(servicio));
      });
    });
  }


}