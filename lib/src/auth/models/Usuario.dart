import 'package:firebase_database/firebase_database.dart';

class Usuario {

  String? id;
  String? user;
  String? email;

  Usuario(this.id, this.user, this.email);

  Usuario.map(dynamic obj){
    this.id = obj['id'];
    this.user = obj['user'];
    this.email = obj['email'];
  }

  String get getId => id!;
  String get getUser => user!;
  String get getEmail => email!;

  Usuario.fromSnapshot(DataSnapshot snapShot){
    id = snapShot.key;
    user = snapShot.value['user'];
    email = snapShot.value['email'];
  }

}