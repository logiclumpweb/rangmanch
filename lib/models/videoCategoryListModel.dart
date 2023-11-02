// To parse this JSON data, do
//
//     final videoCategoryListModel = videoCategoryListModelFromJson(jsonString);

import 'dart:convert';

VideoCategoryListModel videoCategoryListModelFromJson(String str) => VideoCategoryListModel.fromJson(json.decode(str));

String videoCategoryListModelToJson(VideoCategoryListModel data) => json.encode(data.toJson());

class VideoCategoryListModel {
  VideoCategoryListModel({
    required this.message,
    required this.channelId,
    required this.status,
    required this.data,
  });

  String message;
  String channelId;
  String status;
  List<vCategoryDatum> data;

  factory VideoCategoryListModel.fromJson(Map<String, dynamic> json) => VideoCategoryListModel(
    message: json["message"],
    channelId: json["channel_id"],
    status: json["status"],
    data: List<vCategoryDatum>.from(json["data"].map((x) => vCategoryDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "channel_id": channelId,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class vCategoryDatum {
  vCategoryDatum({
    required this.tblVideoCategoryId,
    required this.name,
    required this.channel,
    required this.image,
    required this.icon,
    required this.isSelected
  });

  String tblVideoCategoryId;
  String name;
  String channel;
  String image;
  String icon;
  bool isSelected;

  factory vCategoryDatum.fromJson(Map<String, dynamic> json) => vCategoryDatum(
    tblVideoCategoryId: json["tbl_video_category_id"],
    name: json["name"],
    channel: json["channel"]!,
    image: json["image"],
    icon: json["icon"],
    isSelected: false
  );

  Map<String, dynamic> toJson() => {
    "tbl_video_category_id": tblVideoCategoryId,
    "name": name,
    "channel": channel,
    "image": image,
    "icon": icon,
  };
}

