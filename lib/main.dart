import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final TextEditingController _controladorTexto = TextEditingController();
  String _textoMostrado = "";

  int _conteoEnvios = 0;
  Color _colorTexto = Colors.deepOrange;

  final List<Color> _coloresBoton = [
    Colors.green,
    Colors.purple,
    Colors.blue,
  ];
  int _indiceColorBoton = 0;
  Timer? _timerColor;

  @override
  void initState() {
    super.initState();
    _iniciarCicloColor();
  }

  void _iniciarCicloColor() {
    _timerColor = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          _indiceColorBoton = (_indiceColorBoton + 1) % _coloresBoton.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timerColor?.cancel();
    _controladorTexto.dispose();
    super.dispose();
  }

  // 2. Función que muestra la alerta de confirmación estilo Cupertino
  void _mostrarAlertaConfirmacion() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Está seguro de enviar este texto zzz?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('No ya no'),
            onPressed: () {
              Navigator.pop(context); // Cierra la alerta
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Of course, '),
            onPressed: () {
              Navigator.pop(context); // Cierra la alerta
              _actualizarTexto(); // Ejecuta la acción
            },
          ),
        ],
      ),
    );
  }

  void _actualizarTexto() {
    setState(() {
      _textoMostrado = _controladorTexto.text;
      _conteoEnvios++;

      if (_conteoEnvios % 2 == 0) {
        _colorTexto = Colors.red;
      } else {
        _colorTexto = Colors.deepOrange;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.indigo.shade900,
            width: 6.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hola',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // 3. STACK: Imagen con un botón flotante 'X' en la esquina
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/935ee184be5f8bffacf006bbc234fb51.jpg',
                        height: 220,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        onPressed: () {
                          setState(() {
                            _textoMostrado = "¡Picate otro lado!";
                          });
                        },
                        child: const Icon(
                          CupertinoIcons.clear,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controladorTexto,
                        decoration: InputDecoration(
                          hintText: 'Bleh Bleh',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // 1. CUPERTINO BUTTON: Botón con estilo iOS que mantiene su ciclo de colores
                    CupertinoButton(
                      color: _coloresBoton[_indiceColorBoton],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      borderRadius: BorderRadius.circular(15.0),
                      onPressed: _mostrarAlertaConfirmacion, // Llama a la alerta primero
                      child: const Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Text(
                  _textoMostrado,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _colorTexto,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Mi App',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}