import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlarmScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AlarmScreen({super.key, required this.userData});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<dynamic> _alarmas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarAlarmas();
  }

  Future<void> _cargarAlarmas() async {
    try {
      final url = Uri.parse('http://127.0.0.1/with_time_api/obtener_alarmas.php');
      final response = await http.post(
        url,
        body: {'id_usuario': widget.userData['id'].toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _alarmas = data['alarmas'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar alarmas: $e')),
      );
    }
  }

  void _mostrarModalCrearAlarma() {
    final tituloController = TextEditingController();
    TimeOfDay horaSeleccionada = TimeOfDay.now();
    DateTime fechaSeleccionada = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Alarma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título de la alarma'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: horaSeleccionada,
                  );
                  if (picked != null) {
                    setState(() {
                      horaSeleccionada = picked;
                    });
                  }
                },
                child: const Text('Seleccionar Hora'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text.trim();
                final horaFormateada = '${horaSeleccionada.hour.toString().padLeft(2, '0')}:${horaSeleccionada.minute.toString().padLeft(2, '0')}:00';
                final fechaFormateada = '${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}';

                if (titulo.isEmpty) return;

                final url = Uri.parse('http://127.0.0.1/with_time_api/crear_alarma.php');
                final response = await http.post(
                  url,
                  body: {
                    'id_usuario': widget.userData['id'].toString(),
                    'titulo': titulo,
                    'hora': horaFormateada,
                    'fecha': fechaFormateada,
                  },
                );

                if (response.statusCode == 200) {
                  final data = jsonDecode(response.body);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(data['message'])),
                  );
                  _cargarAlarmas(); // Recargar lista
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Alarmas'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alarmas.isEmpty
          ? const Center(child: Text('No tienes alarmas registradas.'))
          : ListView.builder(
        itemCount: _alarmas.length,
        itemBuilder: (context, index) {
          final alarma = _alarmas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.alarm, color: Colors.blue, size: 30),
              title: Text(alarma['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Hora: ${alarma['hora_alarma']} | Fecha: ${alarma['fecha_alarma']}'),
              trailing: Switch(
                value: alarma['estado'].toString() == '1',
                onChanged: (bool value) {
                  // Aquí puedes implementar la lógica para activar/desactivar en el futuro
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarModalCrearAlarma,
        child: const Icon(Icons.add),
      ),
    );
  }
}