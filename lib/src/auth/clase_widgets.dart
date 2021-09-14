import 'package:flutter/material.dart';

  

  




Widget apPatField(){
  return TextField(
    obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Contraseña',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );
}


Widget apMatField(){
  return TextField(
    obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Contraseña',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );
}

