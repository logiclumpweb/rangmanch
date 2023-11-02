// To parse this JSON data, do
//
//     final levelDetailsViewListModel = levelDetailsViewListModelFromJson(jsonString);

import 'dart:convert';

LevelDetailsViewListModel levelDetailsViewListModelFromJson(String str) =>
    LevelDetailsViewListModel.fromJson(json.decode(str));

String levelDetailsViewListModelToJson(LevelDetailsViewListModel data) =>
    json.encode(data.toJson());

class LevelDetailsViewListModel {
  LevelDetailsViewListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<LDetailsDatum> data;

  factory LevelDetailsViewListModel.fromJson(Map<String, dynamic> json) =>
      LevelDetailsViewListModel(
        message: json["message"],
        status: json["status"],
        data: List<LDetailsDatum>.from(json["data"].map((x) => LDetailsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LDetailsDatum {
  LDetailsDatum({
    required this.tblLevelTeamId,
    required this.usedReferalCode,
    required this.referalCode,
    required this.income,
    required this.name,
    required this.amountType,
    required this.mobile,
    required this.image,
  });

  String tblLevelTeamId;
  String usedReferalCode;
  String referalCode;
  String income;
  String name;
  String amountType;
  String mobile;
  String image;

  factory LDetailsDatum.fromJson(Map<String, dynamic> json) => LDetailsDatum(
        tblLevelTeamId: json["tbl_level_team_id"],
        usedReferalCode: json["used_referal_code"],
        referalCode: json["referal_code"],
        income: json["income"],
        name: json["name"],
        amountType: json["amount_type"],
        mobile: json["mobile"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_level_team_id": tblLevelTeamId,
        "used_referal_code": usedReferalCode,
        "referal_code": referalCode,
        "income": income,
        "name": name,
        "amount_type": amountType,
        "mobile": mobile,
        "image": image,
      };
}
