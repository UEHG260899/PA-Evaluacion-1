import 'package:evaluacion_1/src/comprador/views/tabs/lista_carrito.dart';
import 'package:evaluacion_1/src/comprador/views/tabs/lista_confirmadas.dart';
import 'package:flutter/material.dart';


class TabsCompras extends StatefulWidget {
  TabsCompras({Key? key}) : super(key: key);

  @override
  _TabsComprasState createState() => _TabsComprasState();
}

class _TabsComprasState extends State<TabsCompras> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Carrito'
              ),
              Tab(
                text: 'Confirmadas',
              )
            ],
          ),
        ),
        body: TabBarView(children: [ListaCarrito(), ListadoConfirmadas()],),
      ),
    );
  }
}