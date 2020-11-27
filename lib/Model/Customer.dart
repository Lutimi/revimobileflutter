import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.credits,
    this.email,
    this.role,
    this.roleId,
  });

  int id;
  String firstName;
  String lastName;
  double credits;
  String email;
  int role;
  int roleId;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        credits: json["credits"],
        email: json["email"],
        role: json["role"],
        roleId: json["roleId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "credits": credits,
        "email": email,
        "role": role,
        "roleId": roleId,
      };
}
