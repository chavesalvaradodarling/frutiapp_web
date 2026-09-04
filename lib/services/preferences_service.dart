import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _recordarUsuarioKey = 'recordarUsuario';
  static const String _usuarioRecordadoKey = 'usuarioRecordado';

  // Guarda la preferencia de Recordarme y el usuario.
  Future<void> guardarUsuario(String usuario) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_recordarUsuarioKey, true);
    await prefs.setString(_usuarioRecordadoKey, usuario);
  }

  // Obtiene el usuario guardado, si existe y está activado Recordarme.
  Future<String?> obtenerUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();

    final recordarUsuario =
        prefs.getBool(_recordarUsuarioKey) ?? false;

    if (!recordarUsuario) {
      return null;
    }

    return prefs.getString(_usuarioRecordadoKey);
  }

  // Elimina el usuario guardado y desactiva Recordarme.
  Future<void> eliminarUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_recordarUsuarioKey);
    await prefs.remove(_usuarioRecordadoKey);
  }
}