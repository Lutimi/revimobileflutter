import 'dart:convert';

List<Departament> departamentFromJson(String str) => List<Departament>.from(json.decode(str).map((x) => Departament.fromJson(x)));

String departamentToJson(List<Departament> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Departament {
  Departament({
    this.departamentoId,
    this.nombre,
  });

  int departamentoId;
  String nombre;

  factory Departament.fromJson(Map<String, dynamic> json) => Departament(
    departamentoId: json["departamentoId"],
    nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "departamentoId": departamentoId,
    "nombre": nombre,
  };
}
