import 'dart:convert';

Cargo cargoFromJson(String str) => Cargo.fromJson(json.decode(str));

String cargoToJson(Cargo data) => json.encode(data.toJson());

class Cargo {
  Cargo({
    this.customer,
    this.driver,
    this.serviceId,
    this.startTime,
    this.finishTime,
    this.weight,
    this.description,
    this.servicePrice,
    this.cargoType,
    this.cargoStatus,
  });

  String customer;
  String driver;
  int serviceId;
  DateTime startTime;
  DateTime finishTime;
  double weight;
  String description;
  double servicePrice;
  String cargoType;
  String cargoStatus;

  factory Cargo.fromJson(Map<String, dynamic> json) => Cargo(
        customer: json["customer"],
        driver: json["driver"],
        serviceId: json["serviceId"],
        startTime: DateTime.parse(json["startTime"]),
        finishTime: DateTime.parse(json["finishTime"]),
        weight: json["weight"],
        description: json["description"],
        servicePrice: json["servicePrice"],
        cargoType: json["cargoType"],
        cargoStatus: json["cargoStatus"],
      );

  Map<String, dynamic> toJson() => {
        "customer": customer,
        "driver": driver,
        "serviceId": serviceId,
        "startTime": startTime.toIso8601String(),
        "finishTime": finishTime.toIso8601String(),
        "weight": weight,
        "description": description,
        "servicePrice": servicePrice,
        "cargoType": cargoType,
        "cargoStatus": cargoStatus,
      };
}
