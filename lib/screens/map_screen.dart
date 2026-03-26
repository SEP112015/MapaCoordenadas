import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../models/person_location.dart';

class MapScreen extends StatefulWidget {
  final PersonLocation datos;

  const MapScreen({super.key, required this.datos});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String ubicacion = 'Cargando ubicación...';

  @override
  void initState() {
    super.initState();
    obtenerUbicacion();
  }

  Future<void> obtenerUbicacion() async {
    try {
      final lugares = await placemarkFromCoordinates(
        widget.datos.latitud,
        widget.datos.longitud,
      );

      if (lugares.isNotEmpty) {
        final lugar = lugares.first;
        final ciudad = lugar.locality ?? '';
        final pais = lugar.country ?? '';

        setState(() {
          if (ciudad.isNotEmpty && pais.isNotEmpty) {
            ubicacion = '$ciudad, $pais';
          } else if (pais.isNotEmpty) {
            ubicacion = pais;
          } else {
            ubicacion = 'Ubicación no disponible';
          }
        });
      } else {
        setState(() {
          ubicacion = 'Ubicación no encontrada';
        });
      }
    } catch (e) {
      setState(() {
        ubicacion = 'Error al obtener ubicación';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng posicion = LatLng(
      widget.datos.latitud,
      widget.datos.longitud,
    );

    final Set<Marker> marcadores = {
      Marker(
        markerId: const MarkerId('marcador_persona'),
        position: posicion,
        infoWindow: InfoWindow(
          title: '${widget.datos.nombre} ${widget.datos.apellido}',
          snippet: ubicacion,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Información del marcador'),
                content: Text(
                  'Nombre: ${widget.datos.nombre}\n'
                  'Apellido: ${widget.datos.apellido}\n'
                  'Ubicación: $ubicacion',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          },
        ),

        // Comentario 2:
        // Nombre: Sebastian Escaño
        // Matrícula: 2023-1063
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: posicion,
          zoom: 14,
        ),
        markers: marcadores,
      ),
    );
  }
}