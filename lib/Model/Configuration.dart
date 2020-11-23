import 'dart:convert';

Configuration configurationFromJson(String str) =>
    Configuration.fromJson(json.decode(str));

String configurationToJson(Configuration data) => json.encode(data.toJson());

class Configuration {
  Configuration({
    this.firstName,
    this.lastName,
    this.language,
    this.paymentCurrency,
    this.phone,
  });

  String firstName;
  String lastName;
  String language;
  String paymentCurrency;
  String phone;

  factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
        firstName: json["firstName"],
        lastName: json["lastName"],
        language: json["language"],
        paymentCurrency: json["paymentCurrency"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "language": language,
        "paymentCurrency": paymentCurrency,
        "phone": phone,
      };
}
