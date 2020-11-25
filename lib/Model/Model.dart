import 'dart:convert';

List<Model> modelFromJson(String str) => List<Model>.from(json.decode(str).map((x) => Model.fromJson(x)));

String modelToJson(List<Model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Model {
  Model({
    this.modeloId,
    this.nombre,
    this.marcaId,
  });

  int modeloId;
  String nombre;
  int marcaId;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    modeloId: json["modeloId"],
    nombre: json["nombre"],
    marcaId: json["marcaId"],
  );

  Map<String, dynamic> toJson() => {
    "modeloId": modeloId,
    "nombre": nombre,
    "marcaId": marcaId,
  };
}
