import 'dart:convert';
import 'access_record.dart';

final registro1 = AccessRecord(
  usuario: 'ana',
  fechaHora: DateTime.now(),
  exitoso: true,
);

final registro2 = AccessRecord(
  usuario: 'luis',
  fechaHora: DateTime.now(),
  exitoso: false,
);

final registros = [
  registro1,
  registro2,
];

final jsonString = jsonEncode(
  registros.map((registro) => registro.toJson()).toList(),
);

void main() {
  print(jsonString);
}