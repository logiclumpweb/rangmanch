// To parse this JSON data, do
//
//     final userReportModel = userReportModelFromJson(jsonString);

import 'dart:convert';

UserReportModel userReportModelFromJson(String str) => UserReportModel.fromJson(json.decode(str));

String userReportModelToJson(UserReportModel data) => json.encode(data.toJson());

class UserReportModel {
  UserReportModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<RDatum> data;

  factory UserReportModel.fromJson(Map<String, dynamic> json) => UserReportModel(
    status: json["status"],
    message: json["message"],
    data: List<RDatum>.from(json["data"].map((x) => RDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RDatum {
  RDatum({
    required this.tblReportId,
    required this.report,
    required this.isSelected
  });

  int tblReportId;
  String report;
  bool isSelected;

  factory RDatum.fromJson(Map<String, dynamic> json) => RDatum(
    tblReportId: json["tbl_report_id"],
    report: json["report"],
    isSelected: false
  );

  Map<String, dynamic> toJson() => {
    "tbl_report_id": tblReportId,
    "report": report,
  };
}
