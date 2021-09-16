import 'package:flutter/material.dart';

import 'package:evaluacion_1/src/vendedor/views/listado_activos.dart';
import 'package:evaluacion_1/src/vendedor/views/listado_baja_log.dart';

class TabsListado extends StatelessWidget {
  const TabsListado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.add),
                text: 'Listado Activos',
              ),
              Tab(
                icon: Icon(Icons.delete),
                text: 'Listado de bajas lógicas',
              )
            ],
          )
        ),
        body: TabBarView(
          children: [ListadoActivos(), ListadoBaja()],
        ),
      ),
    );
  }
}