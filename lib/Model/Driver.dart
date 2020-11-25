import 'dart:convert';

List<Driver> DriverFromJson(String str) => List<Driver>.from(json.decode(str).map((x) => Driver.fromJson(x)));

String DriverToJson(List<Driver> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Driver {
  Driver({
    this.conductorId,
    this.nombre,
    this.apellido,
    this.dni,
    this.direccion,
    this.celular,
    this.correo,
  });

  int conductorId;
  String nombre;
  String apellido;
  String dni;
  String direccion;
  String celular;
  String correo;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    conductorId: json["conductorId"],
    nombre: json["nombre"],
    apellido: json["apellido"],
    dni: json["dni"],
    direccion: json["direccion"],
    celular: json["celular"],
    correo: json["correo"],
  );

  Map<String, dynamic> toJson() => {
    "conductorId": conductorId,
    "nombre": nombre,
    "apellido": apellido,
    "dni": dni,
    "direccion": direccion,
    "celular": celular,
    "correo": correo,
  };
}
