import 'package:firebase_database/firebase_database.dart';

import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';

class Compra {
  String? id;
  String? correoComprador;
  Servicio? servicio;
  String? statusCompra;
  String? statusVenta;
  String? correoVend;
  String? fechaProbableEntrega;

  Compra(this.id, this.correoComprador, this.servicio, this.statusCompra,
      this.statusVenta, this.correoVend, this.fechaProbableEntrega);

  Compra.map(dynamic obj) {
    this.id = obj['id'];
    this.correoVend = obj['correoVend'];
    this.correoComprador = obj['correoComprador'];
    this.servicio = obj['servicio'];
    this.statusCompra = obj['statusCompra'];
    this.statusVenta = obj['statusVenta'];
    this.fechaProbableEntrega = obj['fechaProbableEntrega'];
  }

  Compra.fromSnapshot(DataSnapshot snapShot) {
    id = snapShot.key;
    correoComprador = snapShot.value['correoComprador'];
    correoVend = snapShot.value['correoVend'];
    servicio = _mapeo(snapShot.value['servicio']);
    statusCompra = snapShot.value['statusCompra'];
    statusVenta = snapShot.value['statusVenta'];
    fechaProbableEntrega = snapShot.value['fechaProbableEntrega'];
  }

  Servicio _mapeo(valor) {
    return new Servicio(
        valor['id'],
        valor['nombre'],
        valor['descripcion'],
        valor['noContacto'],
        valor['latitud'],
        valor['longitud'],
        valor['imgUrl'],
        valor['precio'],
        valor['correoVend'],
        valor['status']);
  }
}
