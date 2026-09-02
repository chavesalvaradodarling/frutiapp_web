import 'access_record.dart';
import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:web/web.dart' as web;

Future<String?> seleccionarJson() async {
  const tipo = XTypeGroup(
    label: 'JSON',
    extensions: ['json'],
    mimeTypes: ['application/json'],
  );

  final XFile? file = await openFile(
    acceptedTypeGroups: [tipo],
  );

  if (file == null) return null;

  return file.readAsString();
}

List<AccessRecord> convertirJsonARegistros(String contenido) {
  final data = jsonDecode(contenido) as List;

  return data
      .map(
        (item) => AccessRecord.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}

void descargarJson(String contenido) {
  final data = base64Encode(utf8.encode(contenido));

  web.HTMLAnchorElement()
    ..href = 'data:application/json;base64,$data'
    ..setAttribute('download', 'bitacora_accesos.json')
    ..click();
}