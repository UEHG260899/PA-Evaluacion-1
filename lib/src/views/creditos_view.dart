import 'package:flutter/material.dart';


class CreditosView extends StatelessWidget {
  const CreditosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Créditos',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              'Desarrollador: Uriel Enrique Hernández González',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Profesora: Rocio Elizabeth Pulido Alba',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Materia: Programación Avanzada de Dispositivos Móviles',
              style: TextStyle(fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}