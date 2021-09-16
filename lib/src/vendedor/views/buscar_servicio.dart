import 'dart:async';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BuscarServicio extends StatefulWidget {
  BuscarServicio({Key? key}) : super(key: key);

  @override
  _BuscarServicioState createState() => _BuscarServicioState();
}

class _BuscarServicioState extends State<BuscarServicio> {
  List<Servicio>? servicios;
  StreamSubscription<Event>? addServicio;

  //Instancias de Firebase
  final _dbRef = FirebaseDatabase.instance.reference().child('servicios');

  //Controllers
  TextEditingController? busquedaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicios = [];
    addServicio = _dbRef.onChildAdded.listen(_addServicio);
    busquedaController = new TextEditingController();
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
        body: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: campoBusqueda()),
              Expanded(
                  child: IconButton(
                    onPressed: () =>_buscarServicio(busquedaController!.text),
                    icon: Icon(Icons.search),
                  ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: servicios!.length,
              padding: const EdgeInsets.only(top: 20.0),
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    Card(
                      elevation: 10.0,
                      child: Row(
                        children: [
                          SizedBox(
                              height: 150.0,
                              width: 100.0,
                              child: FadeInImage(
                                image: NetworkImage(
                                    "${servicios![position].imgUrl}"),
                                placeholder: AssetImage("assets/loading.png"),
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            children: [
                              Text('${servicios?[position].nombre}'),
                              Text('\$${servicios?[position].precio}'),
                            ],
                          ),
                          SizedBox(
                            width: 100.0,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    ));
  }

  Widget campoBusqueda() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: busquedaController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Busqueda',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  //Metodos aparte
  _addServicio(Event event) {
    setState(() {
      servicios!.add(new Servicio.fromSnapshot(event.snapshot));
    });
  }

  _buscarServicio(String texto){
    if(texto.isEmpty){
      customSnack('Favor de introducir un termino de busqueda');
    }else{
      _dbRef.get().then((DataSnapshot snapshot) {
        servicios!.clear();
        var llaves = snapshot.value.keys;
        var valores = snapshot.value;

        for(var llave in llaves){
          Servicio servicio = new Servicio(
            llave,
            valores[llave]['nombre'],
            valores[llave]['descripcion'],
            valores[llave]['noContacto'],
            valores[llave]['latitud'],
            valores[llave]['longitud'],
            valores[llave]['imgUrl'],
            valores[llave]['precio'],
            valores[llave]['correoVend'],
            valores[llave]['status'],
          );

          if(servicio.nombre!.contains(texto)){
            servicios!.add(servicio);
          }

          setState(() {
            
          });
        }
      });
    }
  }

  void customSnack(String texto) {
    final snack = SnackBar(
      content: Text('$texto'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
