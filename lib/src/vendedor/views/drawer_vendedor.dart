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
            ),
            ListTile(
              title: Text('Bajas de Servicios'),
              leading: Icon(Icons.delete),
            ),
            Divider(),
            ListTile(
              title: Text('Créditos'),
              leading: Icon(Icons.info),
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
      case 1: return CrearServicio();
    }
  }

  onItemSelect(int pos){
    setState(() {
      _selectedItem = pos;
    });
    Navigator.pop(context);
  }
}