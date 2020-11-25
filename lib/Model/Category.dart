
import 'dart:convert';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    this.categoriaId,
    this.nombre,
    this.descripcion,
  });

  int categoriaId;
  String nombre;
  String descripcion;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoriaId: json["categoriaId"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toJson() => {
    "categoriaId": categoriaId,
    "nombre": nombre,
    "descripcion": descripcion,
  };
}
