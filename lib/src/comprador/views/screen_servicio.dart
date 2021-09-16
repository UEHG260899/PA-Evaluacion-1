import 'package:evaluacion_1/src/vendedor/models/Servicio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenServicio extends StatelessWidget {
  final Servicio servicio;
  ScreenServicio(this.servicio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info del servicio'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Card(
                    elevation: 10.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage('${servicio.imgUrl}'),
                            radius: 100.0,
                          ),
                        ),
                        SizedBox(
                          height: 26.0,
                        ),
                        Text('Servicio: ${servicio.nombre}'),
                        SizedBox(
                          height: 26.0,
                        ),
                        Text('Descripción: ${servicio.descripcion}'),
                        SizedBox(height: 26.0),
                        Text('No. de Contacto: ${servicio.noContacto}'),
                        SizedBox(height: 26.0),
                        Text('Precio: ${servicio.precio}'),
                        SizedBox(height: 26.0),
                        Text('Ubicación:'),
                        SizedBox(height: 26.0),
                        Container(
                          child: Stack(
                            children: [
                              mapaView(),
                              Container(
                                child: Icon(Icons.location_history),
                                alignment: Alignment.center,
                              )
                            ],
                          ),
                          height: 200.0,
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  //métodos aparte
  Widget mapaView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
            double.parse(servicio.latitud!), double.parse(servicio.longitud!)),
        zoom: 15.0,
      ),
      mapType: MapType.normal,
    );
  }
}
