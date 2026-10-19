import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CalendarScreen({super.key, required this.userData});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    try {
      final url = Uri.parse('http://127.0.0.1/with_time_api/obtener_eventos.php');
      final response = await http.post(
        url,
        body: {'id_usuario': widget.userData['id'].toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Map<DateTime, List<dynamic>> loadedEvents = {};
          for (var evento in data['eventos']) {
            DateTime fecha = DateTime.parse(evento['fecha_evento']);
            DateTime normalizedDate = DateTime(fecha.year, fecha.month, fecha.day);

            if (loadedEvents[normalizedDate] == null) {
              loadedEvents[normalizedDate] = [];
            }
            loadedEvents[normalizedDate]!.add(evento);
          }

          setState(() {
            _events = loadedEvents;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    DateTime normalizedDate = DateTime(day.year, day.month, day.day);
    return _events[normalizedDate] ?? [];
  }

  void _mostrarModalCrearEvento() {
    final tituloController = TextEditingController();
    final descController = TextEditingController();
    DateTime fechaSeleccionada = _selectedDay ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título del evento'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
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
                final descripcion = descController.text.trim();
                final fechaFormateada = '${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}';

                if (titulo.isEmpty) return;

                final url = Uri.parse('http://127.0.0.1/with_time_api/crear_evento.php');
                final response = await http.post(
                  url,
                  body: {
                    'id_usuario': widget.userData['id'].toString(),
                    'titulo': titulo,
                    'descripcion': descripcion,
                    'fecha': fechaFormateada,
                  },
                );

                if (response.statusCode == 200) {
                  final data = jsonDecode(response.body);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(data['message'])),
                  );
                  _cargarEventos();
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
    List<dynamic> eventosDelDia = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Eventos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: eventosDelDia.isEmpty
                ? const Center(child: Text('No hay eventos para este día.'))
                : ListView.builder(
              itemCount: eventosDelDia.length,
              itemBuilder: (context, index) {
                final evento = eventosDelDia[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.blue),
                    title: Text(evento['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(evento['descripcion'] ?? ''),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarModalCrearEvento,
        child: const Icon(Icons.add),
      ),
    );
  }
}