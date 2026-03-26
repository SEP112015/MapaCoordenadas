import 'package:flutter/material.dart';
import '../models/person_location.dart';
import 'map_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController latitudController = TextEditingController();
  final TextEditingController longitudController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    latitudController.dispose();
    longitudController.dispose();
    super.dispose();
  }

  void irAlMapa() {
    if (_formKey.currentState!.validate()) {
      final datos = PersonLocation(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        latitud: double.parse(latitudController.text.trim()),
        longitud: double.parse(longitudController.text.trim()),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(datos: datos),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar datos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: latitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese la latitud';
                  }

                  final lat = double.tryParse(value);
                  if (lat == null) {
                    return 'Latitud inválida';
                  }

                  if (lat < -90 || lat > 90) {
                    return 'Debe estar entre -90 y 90';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: longitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese la longitud';
                  }

                  final lng = double.tryParse(value);
                  if (lng == null) {
                    return 'Longitud inválida';
                  }

                  if (lng < -180 || lng > 180) {
                    return 'Debe estar entre -180 y 180';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: irAlMapa,
                child: const Text('Siguiente'),
              ),

              const SizedBox(height: 20),

              // Comentario 1:
              // Nombre: Sebastian Escaño
              // Matrícula: 2023-1063
            ],
          ),
        ),
      ),
    );
  }
}