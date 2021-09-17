import 'dart:async';

import 'package:evaluacion_1/src/comprador/models/Compra.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ListaCarrito extends StatefulWidget {
  ListaCarrito({Key? key}) : super(key: key);

  @override
  _ListaCarritoState createState() => _ListaCarritoState();
}

class _ListaCarritoState extends State<ListaCarrito> {

  List<Compra>? compras;
  StreamSubscription<Event>? addCompra;
  
  final _carritoRef = FirebaseDatabase.instance.reference().child('compras').orderByChild('statusCompra').equalTo('pendiente');
  final _dbRef = FirebaseDatabase.instance.reference().child('compras');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compras = [];
    addCompra = _carritoRef.onChildAdded.listen(_addCompra);
  }

  @override
  void dispose() {
    super.dispose();
    addCompra!.cancel();
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
                              Text('Envio: ${compras![position].fechaProbableEntrega}'),
                            ],
                          ),
                          SizedBox(
                            width: 60.0,
                          ),
                          TextButton(onPressed: () => _confirmarPedido(compras![position]), child: Text('Confirmar')),
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

  //Funciones
  _addCompra(Event evento){
    print('Entra');
    setState(() {
      compras!.add(new Compra.fromSnapshot(evento.snapshot));
    });
  }


  _confirmarPedido(Compra compra){
    _dbRef.child(compra.id!).set({
      'correoComprador' : compra.correoComprador,
      'correoVend' : compra.correoVend,
      'fechaProbableEntrega' : compra.fechaProbableEntrega,
      'servicio' : compra.servicio!.toJson(),
      'statusCompra' : 'confirmada',
      'statusVenta' : 'pendiente'
    }).then((value){
      setState(() {
        compras!.removeAt(compras!.indexOf(compra));
      });
    });
  }
}
