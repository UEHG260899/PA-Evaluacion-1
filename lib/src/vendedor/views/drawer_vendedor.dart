import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class VendedorDrawer extends StatefulWidget {
  VendedorDrawer({Key? key}) : super(key: key);

  @override
  _VendedorDrawerState createState() => _VendedorDrawerState();
}

class _VendedorDrawerState extends State<VendedorDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido!'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text('${_auth.currentUser!.displayName}'), 
                accountEmail: Text('ejemplo@gmail.com')
            ),
            ListTile(
              title: Text('Hola Vendedor'),
            ),
            ListTile(
              title: Text('Hola2'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _auth.signOut(),
      ),
    );
  }
}