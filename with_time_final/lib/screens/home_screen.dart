import 'package:flutter/material.dart';
import 'alarm_screen.dart';
import 'calendar_screen.dart';
import 'ubicacion_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userName = userData['nombre'] ?? 'Usuario';
    final String userEmail = userData['correo'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $userName'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Panel Principal de With Time',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Correo: $userEmail',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),

              // Botón Gestionar Alarmas
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlarmScreen(userData: userData),
                    ),
                  );
                },
                icon: const Icon(Icons.alarm),
                label: const Text('Gestionar Alarmas'),
              ),
              const SizedBox(height: 12),

              // Botón Ver Calendario
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(userData: userData),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Ver Calendario'),
              ),
              const SizedBox(height: 12),
              
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UbicacionScreen()),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text('Seleccionar Ubicación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}