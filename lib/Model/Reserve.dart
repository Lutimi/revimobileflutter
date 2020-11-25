import 'dart:convert';

List<Reserve> reserveFromJson(String str) => List<Reserve>.from(json.decode(str).map((x) => Reserve.fromJson(x)));

String reserveToJson(List<Reserve> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reserve {
  Reserve({
    this.reservaId,
    this.fecha,
    this.hora,
    this.observaciones,
    this.vehiculo,
    this.local,
    this.paAdPorcentaje,
    this.estado,
  });

  int reservaId;
  String fecha;
  String hora;
  String observaciones;
  String vehiculo;
  String local;
  int paAdPorcentaje;
  String estado;

  factory Reserve.fromJson(Map<String, dynamic> json) => Reserve(
    reservaId: json["reservaId"],
    fecha: json["fecha"],
    hora: json["hora"],
    observaciones: json["observaciones"],
    vehiculo: json["vehiculo"],
    local: json["local"],
    paAdPorcentaje: json["paAdPorcentaje"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "reservaId": reservaId,
    "fecha": fecha,
    "hora": hora,
    "observaciones": observaciones,
    "vehiculo": vehiculo,
    "local": local,
    "paAdPorcentaje": paAdPorcentaje,
    "estado": estado,
  };
}
