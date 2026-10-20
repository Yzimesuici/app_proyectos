import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UbicacionScreen extends StatefulWidget {
  const UbicacionScreen({Key? key}) : super(key: key);

  @override
  _UbicacionScreenState createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  // Coordenadas iniciales de centro (México)
  final LatLng _initialPosition = const LatLng(23.6345, -102.5528);

  // Variable para almacenar la ubicación seleccionada por el usuario
  LatLng? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedPosition != null) {
                print("Ubicación guardada -> Lat: ${_selectedPosition!.latitude}, Lng: ${_selectedPosition!.longitude}");
                Navigator.pop(context, _selectedPosition);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor toca el mapa para seleccionar un lugar'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 13.0,
          onTap: (tapPosition, LatLng position) {
            setState(() {
              _selectedPosition = position;
            });
            print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.with_time_final',
          ),
          if (_selectedPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedPosition!,
                  width: 80.0,
                  height: 80.0,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}