import 'dart:async';

import 'package:evaluacion_1/src/comprador/views/screen_servicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';

class ListadoServicios extends StatefulWidget {
  ListadoServicios({Key? key}) : super(key: key);

  @override
  _ListadoServiciosState createState() => _ListadoServiciosState();
}

class _ListadoServiciosState extends State<ListadoServicios> {
  List<Servicio>? servicios;
  StreamSubscription<Event>? addServicio;
  StreamSubscription<Event>? changeServicio;

  //Instancias de firebase
  final _dbRef = FirebaseDatabase.instance
      .reference()
      .child('servicios')
      .orderByChild('status')
      .equalTo('activo');
  final _comprasRef = FirebaseDatabase.instance.reference().child('compras');
  final _auth = FirebaseAuth.instance;

  TextEditingController? busquedaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicios = [];
    busquedaController = new TextEditingController();
    addServicio = _dbRef.onChildAdded.listen(_addServicio);
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: campoBusqueda()),
              Expanded(
                child: IconButton(
                  onPressed: () => _buscarServicio(busquedaController!.text),
                  icon: Icon(Icons.search),
                ),
              ),
            ],
          ),
          Expanded(
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
                          IconButton(
                            onPressed: () =>
                                _agregarCarro(servicios![position]),
                            icon: Icon(Icons.shopping_cart),
                          ),
                          IconButton(
                            onPressed: () => _verServicio(servicios![position]),
                            icon: Icon(Icons.remove_red_eye),
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
    );
  }

  //Widgets
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
  _addServicio(Event evento) {
    setState(() {
      servicios!.add(new Servicio.fromSnapshot(evento.snapshot));
    });
  }

  _buscarServicio(String texto) {
    if (texto.isEmpty) {
      customSnack('Favor de introducir un termino de busqueda');
    } else {
      _dbRef.get().then((DataSnapshot snapshot) {
        servicios!.clear();
        var llaves = snapshot.value.keys;
        var valores = snapshot.value;

        for (var llave in llaves) {
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

          if (servicio.nombre!.contains(texto)) {
            servicios!.add(servicio);
          }

          setState(() {});
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

  _verServicio(Servicio servicio) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (constext) => ScreenServicio(servicio)));
  }

  _agregarCarro(Servicio servicio) async {
    await _comprasRef.push().set({
      'servicio': servicio.toJson(),
      'correoComprador': _auth.currentUser!.email,
      'correoVend': servicio.correoVend,
      'statusCompra': 'pendiente',
      'statusVenta': '',
      'fechaProbableEntrega': 'pendiente'
    }).then((value) {
      customSnack('Se agregó al carrito');
    });
  }
}
