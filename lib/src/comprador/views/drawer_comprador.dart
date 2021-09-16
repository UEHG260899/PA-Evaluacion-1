import 'package:evaluacion_1/src/views/creditos_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:evaluacion_1/src/comprador/views/listado_servicios.dart';
import 'package:evaluacion_1/src/comprador/views/tabs_carrito.dart';
import 'package:evaluacion_1/src/auth/views/login_view.dart';

class DrawerComprador extends StatefulWidget {
  DrawerComprador({Key? key}) : super(key: key);

  @override
  _DrawerCompradorState createState() => _DrawerCompradorState();
}

class _DrawerCompradorState extends State<DrawerComprador> {
  
  //Instancias de firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedItem = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido!'),
        actions: [
          GestureDetector(
            child: Container(
              child: Icon(Icons.logout),
            ),
            onTap: () => _logOut(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text('${_auth.currentUser!.displayName}'), 
                accountEmail: Text('${_auth.currentUser!.email}'),
            ),
            ListTile(
              title: Text('Inicio'),
              leading: Icon(Icons.home),
              selected: (0 == _selectedItem),
            ),
            ListTile(
              title: Text('Ver Servicios'),
              leading: Icon(Icons.search),
              selected: (1 == _selectedItem),
              onTap: () => _onItemSelect(1),
            ),
            ListTile(
              title: Text('Mis compras'),
              leading: Icon(Icons.shopping_cart),
              selected: (2 == _selectedItem),
              onTap: () => _onItemSelect(2),
            ),
            ListTile(
              title: Text('Créditos'),
              leading: Icon(Icons.info),
              selected: (3 == _selectedItem),
              onTap: () => _onItemSelect(3),
            )
          ],
        ),
      ),
      body: _getDrawerItem(_selectedItem),
    );
  }

  //Métodos aparte

  _logOut(){
    _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginView()),
              (route) => false);
  }

  _getDrawerItem(int pos){
    switch(pos){
      case 1: return ListadoServicios();
      case 2: return TabsCompras();
      case 3: return CreditosView();
    }
  }

  _onItemSelect(int pos){
    setState(() {
      _selectedItem = pos;
    });
    Navigator.pop(context);
  }
}
