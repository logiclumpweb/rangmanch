



// To parse this JSON data, do
//
//     final packageTrasListModel = packageTrasListModelFromJson(jsonString);

import 'dart:convert';

PackageTrasListModel packageTrasListModelFromJson(String str) => PackageTrasListModel.fromJson(json.decode(str));

String packageTrasListModelToJson(PackageTrasListModel data) => json.encode(data.toJson());

class PackageTrasListModel {
  String message;
  String status;
  List<PKGTRDatum> data;

  PackageTrasListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory PackageTrasListModel.fromJson(Map<String, dynamic> json) => PackageTrasListModel(
    message: json["message"],
    status: json["status"],
    data: List<PKGTRDatum>.from(json["data"].map((x) => PKGTRDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PKGTRDatum {
  String lastId;
  String packageId;
  String packageName;
  String amount;
  String tokens;
  String status;
  String createdDate;

  PKGTRDatum({
    required this.lastId,
    required this.packageId,
    required this.packageName,
    required this.amount,
    required this.tokens,
    required this.status,
    required this.createdDate,
  });

  factory PKGTRDatum.fromJson(Map<String, dynamic> json) => PKGTRDatum(
    lastId: json["last_id"],
    packageId: json["package_id"],
    packageName: json["package_name"],
    amount: json["amount"],
    tokens: json["tokens"],
    status: json["status"],
    createdDate:json["created_date"],
  );

  Map<String, dynamic> toJson() => {
    "last_id": lastId,
    "package_id": packageId,
    "package_name": packageName,
    "amount": amount,
    "tokens": tokens,
    "status": status,
    "created_date": createdDate,
  };
}
