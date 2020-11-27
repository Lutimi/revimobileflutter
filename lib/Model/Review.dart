import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  Review({
    this.cargo,
    this.commentary,
    this.calification,
    this.driver,
    this.customer,
  });

  String cargo;
  String commentary;
  double calification;
  String driver;
  String customer;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        cargo: json["cargo"],
        commentary: json["commentary"],
        calification: json["calification"],
        driver: json["driver"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "cargo": cargo,
        "commentary": commentary,
        "calification": calification,
        "driver": driver,
        "customer": customer,
      };
}
