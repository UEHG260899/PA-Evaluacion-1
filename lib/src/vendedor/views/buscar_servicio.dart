import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BuscarServicio extends StatefulWidget {
  BuscarServicio({Key? key}) : super(key: key);

  @override
  _BuscarServicioState createState() => _BuscarServicioState();
}

class _BuscarServicioState extends State<BuscarServicio> {
  List<Servicio>? servicios;

  //Controllers
  TextEditingController? busquedaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicios = [];
    busquedaController = new TextEditingController();
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
                  child: TextButton(
                child: Text('Hola'),
                onPressed: () {},
              )),
            ],
          ),
          Container(
            height: 400.0,
            child: ListView.builder(
              itemCount: servicios!.length,
              padding: const EdgeInsets.only(top: 20.0),
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    Card(
                      child: Text('Hola'),
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
}
