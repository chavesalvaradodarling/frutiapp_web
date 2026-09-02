
import 'package:flutter/material.dart';
import 'package:frutiapp_web/control_de_acceso.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FrutiApp Web',
      home: const BodyApp(),
    );
  }
}

