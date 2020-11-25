import 'dart:convert';

Resource resourceFromJson(String str) => Resource.fromJson(json.decode(str));

String resourceToJson(Resource data) => json.encode(data.toJson());

class Resource {
  Resource({
    this.success,
    this.message,
    this.resource,
    this.resourceList,
  });

  bool success;
  String message;
  int resource;
  List<dynamic> resourceList;

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        success: json["success"],
        message: json["message"],
        resource: json["resource"],
       // resourceList: List<dynamic>.from(json["resourceList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "resource": resource,
        //"resourceList": List<dynamic>.from(resourceList.map((x) => x)),
      };
}
