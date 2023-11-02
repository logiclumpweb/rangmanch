// To parse this JSON data, do
//
//     final badgesListModel = badgesListModelFromJson(jsonString);

import 'dart:convert';

BadgesListModel badgesListModelFromJson(String str) => BadgesListModel.fromJson(json.decode(str));

String badgesListModelToJson(BadgesListModel data) => json.encode(data.toJson());

class BadgesListModel {
  BadgesListModel({
   required this.message,
   required this.status,
   required this.data,
  });

  String message;
  String status;
  List<BadgesDatum> data;

  factory BadgesListModel.fromJson(Map<String, dynamic> json) => BadgesListModel(
    message: json["message"],
    status: json["status"],
    data: List<BadgesDatum>.from(json["data"].map((x) => BadgesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BadgesDatum {
  BadgesDatum({
   required this.tblBatchesListId,
   required this.noOfOud,
   required this.noOfFollower,
   required this.noOfLike,
   required this.batchesName,
   required this.batchesImage,
  });

  String tblBatchesListId;
  String noOfOud;
  String noOfFollower;
  String noOfLike;
  String batchesName;
  String batchesImage;

  factory BadgesDatum.fromJson(Map<String, dynamic> json) => BadgesDatum(
    tblBatchesListId: json["tbl_batches_list_id"],
    noOfOud: json["no_of_oud"],
    noOfFollower: json["no_of_follower"],
    noOfLike: json["no_of_like"],
    batchesName: json["batches_name"],
    batchesImage: json["batches_image"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_batches_list_id": tblBatchesListId,
    "no_of_oud": noOfOud,
    "no_of_follower": noOfFollower,
    "no_of_like": noOfLike,
    "batches_name": batchesName,
    "batches_image": batchesImage,
  };
}
