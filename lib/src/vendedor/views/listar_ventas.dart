import 'package:evaluacion_1/src/vendedor/views/tabs/listar_v_conf.dart';
import 'package:evaluacion_1/src/vendedor/views/tabs/listar_v_pendientes.dart';
import 'package:flutter/material.dart';

class TabsVentas extends StatefulWidget {
  TabsVentas({Key? key}) : super(key: key);

  @override
  _TabsVentasState createState() => _TabsVentasState();
}

class _TabsVentasState extends State<TabsVentas> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text('Ventas Pendientes'),
              Text('Ventas Confirmadas'),
            ],
          ),
        ),
        body: TabBarView(children: [ListaVentasPend(), ListaVentasConf()]),
      ),
    );
  }
}
