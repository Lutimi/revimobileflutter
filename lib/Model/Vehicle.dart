import 'dart:convert';

Vehicle vehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));

String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
  Vehicle({
    this.driver,
    this.model,
    this.brand,
    this.loadingCapacity,
  });

  String driver;
  String model;
  String brand;
  double loadingCapacity;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        driver: json["driver"],
        model: json["model"],
        brand: json["brand"],
        loadingCapacity: json["loadingCapacity"],
      );

  Map<String, dynamic> toJson() => {
        "driver": driver,
        "model": model,
        "brand": brand,
        "loadingCapacity": loadingCapacity,
      };
}
