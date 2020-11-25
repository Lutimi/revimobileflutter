import 'dart:convert';

List<Service> serviceFromJson(String str) => List<Service>.from(json.decode(str).map((x) => Service.fromJson(x)));

String serviceToJson(List<Service> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Service {
    Service({
        this.servicioId,
        this.nombre,
        this.descripcion,
        this.localId,
        this.categoriaId,
        this.promocion,
    });

    int servicioId;
    String nombre;
    String descripcion;
    int localId;
    int categoriaId;
    String promocion;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        servicioId: json["servicioId"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        localId: json["localId"],
        categoriaId: json["categoriaId"],
        promocion: json["promocion"],
    );

    Map<String, dynamic> toJson() => {
        "servicioId": servicioId,
        "nombre": nombre,
        "descripcion": descripcion,
        "localId": localId,
        "categoriaId": categoriaId,
        "promocion": promocion,
    };
}