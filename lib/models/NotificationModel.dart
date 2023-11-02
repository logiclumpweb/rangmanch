




// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  String message;
  String status;
  List<NFFDatum> data;

  NotificationModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    message: json["message"],
    status: json["status"],
    data: List<NFFDatum>.from(json["data"].map((x) => NFFDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NFFDatum {
  String lastId;
  String tblUserNotificationList;
  String userId;
  String userImage;
  String type;
  String time;
  String msg;
  String postId;
  String postImage;

  NFFDatum({
    required this.lastId,
    required this.tblUserNotificationList,
    required this.userId,
    required this.userImage,
    required this.type,
    required this.time,
    required this.msg,
    required this.postId,
    required this.postImage,
  });

  factory NFFDatum.fromJson(Map<String, dynamic> json) => NFFDatum(
    lastId: json["last_id"],
    tblUserNotificationList: json["tbl_user_notification_list"],
    userId: json["user_id"],
    userImage: json["user_image"],
    type: json["type"],
    time: json["time"],
    msg: json["msg"],
    postId: json["post_id"],
    postImage: json["post_image"],
  );

  Map<String, dynamic> toJson() => {
    "last_id": lastId,
    "tbl_user_notification_list": tblUserNotificationList,
    "user_id": userId,
    "user_image": userImage,
    "type": type,
    "time": time,
    "msg": msg,
    "post_id": postId,
    "post_image": postImage,
  };
}
