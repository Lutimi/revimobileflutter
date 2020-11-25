import 'dart:convert';

List<Promo> promoFromJson(String str) => List<Promo>.from(json.decode(str).map((x) => Promo.fromJson(x)));

String promoToJson(List<Promo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Promo {
  Promo({
    this.promocionId,
    this.nombre,
    this.descuento,
    this.descripcion,
    this.servicioId,
  });

  int promocionId;
  String nombre;
  int descuento;
  String descripcion;
  int servicioId;

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
    promocionId: json["promocionId"],
    nombre: json["nombre"],
    descuento: json["descuento"],
    descripcion: json["descripcion"],
    servicioId: json["servicioId"],
  );

  Map<String, dynamic> toJson() => {
    "promocionId": promocionId,
    "nombre": nombre,
    "descuento": descuento,
    "descripcion": descripcion,
    "servicioId": servicioId,
  };
}