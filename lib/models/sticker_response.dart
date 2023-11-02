//import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'dart:convert';

StickerResponse stickerResponseFromJson(String str) => StickerResponse.fromJson(json.decode(str));

String stickerResponseToJson(StickerResponse data) => json.encode(data.toJson());

class StickerResponse {
  StickerResponse({
    required this.apiKey,
    required this.name,
    required this.description,
    required this.status,
    required this.categories,
    required this.lastUpdatedAt,
  });

  final String apiKey;
  final String name;
  final String description;
  final String status;
  final List<Category> categories;
  final String lastUpdatedAt;

  factory StickerResponse.fromJson(Map<String, dynamic> json) => StickerResponse(
    apiKey: json["api_key"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "api_key": apiKey,
    "name": name,
    "description": description,
    "status": status,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt,
  };
}

class Category {
  Category({
    required this.uuid,
    required this.slotNo,
    required this.title,
    required this.description,
    required this.isBundle,
    required this.updatedAt,
    required this.division,
    required this.level,
    required this.status,
    required this.countries,
    required this.parentCategoryUuid,
  });

  final String uuid;
  final int slotNo;
  final String title;
  final String description;
  final bool isBundle;
  final int updatedAt;
  //final List<ItemModel> items;
  final int division;
  final int level;
  final String status;
  final dynamic countries;
  final dynamic parentCategoryUuid;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    uuid: json["uuid"],
    slotNo: json["slot_no"],
    title: json["title"],
    description: json["description"],
    isBundle: json["is_bundle"],
    updatedAt: json["updated_at"],
    //items: List<ItemModel>.from(json["items"].map((x) => ItemModel.fromJson(x))),
    division: json["division"],
    level: json["level"],
    status: json["status"],
    countries: json["countries"],
    parentCategoryUuid: json["parentCategoryUuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "slot_no": slotNo,
    "title": title,
    "description": description,
    "is_bundle": isBundle,
    "updated_at": updatedAt,
    //"items": List<dynamic>.from(items.map((x) => x.toJson())),
    "division": division,
    "level": level,
    "status": status,
    "countries": countries,
    "parentCategoryUuid": parentCategoryUuid,
  };
}

