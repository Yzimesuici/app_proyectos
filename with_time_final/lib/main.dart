import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const WithTimeApp());
}

class WithTimeApp extends StatelessWidget {
  const WithTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'With Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}