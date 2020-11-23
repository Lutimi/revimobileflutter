import 'dart:convert';

PaymentMethod paymentMethodFromJson(String str) =>
    PaymentMethod.fromJson(json.decode(str));

String paymentMethodToJson(PaymentMethod data) => json.encode(data.toJson());

class PaymentMethod {
  PaymentMethod({
    this.bankName,
    this.swiftCode,
    this.accountNumber,
  });

  String bankName;
  int swiftCode;
  //AccountNumber => Long type
  int accountNumber;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        bankName: json["bankName"],
        swiftCode: json["swiftCode"],
        accountNumber: json["accountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "swiftCode": swiftCode,
        "accountNumber": accountNumber,
      };
}
