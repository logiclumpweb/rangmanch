// To parse this JSON data, do
//
//     final followlistModel = followlistModelFromJson(jsonString);

import 'dart:convert';

FollowlistModel followlistModelFromJson(String str) => FollowlistModel.fromJson(json.decode(str));

String followlistModelToJson(FollowlistModel data) => json.encode(data.toJson());

class FollowlistModel {
  FollowlistModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<followDatum> data;

  factory FollowlistModel.fromJson(Map<String, dynamic> json) => FollowlistModel(
    message: json["message"],
    status: json["status"],
    data: List<followDatum>.from(json["data"].map((x) => followDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class followDatum {
  followDatum({
    required this.tblFollowingId,
    required this.username,
    required this.followingUserId,
    required this.image,
  });

  String tblFollowingId;
  String username;
  String followingUserId;
  String image;

  factory followDatum.fromJson(Map<String, dynamic> json) => followDatum(
    tblFollowingId: json["tbl_following_id"],
    username: json["username"],
    followingUserId: json["following_user_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_following_id": tblFollowingId,
    "username": username,
    "following_user_id": followingUserId,
    "image": image,
  };
}
