import 'dart:convert';

Service serviceFromJson(String str) => Service.fromJson(json.decode(str));

String serviceToJson(Service data) => json.encode(data.toJson());

class Service {
    Service({
        this.firstName,
        this.lastName,
        this.startedTime,
        this.finishTime,
        this.serviceState,
        this.id,
    });

    String firstName;
    String lastName;
    DateTime startedTime;
    DateTime finishTime;
    String serviceState;
    int id;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        firstName: json["firstName"],
        lastName: json["lastName"],
        startedTime: DateTime.parse(json["startedTime"]),
        finishTime: DateTime.parse(json["finishTime"]),
        serviceState: json["serviceState"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "startedTime": startedTime.toIso8601String(),
        "finishTime": finishTime.toIso8601String(),
        "serviceState": serviceState,
        "id": id,
    };
}