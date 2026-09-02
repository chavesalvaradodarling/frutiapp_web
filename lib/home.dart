
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> productos;

  @override
  void initState() {
    super.initState();

    productos = cargarProductos();
  }

  Future<List<dynamic>> cargarProductos() async {
    final response = await http.get(
      Uri.parse(
        'https://jsonplaceholder.typicode.com/posts',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'No se pudo cargar la información',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FrutiApp - Catálogo'),
        centerTitle: true,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: productos,

        builder: (context, snapshot) {

          // Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Estado de error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No se pudo cargar la información.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          // No hay datos
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos disponibles.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final productos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: productos.length,

            itemBuilder: (context, index) {
              final producto = productos[index];

              final int id = producto['id'];

              final String nombre = producto['title'];

              final int precio = id * 100;

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),

                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      '$id',
                    ),
                  ),

                  title: Text(
                    nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    'Precio: ₡$precio',
                  ),

                  trailing: Text(
                    'ID: $id',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

