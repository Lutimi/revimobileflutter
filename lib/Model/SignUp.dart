import 'dart:convert';

Signup signupFromJson(String str) => Signup.fromJson(json.decode(str));

String signupToJson(Signup data) => json.encode(data.toJson());

class Signup {
  Signup({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.discriminator,
  });

  String firstName;
  String lastName;
  String email;
  String password;
  String phone;
  int discriminator;

  factory Signup.fromJson(Map<String, dynamic> json) => Signup(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        discriminator: json["discriminator"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "discriminator": discriminator,
      };
}
