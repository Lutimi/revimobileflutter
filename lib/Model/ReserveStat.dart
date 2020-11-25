import 'dart:convert';

List<ReserveStat> reserveFromJson(String str) => List<ReserveStat>.from(json.decode(str).map((x) => ReserveStat.fromJson(x)));

String reserveToJson(List<ReserveStat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReserveStat {
  ReserveStat({
    this.reservaEstadoId,
    this.estado,
  });

  int reservaEstadoId;
  String estado;

  factory ReserveStat.fromJson(Map<String, dynamic> json) => ReserveStat(
    reservaEstadoId: json["reservaEstadoId"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "reservaEstadoId": reservaEstadoId,
    "estado": estado,
  };
}
