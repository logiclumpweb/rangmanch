// To parse this JSON data, do
//
//     final bankDetailsModel = bankDetailsModelFromJson(jsonString);

import 'dart:convert';

BankDetailsModel bankDetailsModelFromJson(String str) =>
    BankDetailsModel.fromJson(json.decode(str));

String bankDetailsModelToJson(BankDetailsModel data) =>
    json.encode(data.toJson());

class BankDetailsModel {
  BankDetailsModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  Data data;

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) =>
      BankDetailsModel(
        message: json["message"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.tblBankDetailId,
    required this.userName,
    required this.bankName,
    required this.ifscCode,
    required this.accountNumber,
    required this.branchName,
  });

  String tblBankDetailId;
  String userName;
  String bankName;
  String ifscCode;
  String accountNumber;
  String branchName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        tblBankDetailId: json["tbl_bank_detail_id"],
        userName: json["user_name"],
        bankName: json["bank_name"],
        ifscCode: json["ifsc_code"],
        accountNumber: json["account_number"],
        branchName: json["branch_name"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_bank_detail_id": tblBankDetailId,
        "user_name": userName,
        "bank_name": bankName,
        "ifsc_code": ifscCode,
        "account_number": accountNumber,
        "branch_name": branchName,
      };
}
