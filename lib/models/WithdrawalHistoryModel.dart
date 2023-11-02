// To parse this JSON data, do
//
//     final withdrawalHistoryModel = withdrawalHistoryModelFromJson(jsonString);

import 'dart:convert';

WithdrawalHistoryModel withdrawalHistoryModelFromJson(String str) => WithdrawalHistoryModel.fromJson(json.decode(str));

String withdrawalHistoryModelToJson(WithdrawalHistoryModel data) => json.encode(data.toJson());

class WithdrawalHistoryModel {
  WithdrawalHistoryModel({
   required this.message,
   required this.status,
   required this.data,
  });

  String message;
  String status;
  List<WHDatum> data;

  factory WithdrawalHistoryModel.fromJson(Map<String, dynamic> json) => WithdrawalHistoryModel(
    message: json["message"],
    status: json["status"],
    data: List<WHDatum>.from(json["data"].map((x) => WHDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WHDatum {
  WHDatum({
   required this.tblPayoutRequestId,
   required this.paymentType,
   required this.amount,
   required this.payoutStatus,
   required this.remark,
   required this.createdDate,
  });

  String tblPayoutRequestId;
  String paymentType;
  String amount;
  String payoutStatus;
  String remark;
  DateTime createdDate;

  factory WHDatum.fromJson(Map<String, dynamic> json) => WHDatum(
    tblPayoutRequestId: json["tbl_payout_request_id"],
    paymentType: json["payment_type"],
    amount: json["amount"],
    payoutStatus: json["payout_status"],
    remark: json["remark"],
    createdDate: DateTime.parse(json["created_date"]),
  );

  Map<String, dynamic> toJson() => {
    "tbl_payout_request_id": tblPayoutRequestId,
    "payment_type": paymentType,
    "amount": amount,
    "payout_status": payoutStatus,
    "remark": remark,
    "created_date": createdDate.toIso8601String(),
  };
}
