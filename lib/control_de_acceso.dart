import 'package:flutter/material.dart';

import 'home.dart';
import 'models/access_record.dart';
import 'services/access_log_service.dart';
import 'services/preferences_service.dart';

class BodyApp extends StatefulWidget {
  const BodyApp({super.key});

  @override
  State<BodyApp> createState() => _BodyAppState();
}

class _BodyAppState extends State<BodyApp> {
  final _formKey = GlobalKey<FormState>();

  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  final logService = AccessLogService();
  final preferencesService = PreferencesService();

  bool recordarme = false;
  bool mostrarPassword = false;

  String mensaje = '';

  @override
  void initState() {
    super.initState();
    cargarUsuarioRecordado();
  }

  // Carga el usuario guardado anteriormente.
  Future<void> cargarUsuarioRecordado() async {
    final usuario = await preferencesService.obtenerUsuarioRecordado();

    if (!mounted) return;

    if (usuario != null) {
      setState(() {
        usuarioController.text = usuario;
        recordarme = true;
      });
    }
  }

  Future<void> validarAcceso() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = usuarioController.text.trim();
    final password = passwordController.text;

    final exitoso =
        usuario == 'admin@gmail.com' && password == '123456';

    // Determinar el resultado del intento.
    final resultado = exitoso ? 'AUTORIZADO' : 'RECHAZADO';

    // Registrar el intento de acceso.
    logService.add(
      AccessRecord(
        usuario: usuario,
        fechaHora: DateTime.now(),
        resultado: resultado,
      ),
    );

    // Guardar o eliminar el usuario recordado.
    if (recordarme) {
      await preferencesService.guardarUsuario(usuario);
    } else {
      await preferencesService.eliminarUsuarioRecordado();
    }

    if (!mounted) return;

    setState(() {
      mensaje = exitoso
          ? 'Acceso autorizado'
          : 'Usuario o contraseña incorrectos';
    });

    if (exitoso) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            logService: logService,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 146, 146),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'FrutiApp',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Correo electrónico',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: usuarioController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ingrese su correo',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el correo';
                        }

                        if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Correo no válido';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: passwordController,
                      obscureText: !mostrarPassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Ingrese su contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            mostrarPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              mostrarPassword = !mostrarPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }

                        return null;
                      },
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: recordarme,
                          onChanged: (value) async {
                            final nuevoValor = value ?? false;

                            setState(() {
                              recordarme = nuevoValor;
                            });

                            // Si se desactiva Recordarme,
                            // se elimina el usuario guardado.
                            if (!nuevoValor) {
                              await preferencesService
                                  .eliminarUsuarioRecordado();
                            }
                          },
                        ),
                        const Text('Recordarme'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: validarAcceso,
                        child: const Text('Ingresar'),
                      ),
                    ),

                    if (mensaje.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(
                        mensaje,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mensaje == 'Acceso autorizado'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}