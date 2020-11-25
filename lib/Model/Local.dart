import 'dart:convert';

List<Local> localFromJson(String str) => List<Local>.from(json.decode(str).map((x) => Local.fromJson(x)));

String localToJson(List<Local> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Local {
  Local({
    this.localId,
    this.direccion,
    this.horaApertura,
    this.horaCierre,
    this.empresa,
    this.distrito,
  });

  int localId;
  String direccion;
  String horaApertura;
  String horaCierre;
  String empresa;
  String distrito;

  factory Local.fromJson(Map<String, dynamic> json) => Local(
    localId: json["localId"],
    direccion: json["direccion"],
    horaApertura: json["horaApertura"],
    horaCierre: json["horaCierre"],
    empresa: json["empresa"],
    distrito: json["distrito"],
  );

  Map<String, dynamic> toJson() => {
    "localId": localId,
    "direccion": direccion,
    "horaApertura": horaApertura,
    "horaCierre": horaCierre,
    "empresa": empresa,
    "distrito": distrito,
  };
}
