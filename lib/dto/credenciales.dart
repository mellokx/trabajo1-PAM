import 'dart:convert';

List<Credenciales> credencialesFromJson(String str) =>
    List<Credenciales>.from(json.decode(str).map((x) => Credenciales.fromJson(x)));

String credencialesToJson(List<Credenciales> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Credenciales {
  Credenciales({
    required this.id,
    required this.login,
    required this.nombre,
    required this.pass,
  });

  int id;
  String login;
  String nombre;
  String pass;

  factory Credenciales.fromJson(Map<String, dynamic> json) => Credenciales(
        id: json["Id"],
        login: json["login"],
        nombre: json["nombre"],
        pass: json["pass"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "login": login,
        "nombre": nombre,
        "pass": pass,
      };
}