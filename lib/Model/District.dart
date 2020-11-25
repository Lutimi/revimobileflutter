import 'dart:convert';

List<District> welcomeFromJson(String str) => List<District>.from(json.decode(str).map((x) => District.fromJson(x)));

String welcomeToJson(List<District> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class District {
  District({
    this.distritoId,
    this.nombre,
  });

  int distritoId;
  String nombre;

  factory District.fromJson(Map<String, dynamic> json) => District(
    distritoId: json["distritoId"],
    nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "distritoId": distritoId,
    "nombre": nombre,
  };
}
