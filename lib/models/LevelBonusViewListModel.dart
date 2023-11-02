// To parse this JSON data, do
//
//     final levelBonusViewListModel = levelBonusViewListModelFromJson(jsonString);

import 'dart:convert';

LevelBonusViewListModel levelBonusViewListModelFromJson(String str) => LevelBonusViewListModel.fromJson(json.decode(str));

String levelBonusViewListModelToJson(LevelBonusViewListModel data) => json.encode(data.toJson());

class LevelBonusViewListModel {
  LevelBonusViewListModel({
   required this.message,
   required this.status,
   required this.totalIncome,
   required this.data,
  });

  String message;
  String status;
  String totalIncome;
  List<levelDatum> data;

  factory LevelBonusViewListModel.fromJson(Map<String, dynamic> json) => LevelBonusViewListModel(
    message: json["message"],
    status: json["status"],
    totalIncome: json["total_income"],
    data: List<levelDatum>.from(json["data"].map((x) => levelDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "total_income": totalIncome,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class levelDatum {
  levelDatum({
   required this.level,
   required this.levelValue,
   required this.totalcount,
   required this.totalActivecount,
   required this.totalLevelIncom,
  });

  String level;
  String levelValue;
  String totalcount;
  String totalActivecount;
  String totalLevelIncom;

  factory levelDatum.fromJson(Map<String, dynamic> json) => levelDatum(
    level: json["level"],
    levelValue: json["level_value"],
    totalcount: json["totalcount"],
    totalActivecount: json["total_activecount"],
    totalLevelIncom: json["total_level_incom"],
  );

  Map<String, dynamic> toJson() => {
    "level": level,
    "level_value": levelValue,
    "totalcount": totalcount,
    "total_activecount": totalActivecount,
    "total_level_incom": totalLevelIncom,
  };
}
