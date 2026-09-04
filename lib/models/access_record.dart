class AccessRecord {
  final String usuario;
  final DateTime fechaHora;
  final String resultado;

  const AccessRecord({
    required this.usuario,
    required this.fechaHora,
    required this.resultado,
  });

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario,
      'fechaHora': fechaHora.toIso8601String(),
      'resultado': resultado,
    };
  }

  factory AccessRecord.fromJson(Map<String, dynamic> json) {
    return AccessRecord(
      usuario: json['usuario'] as String,
      fechaHora: DateTime.parse(json['fechaHora'] as String),
      resultado: json['resultado'] as String,
    );
  }
}