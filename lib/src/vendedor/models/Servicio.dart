import 'package:firebase_database/firebase_database.dart';

class Servicio {
  String? id;
  String? nombre;
  String? descripcion;
  String? noContacto;
  String? latitud;
  String? longitud;
  String? imgUrl;
  String? precio;

  Servicio(this.id, this.nombre, this.descripcion, this.noContacto,
      this.latitud, this.longitud, this.imgUrl, this.precio);

  Servicio.map(dynamic obj){
    this.id = obj['id'];
    this.nombre = obj['nombre'];
    this.descripcion = obj['descripcion'];
    this.noContacto = obj['noContacto'];
    this.latitud = obj['latitud'];
    this.longitud = obj['longitud'];
    this.imgUrl = obj['imgUrl'];
    this.precio = obj['precio'];
  }

  String get getId => id!;
  String get getNombre => nombre!;
  String get getNoContacto => noContacto!;
  String get getDescripcion => descripcion!;
  String get getLalitud => latitud!;
  String get getLongitud => longitud!;
  String get getImgUrl => imgUrl!;
  String get getPrecio => precio!;

  Servicio.fromSnapshot(DataSnapshot snapShot){
    id = snapShot.key;
    nombre = snapShot.value['nombre'];
    noContacto = snapShot.value['noContacto'];
    descripcion = snapShot.value['descripcion'];
    latitud = snapShot.value['latitud'];
    longitud = snapShot.value['longitud'];
    imgUrl = snapShot.value['imgUrl'];
    precio = snapShot.value['precio'];
  }
}
