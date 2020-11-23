import 'dart:convert';

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toJson());

class Favorite {
  Favorite({
    this.user,
    this.favourited,
    this.since,
  });

  String user;
  String favourited;
  DateTime since;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        user: json["user"],
        favourited: json["favourited"],
        since: DateTime.parse(json["since"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "favourited": favourited,
        "since": since.toIso8601String(),
      };
}
