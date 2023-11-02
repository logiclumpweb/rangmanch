

// To parse this JSON data, do
//
//     final packageListModel = packageListModelFromJson(jsonString);

import 'dart:convert';

PackageListModel packageListModelFromJson(String str) => PackageListModel.fromJson(json.decode(str));

String packageListModelToJson(PackageListModel data) => json.encode(data.toJson());

class PackageListModel {
  String message;
  String status;
  List<PKGDatum> data;

  PackageListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory PackageListModel.fromJson(Map<String, dynamic> json) => PackageListModel(
    message: json["message"],
    status: json["status"],
    data: List<PKGDatum>.from(json["data"].map((x) => PKGDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PKGDatum {
  String lastId;
  String tblPackageId;
  String packageName;
  String amount;
  String tokens;

  PKGDatum({
    required this.lastId,
    required this.tblPackageId,
    required this.packageName,
    required this.amount,
    required this.tokens,
  });

  factory PKGDatum.fromJson(Map<String, dynamic> json) => PKGDatum(
    lastId: json["last_id"],
    tblPackageId: json["tbl_package_id"],
    packageName: json["package_name"],
    amount: json["amount"],
    tokens: json["tokens"],
  );

  Map<String, dynamic> toJson() => {
    "last_id": lastId,
    "tbl_package_id": tblPackageId,
    "package_name": packageName,
    "amount": amount,
    "tokens": tokens,
  };
}
