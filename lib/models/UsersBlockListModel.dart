// To parse this JSON data, do
//
//     final userBlockListModel = userBlockListModelFromJson(jsonString);

import 'dart:convert';

UserBlockListModel userBlockListModelFromJson(String str) =>
    UserBlockListModel.fromJson(json.decode(str));

String userBlockListModelToJson(UserBlockListModel data) =>
    json.encode(data.toJson());

class UserBlockListModel {
  String message;
  String status;
  List<BLKDatum> data;

  UserBlockListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory UserBlockListModel.fromJson(Map<String, dynamic> json) =>
      UserBlockListModel(
        message: json["message"],
        status: json["status"],
        data:
            List<BLKDatum>.from(json["data"].map((x) => BLKDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BLKDatum {
  String tblBlockUserId;
  String blockedUserId;
  String blockedUsername;
  String blockedUserimage;

  BLKDatum({
    required this.tblBlockUserId,
    required this.blockedUserId,
    required this.blockedUsername,
    required this.blockedUserimage,
  });

  factory BLKDatum.fromJson(Map<String, dynamic> json) => BLKDatum(
        tblBlockUserId: json["tbl_block_user_id"],
        blockedUserId: json["blocked_user_id"],
        blockedUsername: json["blocked_username"],
        blockedUserimage: json["blocked_userimage"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_block_user_id": tblBlockUserId,
        "blocked_user_id": blockedUserId,
        "blocked_username": blockedUsername,
        "blocked_userimage": blockedUserimage,
      };
}
