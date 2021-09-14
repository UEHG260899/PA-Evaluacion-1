import 'package:flutter/material.dart';

class VendedroDrawer extends StatefulWidget {
  VendedroDrawer({Key? key}) : super(key: key);

  @override
  _VendedroDrawerState createState() => _VendedroDrawerState();
}

class _VendedroDrawerState extends State<VendedroDrawer> {
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
    );
  }
}