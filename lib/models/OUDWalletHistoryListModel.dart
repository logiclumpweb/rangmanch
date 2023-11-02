// To parse this JSON data, do
//
//     final oudWalletHistoryListModel = oudWalletHistoryListModelFromJson(jsonString);

import 'dart:convert';

OudWalletHistoryListModel oudWalletHistoryListModelFromJson(String str) => OudWalletHistoryListModel.fromJson(json.decode(str));

String oudWalletHistoryListModelToJson(OudWalletHistoryListModel data) => json.encode(data.toJson());

class OudWalletHistoryListModel {
  OudWalletHistoryListModel({
   required this.message,
   required this.status,
   required this.data,
  });

  String message;
  String status;
  List<OUDHistoryDatum> data;

  factory OudWalletHistoryListModel.fromJson(Map<String, dynamic> json) => OudWalletHistoryListModel(
    message: json["message"],
    status: json["status"],
    data: List<OUDHistoryDatum>.from(json["data"].map((x) => OUDHistoryDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OUDHistoryDatum {
  OUDHistoryDatum({
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
  dynamic amount;
  String amountType;
  String trasectionType;
  String trasectionDate;
  String createdDate;

  factory OUDHistoryDatum.fromJson(Map<String, dynamic> json) => OUDHistoryDatum(
    tblWalletHistoryId: json["tbl_wallet_history_id"],
    userId: json["user_id"],
    amount: json["amount"].toDouble(),
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



