// To parse this JSON data, do
//
//     final followModel = followModelFromJson(jsonString);

import 'dart:convert';

FollowModel followModelFromJson(String str) => FollowModel.fromJson(json.decode(str));

String followModelToJson(FollowModel data) => json.encode(data.toJson());

class FollowModel {
  FollowModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<fDatum> data;

  factory FollowModel.fromJson(Map<String, dynamic> json) => FollowModel(
    message: json["message"],
    status: json["status"],
    data: List<fDatum>.from(json["data"].map((x) => fDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class fDatum {
  fDatum({
    required this.tblFollowingId,
    required this.username,
    required this.followingUserId,
    required this.image,
  });

  String tblFollowingId;
  String username;
  String followingUserId;
  String image;

  factory fDatum.fromJson(Map<String, dynamic> json) => fDatum(
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
