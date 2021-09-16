import 'dart:async';

import 'package:evaluacion_1/src/comprador/models/Compra.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ListaVentasPend extends StatefulWidget {
  ListaVentasPend({Key? key}) : super(key: key);

  @override
  _ListaVentasPendState createState() => _ListaVentasPendState();
}

class _ListaVentasPendState extends State<ListaVentasPend> {
  
  
  List<Compra>? compras;
  DateTime? fechaEntrega;
  StreamSubscription<Event>? addCompra;
  
  final _carritoRef = FirebaseDatabase.instance.reference().child('compras').orderByChild('statusVenta').equalTo('pendiente');
  final _dbRef = FirebaseDatabase.instance.reference().child('compras');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compras = [];
    addCompra = _carritoRef.onChildAdded.listen(_addVenta);
  }

  @override
  void dispose() {
    addCompra!.cancel();
    super.dispose();
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
                          SizedBox(
                            width: 60.0,
                          ),
                          TextButton(
                            child: Text('Confirmar'),
                            onPressed: () => _confirmar(compras![position]),
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

  //Metodos
  _addVenta(Event evento){
    setState(() {
      compras!.add(new Compra.fromSnapshot(evento.snapshot));
    });
  }

  _confirmar(Compra compra) async {
     fechaEntrega = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2025),
      helpText: "Fecha de entrega"
    );

    if(fechaEntrega != null){
      _dbRef.child(compra.id!).set({
      'correoComprador' : compra.correoComprador,
      'correoVend' : compra.correoVend,
      'fechaProbableEntrega' : fechaEntrega.toString().split(' ')[0],
      'servicio' : compra.servicio!.toJson(),
      'statusCompra' : compra.statusCompra,
      'statusVenta' : 'confirmada'
    }).then((value){
      setState(() {
        compras!.removeAt(compras!.indexOf(compra));
      });
    });
    }
  }
}
