// import 'dart:convert';

class Humor {
  final String id;
  final String emocao;
  final String descricao;
  final DateTime data;
  final String icon;

  const Humor({
    required this.id,
    required this.emocao,
    required this.descricao,
    required this.data,
    required this.icon,
  });

  // Converte Humor para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emocao': emocao,
      'descricao': descricao,
      'data': data.toIso8601String(), // Converte DateTime para String
      'icon': icon,
    };
  }

  // Cria Humor a partir de Map (JSON)
  factory Humor.fromJson(Map<String, dynamic> json) {
    return Humor(
      id: json['id'],
      emocao: json['emocao'],
      descricao: json['descricao'],
      data: DateTime.parse(json['data']), // Converte String para DateTime
      icon: json['icon'],
    );
  }
}
