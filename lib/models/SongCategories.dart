// To parse this JSON data, do
//
//     final songCategoris = songCategorisFromJson(jsonString);

import 'dart:convert';

SongCategoris songCategorisFromJson(String str) => SongCategoris.fromJson(json.decode(str));

String songCategorisToJson(SongCategoris data) => json.encode(data.toJson());

class SongCategoris {
  SongCategoris({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<SongCategory> data;

  factory SongCategoris.fromJson(Map<String, dynamic> json) => SongCategoris(
    message: json["message"],
    status: json["status"],
    data: List<SongCategory>.from(json["data"].map((x) => SongCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SongCategory {
  SongCategory({
    required this.tblSoundCategoryId,
    required this.name,
    required this.image,
  });

  String tblSoundCategoryId;
  String name;
  String image;

  factory SongCategory.fromJson(Map<String, dynamic> json) => SongCategory(
    tblSoundCategoryId: json["tbl_sound_category_id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_sound_category_id": tblSoundCategoryId,
    "name": name,
    "image": image,
  };
}
