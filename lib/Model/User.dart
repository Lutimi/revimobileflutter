import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role,
  });

  String email;
  String password;
  String firstName;
  String lastName;
  String role;

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
      };
}

UserResponse ruserFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String ruserToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role,
  });

  String email;
  String password;
  String firstName;
  String lastName;
  int role;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
      };
}
