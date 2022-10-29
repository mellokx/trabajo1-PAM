import 'dart:convert';

List<Mensajes> mensajesFromJson(String str) =>
    List<Mensajes>.from(json.decode(str).map((x) => Mensajes.fromJson(x)));

String mensajesToJson(List<Mensajes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mensajes {
  Mensajes({
    required this.fecha,
    required this.id,
    required this.login,
    required this.texto,
    required this.titulo,
  });

  DateTime fecha;
  int id;
  String login;
  String texto;
  String titulo;

  factory Mensajes.fromJson(Map<String, dynamic> json) => Mensajes(
        fecha: DateTime.parse(json["fecha"]),
        id: json["id"],
        login: json["login"],
        texto: json["texto"],
        titulo: json["titulo"],
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha.toIso8601String(),
        "id": id,
        "login": login,
        "texto": texto,
        "titulo": titulo,
      };
}
