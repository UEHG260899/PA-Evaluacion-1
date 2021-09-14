import 'dart:ui';

import 'package:flutter/material.dart';

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
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  userField(),
                  SizedBox(height: 26.0,),
                  emailField(),
                  SizedBox(height: 26.0,),
                  passField(),
                  SizedBox(height: 26.0,),
                  confPassField(),
                  SizedBox(height: 26.0,),
                  roleSelect(),
                  SizedBox(height: 26.0,),
                  registroBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userField(){
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

  Widget passField(){
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

  Widget confPassField(){
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

  Widget roleSelect(){
    return DropdownButton(
      value: dropDownRole,
      underline: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      onChanged: (String? nuevoRol){
        setState(() {
          dropDownRole = nuevoRol!;
        });
        print(dropDownRole);
      },
      items: <String>['Seleccione un rol','Vendedor', 'Comprador']
        .map<DropdownMenuItem<String>>((String value){
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

  registrar(){
    //bool result = validaciones();
    print('Hola');
  }

  bool validaciones(){
    if(emailController!.text.isEmpty || passController!.text.isEmpty
        || dropDownRole == 'Seleccione un rol'){
          return false;
    }

    return true;
  }
}
