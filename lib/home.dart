import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

import 'services/access_log_service.dart';

class HomePage extends StatefulWidget {
  final AccessLogService logService;

  const HomePage({
    super.key,
    required this.logService,
  });

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

  // =========================
  // IMPORTAR BITÁCORA
  // =========================

  Future<void> importarBitacora() async {
    const typeGroup = XTypeGroup(
      label: 'Archivos JSON',
      extensions: ['json'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: [typeGroup],
    );

    if (file == null) {
      return;
    }

    try {
      final contenido = await file.readAsString();

      widget.logService.importJson(contenido);

      setState(() {});

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bitácora importada correctamente.',
          ),
        ),
      );
    } on FormatException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El archivo JSON no tiene un formato válido: ${e.message}',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo leer el archivo.',
          ),
        ),
      );
    }
  }

  // =========================
  // EXPORTAR BITÁCORA
  // =========================

  void descargarJson(String contenido) {
    final bytes = utf8.encode(contenido);
    final base64Data = base64Encode(bytes);

    final anchor =
        web.document.createElement('a') as web.HTMLAnchorElement;

    anchor.href =
        'data:application/json;base64,$base64Data';

    anchor.download = 'bitacora_accesos.json';

    anchor.click();
  }

  void exportarBitacora() {
    descargarJson(
      widget.logService.exportJson(),
    );
  }

  // =========================
  // CONSTRUIR BITÁCORA
  // =========================

  Widget construirBitacora() {
    final registros = widget.logService.records;

    if (registros.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No hay registros de acceso todavía.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: registros.length,
      itemBuilder: (context, index) {
        final registro = registros[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          child: ListTile(
            leading: Icon(
              registro.exitoso
                  ? Icons.check_circle
                  : Icons.cancel,
              color: registro.exitoso
                  ? Colors.green
                  : Colors.red,
            ),
            title: Text(
              'Usuario: ${registro.usuario}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Fecha y hora: ${registro.fechaHora}\n'
              'Resultado: ${registro.exitoso ? 'OK' : 'FALLÓ'}',
            ),
          ),
        );
      },
    );
  }

  // =========================
  // INTERFAZ
  // =========================


  @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FrutiApp - Catálogo',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),

            // =========================
            // BOTONES JSON
            // =========================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: exportarBitacora,
                  icon: const Icon(Icons.download),
                  label: const Text(
                    'Exportar JSON',
                  ),
                ),

                const SizedBox(width: 10),

                OutlinedButton.icon(
                  onPressed: importarBitacora,
                  icon: const Icon(Icons.upload_file),
                  label: const Text(
                    'Importar JSON',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // TÍTULO BITÁCORA
            // =========================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bitácora de accesos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // LISTA DE REGISTROS
            // =========================

            construirBitacora(),

            const SizedBox(height: 30),

            // =========================
            // CATÁLOGO
            // =========================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Catálogo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            FutureBuilder<List<dynamic>>(
              future: productos,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No se pudo cargar la información.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No hay productos disponibles.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }

                final listaProductos = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: listaProductos.length,
                  itemBuilder: (context, index) {
                    final producto =
                        listaProductos[index];

                    final int id = producto['id'];
                    final String nombre =
                        producto['title'];
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}