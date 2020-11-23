import 'dart:convert';

People peopleFromJson(String str) => People.fromJson(json.decode(str));

String peopleToJson(People data) => json.encode(data.toJson());

class People {
  People({
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
  });

  String firstName;
  String lastName;
  String email;
  String userType;

  factory People.fromJson(Map<String, dynamic> json) => People(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "userType": userType,
      };
}
