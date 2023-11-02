// To parse this JSON data, do
//
//     final issueListModel = issueListModelFromJson(jsonString);

import 'dart:convert';

IssueListModel issueListModelFromJson(String str) =>
    IssueListModel.fromJson(json.decode(str));

String issueListModelToJson(IssueListModel data) => json.encode(data.toJson());

class IssueListModel {
  IssueListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<RPTDatum> data;

  factory IssueListModel.fromJson(Map<String, dynamic> json) => IssueListModel(
        message: json["message"],
        status: json["status"],
        data: List<RPTDatum>.from(
            json["data"].map((x) => RPTDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RPTDatum {
  RPTDatum({
    required this.videoIssueListId,
    required this.title,
    required this.icon,
  });

  String videoIssueListId;
  String title;
  String icon;

  factory RPTDatum.fromJson(Map<String, dynamic> json) => RPTDatum(
        videoIssueListId: json["video_issue_list_id"],
        title: json["title"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "video_issue_list_id": videoIssueListId,
        "title": title,
        "icon": icon,
      };
}
