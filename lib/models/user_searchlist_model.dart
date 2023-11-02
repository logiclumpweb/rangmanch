// To parse this JSON data, do
//
//     final userSearchlistModel = userSearchlistModelFromJson(jsonString);
import 'dart:convert';

UserSearchlistModel userSearchlistModelFromJson(String str) => UserSearchlistModel.fromJson(json.decode(str));

String userSearchlistModelToJson(UserSearchlistModel data) => json.encode(data.toJson());

class UserSearchlistModel {
  UserSearchlistModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<searchDatum> data;

  factory UserSearchlistModel.fromJson(Map<String, dynamic> json) => UserSearchlistModel(
    message: json["message"],
    status: json["status"],
    data: List<searchDatum>.from(json["data"].map((x) => searchDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class searchDatum {
  searchDatum({
    required this.userId,
    required this.username,
    required this.image,
  });

  String userId;
  String username;
  String image;

  factory searchDatum.fromJson(Map<String, dynamic> json) => searchDatum(
    userId: json["user_id"],
    username: json["username"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "image": image,
  };
}
