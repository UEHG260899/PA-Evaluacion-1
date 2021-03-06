import 'package:evaluacion_1/src/vendedor/views/buscar_servicio.dart';
import 'package:evaluacion_1/src/vendedor/views/listado_tabs.dart';
import 'package:evaluacion_1/src/vendedor/views/listar_ventas.dart';
import 'package:evaluacion_1/src/views/creditos_view.dart';
import 'package:evaluacion_1/src/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:evaluacion_1/src/auth/views/login_view.dart';
import 'package:evaluacion_1/src/vendedor/views/crear_servicio.dart';

class VendedorDrawer extends StatefulWidget {
  VendedorDrawer({Key? key}) : super(key: key);

  @override
  _VendedorDrawerState createState() => _VendedorDrawerState();
}

class _VendedorDrawerState extends State<VendedorDrawer> {
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
            onTap: () => logOut(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text('${_auth.currentUser!.displayName}'), 
                accountEmail: Text('${_auth.currentUser!.email}')
            ),
            ListTile(
              title: Text('Inicio'),
              leading: Icon(Icons.home_filled),
              selected: (0 == _selectedItem),
              onTap: () => onItemSelect(0),
            ),
            ListTile(
              title: Text('Crear un servicio'),
              leading: Icon(Icons.add),
              selected: (1 == _selectedItem),
              onTap: () => onItemSelect(1),
            ),
            ListTile(
              title: Text('Editar un servicio'),
              leading: Icon(Icons.edit),
              selected: (2 == _selectedItem),
              onTap: () => onItemSelect(2),
            ),
            ListTile(
              title: Text('Bajas de Servicios'),
              leading: Icon(Icons.delete),
              selected: (3 == _selectedItem),
              onTap: () => onItemSelect(3),
            ),
            ListTile(
              title: Text('Estatus de Ventas'),
              leading: Icon(Icons.shopping_cart),
              selected: (4 == _selectedItem),
              onTap: () => onItemSelect(4),
            ),
            Divider(),
            ListTile(
              title: Text('Cr??ditos'),
              leading: Icon(Icons.info),
              selected: (5 == _selectedItem),
              onTap: () => onItemSelect(5),
            )
          ],
        ),
      ),
      body: getDrawerItem(_selectedItem),
    );
  }


  //Funciones aparte
  logOut(){
    _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginView()),
              (route) => false);
  }

  getDrawerItem(int pos){
    switch(pos){
      case 0: return HomeView();
      case 1: return CrearServicio();
      case 2: return BuscarServicio();
      case 3: return TabsListado();
      case 4: return TabsVentas();
      case 5: return CreditosView();
    }
  }

  onItemSelect(int pos){
    setState(() {
      _selectedItem = pos;
    });
    Navigator.pop(context);
  }
}