import 'dart:convert';

List<Vehicle> vehicleFromJson(String str) => List<Vehicle>.from(json.decode(str).map((x) => Vehicle.fromJson(x)));

String vehicleToJson(List<Vehicle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vehicle {
  Vehicle({
    this.vehiculoId,
    this.placa,
    this.color,
    this.fechaFabricacion,
    this.conductorId,
    this.categoriaId,
    this.modeloId,
  });

  int vehiculoId;
  String placa;
  String color;
  String fechaFabricacion;
  int conductorId;
  int categoriaId;
  int modeloId;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    vehiculoId: json["vehiculoId"],
    placa: json["placa"],
    color: json["color"],
    fechaFabricacion: json["fechaFabricacion"],
    conductorId: json["conductorId"],
    categoriaId: json["categoriaId"],
    modeloId: json["modeloId"],
  );

  Map<String, dynamic> toJson() => {
    "vehiculoId": vehiculoId,
    "placa": placa,
    "color": color,
    "fechaFabricacion": fechaFabricacion,
    "conductorId": conductorId,
    "categoriaId": categoriaId,
    "modeloId": modeloId,
  };
}