
import 'dart:convert';

List<Schedule> scheduleFromJson(String str) => List<Schedule>.from(json.decode(str).map((x) => Schedule.fromJson(x)));

String scheduleToJson(List<Schedule> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Schedule {
  Schedule({
    this.horarioId,
    this.horaApertura,
    this.horaCierre,
  });

  int horarioId;
  String horaApertura;
  String horaCierre;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    horarioId: json["horarioId"],
    horaApertura: json["horaApertura"],
    horaCierre: json["horaCierre"],
  );

  Map<String, dynamic> toJson() => {
    "horarioId": horarioId,
    "horaApertura": horaApertura,
    "horaCierre": horaCierre,
  };
}