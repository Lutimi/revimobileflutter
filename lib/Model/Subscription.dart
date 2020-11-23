import 'dart:convert';

Subscription subscriptionFromJson(String str) =>
    Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  Subscription({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.plan,
    this.price,
    this.state,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String plan;
  double price;
  String state;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        plan: json["plan"],
        price: json["price"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "plan": plan,
        "price": price,
        "state": state,
      };
}
