import 'package:flutter/material.dart';

import 'package:evaluacion_1/src/auth/views/login_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola',
      theme: ThemeData(
        primaryColor: Colors.yellow
      ),
      debugShowCheckedModeBanner: false,
      home: LoginView()
    );
  }
}