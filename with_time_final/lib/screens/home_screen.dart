import 'package:flutter/material.dart';
import 'alarm_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${userData['nombre']}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Panel Principal de With Time',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Correo: ${userData['correo']}'),
              const SizedBox(height: 40),

              // Botón para Alarmas
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
              const SizedBox(height: 16),

              // Botón para Calendario
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
            ],
          ),
        ),
      ),
    );
  }
}