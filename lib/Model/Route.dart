import 'dart:convert';

Route routeFromJson(String str) => Route.fromJson(json.decode(str));

String routeToJson(Route data) => json.encode(data.toJson());

class Route {
  Route({
    this.departureLocation,
    this.arrivalLocation,
    this.estimedTime,
    this.distance,
  });

  String departureLocation;
  String arrivalLocation;
  int estimedTime;
  double distance;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        departureLocation: json["departureLocation"],
        arrivalLocation: json["arrivalLocation"],
        estimedTime: json["estimedTime"],
        distance: json["distance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "departureLocation": departureLocation,
        "arrivalLocation": arrivalLocation,
        "estimedTime": estimedTime,
        "distance": distance,
      };
}
