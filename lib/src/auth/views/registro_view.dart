import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegistroView extends StatefulWidget {
  RegistroView({Key? key}) : super(key: key);

  @override
  _RegistroViewState createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String dropDownRole = "Seleccione un rol";

  //Controllers
  TextEditingController? emailController;
  TextEditingController? userController;
  TextEditingController? passController;
  TextEditingController? confPassController;

  //Instancias firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = new TextEditingController();
    userController = new TextEditingController();
    passController = new TextEditingController();
    confPassController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150.0,
                    child: Image.asset(
                      "assets/register.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Necesitamos algunos de sus datos para continuar',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  userField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  emailField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  passField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  confPassField(),
                  SizedBox(
                    height: 26.0,
                  ),
                  roleSelect(),
                  SizedBox(
                    height: 26.0,
                  ),
                  registroBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userField() {
    return TextField(
      controller: userController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Nombre de usuario',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget emailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Correo Electrónico',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget passField() {
    return TextField(
      controller: passController,
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Contraseña',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget confPassField() {
    return TextField(
      controller: confPassController,
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Confirmar contraseña',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget roleSelect() {
    return DropdownButton(
      value: dropDownRole,
      underline: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String? nuevoRol) {
        setState(() {
          dropDownRole = nuevoRol!;
        });
        print(dropDownRole);
      },
      items: <String>['Seleccione un rol', 'Vendedor', 'Comprador']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget registroBtn() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => registrar(),
        child: Text("Registro",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  //Metodos aparte

  registrar() async {
    int result = validaciones();
    if (result == 0) {
      try {
        _auth.createUserWithEmailAndPassword(
            email: emailController!.text, password: passController!.text);
        if (dropDownRole == 'Vendedor') {
          _dbRef.child('vendedores').push().set({
            'user': userController!.text,
            'email': emailController!.text
          }).then((value) {
            emailController!.text = '';
            passController!.text = '';
            confPassController!.text = '';
            userController!.text = '';
            setState(() {
              dropDownRole = 'Seleccione un rol';
            });
          });
        } else {
          _dbRef.child('compradores').push().set({
            'user': userController!.text,
            'email': emailController!.text
          }).then((value) {
            emailController!.text = '';
            passController!.text = '';
            confPassController!.text = '';
            userController!.text = '';
            setState(() {
              dropDownRole = 'Seleccione un rol';
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak.password') {
          customSnack('La contraseña es muy débil');
        } else if (e.code == 'email-already-in-use') {
          customSnack('El email ya ha sido registrado en otra cuenta');
        }
      }
    } else {
      switch (result) {
        case 1:
          customSnack('No puede haber campos vacios');
          break;
        case 2:
          customSnack('Las contraseñas no coinciden');
          break;
        case 3:
          customSnack('Es necesario elegir un rol');
          break;
      }
    }
  }

  int validaciones() {
    if (emailController!.text.isEmpty || passController!.text.isEmpty) {
      return 1;
    } else if (passController!.text != confPassController!.text) {
      return 2;
    } else if (dropDownRole == 'Seleccione un rol') {
      return 3;
    }

    return 0;
  }

  void customSnack(String texto) {
    final snack = SnackBar(
      content: Text('$texto'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
