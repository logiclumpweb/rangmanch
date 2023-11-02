// To parse this JSON data, do
//
//     final languages = languagesFromJson(jsonString);

import 'dart:convert';

Languages languagesFromJson(String str) => Languages.fromJson(json.decode(str));

String languagesToJson(Languages data) => json.encode(data.toJson());

class Languages {
  Languages({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<Language> data;

  factory Languages.fromJson(Map<String, dynamic> json) => Languages(
    message: json["message"],
    status: json["status"],
    data: List<Language>.from(json["data"].map((x) => Language.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Language {
  Language({
    required this.tblLanguageId,
    required this.name,
  });

  String tblLanguageId;
  String name;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    tblLanguageId: json["tbl_language_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_language_id": tblLanguageId,
    "name": name,
  };
}
