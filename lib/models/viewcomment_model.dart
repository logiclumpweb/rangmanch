// To parse this JSON data, do
//
//     final viewcommentModel = viewcommentModelFromJson(jsonString);

import 'dart:convert';

ViewcommentModel viewcommentModelFromJson(String str) =>
    ViewcommentModel.fromJson(json.decode(str));

String viewcommentModelToJson(ViewcommentModel data) =>
    json.encode(data.toJson());

class ViewcommentModel {
  ViewcommentModel({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<cDatum> data;

  factory ViewcommentModel.fromJson(Map<String, dynamic> json) =>
      ViewcommentModel(
        message: json["message"],
        status: json["status"],
        data: List<cDatum>.from(json["data"].map((x) => cDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class cDatum {
  cDatum(
      {required this.tblVideoCommentsId,
      required this.username,
      required this.userImage,
      required this.totalCmtLike,
      required this.commentsLike,
      required this.userId,
      required this.type,
      required this.videoOwnerId,
      required this.comments,
      required this.time,
      required this.replyUI,
      required this.commentsRepyData,
      required this.isReplySelected});

  String tblVideoCommentsId;
  String username;
  String userImage;
  String totalCmtLike;
  String commentsLike;
  String userId;
  String type;
  String videoOwnerId;
  String comments;
  String time;
  bool replyUI;
  bool isReplySelected;
  List<CommentsReplyDatum> commentsRepyData;

  factory cDatum.fromJson(Map<String, dynamic> json) => cDatum(
        tblVideoCommentsId: json["tbl_video_comments_id"],
        username: json["username"],
        userImage: json["user_image"],
        totalCmtLike: json["total_cmt_like"],
        commentsLike: json["comments_like"],
        userId: json["user_id"],
        type: json["type"],
        videoOwnerId: json["video_owner_id"],
        comments: json["comments"],
        time: json["time"],
        replyUI: false,
        isReplySelected: false,
        commentsRepyData: List<CommentsReplyDatum>.from(
            json["comments_repy_data"]
                .map((x) => CommentsReplyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tbl_video_comments_id": tblVideoCommentsId,
        "username": username,
        "user_image": userImage,
        "total_cmt_like": totalCmtLike,
        "comments_like": commentsLike,
        "user_id": userId,
        "type": type,
        "video_owner_id": videoOwnerId,
        "comments": comments,
        "time": time,
        "comments_repy_data":
            List<dynamic>.from(commentsRepyData.map((x) => x.toJson())),
      };
}

class CommentsReplyDatum {
  CommentsReplyDatum({
    required this.tblCommentsReplyId,
    required this.username,
    required this.userImage,
    required this.totalCmtLike,
    required this.commentsLike,
    required this.userId,
    required this.type,
    required this.commentId,
    required this.comments,
    required this.time,
  });

  String tblCommentsReplyId;
  String username;
  String userImage;
  String totalCmtLike;
  String commentsLike;
  String userId;
  String type;
  String commentId;
  String comments;
  String time;

  factory CommentsReplyDatum.fromJson(Map<String, dynamic> json) =>
      CommentsReplyDatum(
        tblCommentsReplyId: json["tbl_comments_reply_id"],
        username: json["username"],
        userImage: json["user_image"],
        totalCmtLike: json["total_cmt_like"],
        commentsLike: json["comments_like"],
        userId: json["user_id"],
        type: json["type"],
        commentId: json["comment_id"],
        comments: json["comments"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_comments_reply_id": tblCommentsReplyId,
        "username": username,
        "user_image": userImage,
        "total_cmt_like": totalCmtLike,
        "comments_like": commentsLike,
        "user_id": userId,
        "type": type,
        "comment_id": commentId,
        "comments": comments,
        "time": time,
      };
}
