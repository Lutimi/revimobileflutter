import 'dart:convert';

List<Company> companyFromJson(String str) => List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  Company({
    this.empresaId,
    this.nombre,
    this.ruc,
    this.telefono,
    this.correo,
  });

  int empresaId;
  String nombre;
  String ruc;
  String telefono;
  String correo;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    empresaId: json["empresaId"],
    nombre: json["nombre"],
    ruc: json["ruc"],
    telefono: json["telefono"],
    correo: json["correo"],
  );

  Map<String, dynamic> toJson() => {
    "empresaId": empresaId,
    "nombre": nombre,
    "ruc": ruc,
    "telefono": telefono,
    "correo": correo,
  };
}
