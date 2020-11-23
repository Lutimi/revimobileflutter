import 'dart:convert';

Price priceFromJson(String str) => Price.fromJson(json.decode(str));

String priceToJson(Price data) => json.encode(data.toJson());

class Price {
  Price({
    this.totalPrice,
    this.tax,
    this.priceFrom,
  });

  double totalPrice;
  double tax;
  String priceFrom;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        totalPrice: json["totalPrice"],
        tax: json["tax"],
        priceFrom: json["priceFrom"],
      );

  Map<String, dynamic> toJson() => {
        "totalPrice": totalPrice,
        "tax": tax,
        "priceFrom": priceFrom,
      };
}
