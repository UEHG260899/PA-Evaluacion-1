import 'dart:async';

import 'package:evaluacion_1/src/comprador/models/Compra.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ListadoConfirmadas extends StatefulWidget {
  ListadoConfirmadas({Key? key}) : super(key: key);

  @override
  _ListadoConfirmadasState createState() => _ListadoConfirmadasState();
}

class _ListadoConfirmadasState extends State<ListadoConfirmadas> {
  
  List<Compra>? compras;
  StreamSubscription<Event>? addCompra;

  final _carritoRef = FirebaseDatabase.instance.reference().child('compras').orderByChild('statusCompra').equalTo('confirmada');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compras = [];
    addCompra = _carritoRef.onChildAdded.listen(_addCompra);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: compras!.length,
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
                                    "${compras![position].servicio!.imgUrl}"),
                                placeholder: AssetImage("assets/loading.png"),
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            children: [
                              Text('${compras?[position].servicio!.nombre}'),
                              Text('\$${compras?[position].servicio!.precio}'),
                              Text(
                                  'Envio: ${compras![position].fechaProbableEntrega}'),
                            ],
                          ),
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


  //metodos
  _addCompra(Event evento){
    print('Entra');
    setState(() {
      compras!.add(new Compra.fromSnapshot(evento.snapshot));
    });
  }
}
