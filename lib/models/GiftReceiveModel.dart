// To parse this JSON data, do
//
//     final giftReceiveModel = giftReceiveModelFromJson(jsonString);

import 'dart:convert';

GiftReceiveModel giftReceiveModelFromJson(String str) =>
    GiftReceiveModel.fromJson(json.decode(str));

String giftReceiveModelToJson(GiftReceiveModel data) =>
    json.encode(data.toJson());

class GiftReceiveModel {
  String message;
  String status;
  List<GFTRDatum> data;

  GiftReceiveModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory GiftReceiveModel.fromJson(Map<String, dynamic> json) =>
      GiftReceiveModel(
        message: json["message"],
        status: json["status"],
        data: List<GFTRDatum>.from(
            json["data"].map((x) => GFTRDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GFTRDatum {
  String tblSendGiftHistoryId;
  String senderId;
  String receiverId;
  String tblGiftId;
  String tokens;
  String totalNoOfSticker;
  String name;
  String image;
  String username;
  String userImage;
  String sendDate;
  String sendTime;

  GFTRDatum({
    required this.tblSendGiftHistoryId,
    required this.senderId,
    required this.receiverId,
    required this.tblGiftId,
    required this.tokens,
    required this.totalNoOfSticker,
    required this.name,
    required this.image,
    required this.username,
    required this.userImage,
    required this.sendDate,
    required this.sendTime,
  });

  factory GFTRDatum.fromJson(Map<String, dynamic> json) => GFTRDatum(
        tblSendGiftHistoryId: json["tbl_send_gift_history_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        tblGiftId: json["tbl_gift_id"],
        tokens: json["tokens"],
        totalNoOfSticker: json["total_no_of_sticker"],
        name: json["name"],
        image: json["image"],
        username: json["username"],
        userImage: json["user_image"],
        sendDate: json["send_date"],
        sendTime: json["sendTime"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_send_gift_history_id": tblSendGiftHistoryId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "tbl_gift_id": tblGiftId,
        "tokens": tokens,
        "total_no_of_sticker": totalNoOfSticker,
        "name": name,
        "image": image,
        "username": username,
        "user_image": userImage,
        "send_date": sendDate,
        "sendTime": sendTime,
      };
}

// To parse this JSON data, do
//
//     final giftSendModel = giftSendModelFromJson(jsonString);

GiftSendModel giftSendModelFromJson(String str) =>
    GiftSendModel.fromJson(json.decode(str));

String giftSendModelToJson(GiftSendModel data) => json.encode(data.toJson());

class GiftSendModel {
  String message;
  String status;
  List<GFTSDDatum> data;

  GiftSendModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory GiftSendModel.fromJson(Map<String, dynamic> json) => GiftSendModel(
        message: json["message"],
        status: json["status"],
        data: List<GFTSDDatum>.from(
            json["data"].map((x) => GFTSDDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GFTSDDatum {
  String tblSendGiftHistoryId;
  String senderId;
  String receiverId;
  String tblGiftId;
  String tokens;
  String totalNoOfSticker;
  String name;
  String image;
  String username;
  String userImage;
  String sendDate;
  String sendTime;

  GFTSDDatum({
    required this.tblSendGiftHistoryId,
    required this.senderId,
    required this.receiverId,
    required this.tblGiftId,
    required this.tokens,
    required this.totalNoOfSticker,
    required this.name,
    required this.image,
    required this.username,
    required this.userImage,
    required this.sendDate,
    required this.sendTime,
  });

  factory GFTSDDatum.fromJson(Map<String, dynamic> json) => GFTSDDatum(
        tblSendGiftHistoryId: json["tbl_send_gift_history_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        tblGiftId: json["tbl_gift_id"],
        tokens: json["tokens"],
        totalNoOfSticker: json["total_no_of_sticker"],
        name: json["name"],
        image: json["image"],
        username: json["username"],
        userImage: json["user_image"],
        sendDate: json["send_date"],
        sendTime: json["sendTime"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_send_gift_history_id": tblSendGiftHistoryId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "tbl_gift_id": tblGiftId,
        "tokens": tokens,
        "total_no_of_sticker": totalNoOfSticker,
        "name": name,
        "image": image,
        "username": username,
        "user_image": userImage,
        "send_date": sendDate,
        "sendTime": sendTime,
      };
}
