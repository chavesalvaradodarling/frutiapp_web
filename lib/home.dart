import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'access_record.dart';
import 'json_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> productos;

  List<AccessRecord> registros = [];

  Future<void> importarRegistros() async {
    final contenido = await seleccionarJson();

    if (contenido == null) {
      return;
    }

    try {
      final nuevosRegistros = convertirJsonARegistros(contenido);

      setState(() {
        registros = nuevosRegistros;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El archivo JSON no tiene un formato válido.',
          ),
        ),
      );
    }
  }

  void exportarRegistros() {
    final contenido = jsonEncode(
      registros.map((registro) => registro.toJson()).toList(),
    );

    descargarJson(contenido);
  }

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
      body: Column(
        children: [
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: importarRegistros,
                child: const Text('Importar JSON'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: registros.isEmpty
                    ? null
                    : exportarRegistros,
                child: const Text('Exportar JSON'),
              ),
            ],
          ),

          Expanded(
            child: registros.isNotEmpty
                ? ListView.builder(
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      final registro = registros[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            'Usuario: ${registro.usuario}',
                          ),
                          subtitle: Text(
                            'Fecha: ${registro.fechaHora}\n'
                            'Acceso: ${registro.exitoso ? 'Exitoso' : 'Fallido'}',
                          ),
                        ),
                      );
                    },
                  )
                : FutureBuilder<List<dynamic>>(
                    future: productos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

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

                      if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay productos disponibles.',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      final listaProductos = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: listaProductos.length,
                        itemBuilder: (context, index) {
                          final producto = listaProductos[index];

                          final int id = producto['id'];
                          final String nombre = producto['title'];
                          final int precio = id * 100;

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('$id'),
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
          ),
        ],
      ),
    );
  }
}