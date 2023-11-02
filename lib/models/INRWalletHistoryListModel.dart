// To parse this JSON data, do
//
//     final inrWalletHistoryListModel = inrWalletHistoryListModelFromJson(jsonString);

import 'dart:convert';

InrWalletHistoryListModel inrWalletHistoryListModelFromJson(String str) =>
    InrWalletHistoryListModel.fromJson(json.decode(str));

String inrWalletHistoryListModelToJson(InrWalletHistoryListModel data) =>
    json.encode(data.toJson());

class InrWalletHistoryListModel {
  InrWalletHistoryListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<INRWaletDatum> data;

  factory InrWalletHistoryListModel.fromJson(Map<String, dynamic> json) =>
      InrWalletHistoryListModel(
        message: json["message"],
        status: json["status"],
        data: List<INRWaletDatum>.from(json["data"].map((x) => INRWaletDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class INRWaletDatum {
  INRWaletDatum({
    required this.tblWalletHistoryId,
    required this.userId,
    required this.amount,
    required this.amountType,
    required this.trasectionType,
    required this.trasectionDate,
    required this.createdDate,
  });

  String tblWalletHistoryId;
  String userId;
  String amount;
  String amountType;
  String trasectionType;
  String trasectionDate;
  String createdDate;

  factory INRWaletDatum.fromJson(Map<String, dynamic> json) => INRWaletDatum(
        tblWalletHistoryId: json["tbl_wallet_history_id"],
        userId: json["user_id"],
        amount: json["amount"],
        amountType: json["amount_type"],
        trasectionType: json["trasection_type"],
        trasectionDate: json["trasection_date"],
        createdDate: json["created_date"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_wallet_history_id": tblWalletHistoryId,
        "user_id": userId,
        "amount": amount,
        "amount_type": amountType,
        "trasection_type": trasectionType,
        "trasection_date": trasectionDate,
        "created_date": createdDate,
      };
}
