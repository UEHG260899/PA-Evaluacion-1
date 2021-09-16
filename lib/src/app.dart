import 'package:flutter/material.dart';

import 'package:evaluacion_1/src/auth/views/login_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola',
      theme: ThemeData(
        primaryColor: Color(0xff01A0C7),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginView()
    );
  }
}