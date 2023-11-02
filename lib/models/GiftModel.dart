// To parse this JSON data, do
//
//     final giftModel = giftModelFromJson(jsonString);

import 'dart:convert';

GiftModel giftModelFromJson(String str) => GiftModel.fromJson(json.decode(str));

String giftModelToJson(GiftModel data) => json.encode(data.toJson());

class GiftModel {
  String message;
  String status;
  List<GFTDatum> data;

  GiftModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        message: json["message"],
        status: json["status"],
        data:
            List<GFTDatum>.from(json["data"].map((x) => GFTDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GFTDatum {
  String tblGiftCategoryId;
  String name;
  List<GiftList> giftList;
  bool isSelected;

  GFTDatum(
      {required this.tblGiftCategoryId,
      required this.name,
      required this.giftList,
      required this.isSelected});

  factory GFTDatum.fromJson(Map<String, dynamic> json) => GFTDatum(
        tblGiftCategoryId: json["tbl_gift_category_id"],
        name: json["name"],
        isSelected: false,
        giftList: List<GiftList>.from(
            json["gift_list"].map((x) => GiftList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tbl_gift_category_id": tblGiftCategoryId,
        "name": name,
        "gift_list": List<dynamic>.from(giftList.map((x) => x.toJson())),
      };
}

class GiftList {
  String tblGiftId;
  String name;
  String token;
  String tblGiftCategoryId;
  String image;
  bool isGiftSelected;

  GiftList(
      {required this.tblGiftId,
      required this.name,
      required this.token,
      required this.tblGiftCategoryId,
      required this.image,
      required this.isGiftSelected});

  factory GiftList.fromJson(Map<String, dynamic> json) => GiftList(
      tblGiftId: json["tbl_gift_id"],
      name: json["name"],
      token: json["token"],
      tblGiftCategoryId: json["tbl_gift_category_id"],
      image: json["image"],
      isGiftSelected: false);

  Map<String, dynamic> toJson() => {
        "tbl_gift_id": tblGiftId,
        "name": name,
        "token": token,
        "tbl_gift_category_id": tblGiftCategoryId,
        "image": image,
      };
}
