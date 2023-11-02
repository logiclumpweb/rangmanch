// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  Categories({
    required this.message,
    required this.channelId,
    required this.status,
    required this.data,
  });

  String message;
  String channelId;
  String status;
  List<Catg> data;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    message: json["message"],
    channelId: json["channel_id"],
    status: json["status"],
    data: List<Catg>.from(json["data"].map((x) => Catg.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "channel_id": channelId,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Catg {
  Catg({
    required this.tblVideoCategoryId,
    required this.name,
    required this.channel,
    required this.image,
    required this.icon,
  });

  String tblVideoCategoryId;
  String name;
  String channel;
  String image;
  String icon;

  factory Catg.fromJson(Map<String, dynamic> json) => Catg(
    tblVideoCategoryId: json["tbl_video_category_id"],
    name: json["name"],
    channel: json["channel"],
    image: json["image"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_video_category_id": tblVideoCategoryId,
    "name": name,
    "channel": channel,
    "image": image,
    "icon": icon,
  };
}
