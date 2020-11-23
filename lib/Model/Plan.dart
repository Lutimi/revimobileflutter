import 'dart:convert';

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));

String planToJson(Plan data) => json.encode(data.toJson());

class Plan {
  Plan({
    this.id,
    this.planName,
    this.durationDays,
    this.price,
    this.tax,
  });

  int id;
  String planName;
  int durationDays;
  double price;
  double tax;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        planName: json["planName"],
        durationDays: json["durationDays"],
        price: json["price"],
        tax: json["tax"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "planName": planName,
        "durationDays": durationDays,
        "price": price,
        "tax": tax,
      };
}
