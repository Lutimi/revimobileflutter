import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    this.id,
    this.firstName,
    this.lastName,
    this.license,
    this.email,
    this.role,
    this.roleId,
  });

  int id;
  String firstName;
  String lastName;
  String license;
  String email;
  int role;
  int roleId;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        license: json["license"],
        email: json["email"],
        role: json["role"],
        roleId: json["roleId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "license": license,
        "email": email,
        "role": role,
        "roleId": roleId,
      };
}
