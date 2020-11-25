
import 'dart:convert';

List<Brand> brandFromJson(String str) => List<Brand>.from(json.decode(str).map((x) => Brand.fromJson(x)));

String brandToJson(List<Brand> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Brand {
  Brand({
    this.marcaId,
    this.nombre,
  });

  int marcaId;
  String nombre;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    marcaId: json["marcaId"],
    nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "marcaId": marcaId,
    "nombre": nombre,
  };
}