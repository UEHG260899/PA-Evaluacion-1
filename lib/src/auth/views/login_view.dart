import 'package:evaluacion_1/src/vendedor/views/drawer_vendedor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:evaluacion_1/src/auth/views/registro_view.dart';
import 'package:evaluacion_1/src/comprador/views/drawer_comprador.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //Controladores
  TextEditingController? emailController;
  TextEditingController? passController;

  //Instancias firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    this.checkAuth();
    emailController = new TextEditingController();
    passController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150.0,
                    child: Image.asset(
                      "assets/login.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  mailField(),
                  SizedBox(
                    height: 25.0,
                  ),
                  passField(),
                  SizedBox(
                    height: 25.0,
                  ),
                  loginBtn(context),
                  SizedBox(
                    height: 25.0,
                  ),
                  registroBtn(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Widgets

  Widget mailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Correo electrónico',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget passField() {
    return TextField(
      obscureText: true,
      controller: passController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Contraseña',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget loginBtn(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => login(),
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget registroBtn(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => RegistroView()));
        },
        child: Text("Registro",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  //Funciones aparte

  login() async {
    int resultado = validaciones();

    if (resultado == 1) {
      customSnack('No puede haber campos vacios');
    } else {
      try {
        _auth.signInWithEmailAndPassword(
            email: emailController!.text, password: passController!.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          customSnack('No se han encontrado registros con esos datos');
        } else if (e.code == 'wrong-password') {
          customSnack('Credenciales invalidas');
        }
      }
    }
  }

  int validaciones() {
    if (emailController!.text.isEmpty || passController!.text.isEmpty) {
      return 1;
    }

    return 0;
  }

  void customSnack(String texto) {
    final snack = SnackBar(
      content: Text('$texto'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  consultas(String correo) {
    Query _compradorQuery =
        _dbRef.child('compradores').orderByChild("email").equalTo(correo);

    _compradorQuery.get().then((value) {
      Map<dynamic, dynamic> map = value.value;
      map.forEach((key, value) {
        if (correo == value['email']) {
          //banderaC = true;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => DrawerComprador()),
              (route) => false);
        }
      });
    });

    Query _vendedorQuery =
        _dbRef.child('vendedores').orderByChild("email").equalTo(correo);

    _vendedorQuery.get().then((value) {
      Map<dynamic, dynamic> map = value.value;
      map.forEach((key, value) {
        if (correo == value['email']) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => VendedorDrawer()),
              (route) => false);
        }
      });
    });
  }

  checkAuth() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        consultas(user.email!);
      }
    });
  }
}
