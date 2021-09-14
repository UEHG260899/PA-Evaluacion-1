import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerComprador extends StatefulWidget {
  DrawerComprador({Key? key}) : super(key: key);

  @override
  _DrawerCompradorState createState() => _DrawerCompradorState();
}

class _DrawerCompradorState extends State<DrawerComprador> {
  
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
                accountName: Text('Uriel E.'), 
                accountEmail: Text('ejemplo@gmail.com')
            ),
            ListTile(
              title: Text('Hola'),
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
