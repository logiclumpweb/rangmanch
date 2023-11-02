// To parse this JSON data, do
//
//     final userLikedVideoListModel = userLikedVideoListModelFromJson(jsonString);

import 'dart:convert';

UserLikedVideoListModel userLikedVideoListModelFromJson(String str) =>
    UserLikedVideoListModel.fromJson(json.decode(str));

String userLikedVideoListModelToJson(UserLikedVideoListModel data) =>
    json.encode(data.toJson());

class UserLikedVideoListModel {
  UserLikedVideoListModel({
    required this.message,
    required this.status,
    required this.tagCount,
    required this.data,
  });

  String message;
  String status;
  String tagCount;
  List<likeVideoDatum> data;

  factory UserLikedVideoListModel.fromJson(Map<String, dynamic> json) =>
      UserLikedVideoListModel(
        message: json["message"],
        status: json["status"],
        tagCount: json["tag_count"],
        data: List<likeVideoDatum>.from(
            json["data"].map((x) => likeVideoDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "tag_count": tagCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class likeVideoDatum {
  likeVideoDatum(
      {required this.lastId,
      required this.tblVedioId,
      required this.userId,
      required this.userImage,
      required this.username,
      required this.tag,
      required this.videoBitrate,
      required this.videoResolution,
      required this.totalSoundUsed,
      required this.videoLikes,
      required this.likes,
      required this.comments,
      required this.share,
      required this.follow,
      required this.videoThumb,
      required this.videoViewCount,
      required this.tblVideoSoundId,
      required this.soundImage,
      required this.soundUserName,
      required this.videoName,
      required this.video,
      required this.profileVerified});

  String lastId;
  String tblVedioId;
  String userId;
  String userImage;
  String username;
  String tag;
  String videoBitrate;
  String videoResolution;
  String totalSoundUsed;
  String videoLikes;
  String likes;
  String comments;
  String share;
  String follow;
  String videoThumb;
  String videoViewCount;
  String tblVideoSoundId;
  String soundImage;
  String soundUserName;
  String videoName;
  String video;
  String profileVerified;

  factory likeVideoDatum.fromJson(Map<String, dynamic> json) => likeVideoDatum(
      lastId: json["last_id"],
      tblVedioId: json["tbl_vedio_id"],
      userId: json["user_id"],
      userImage: json["user_image"],
      username: json["username"],
      tag: json["tag"],
      videoBitrate: json["Video_Bitrate"],
      videoResolution: json["Video_Resolution"],
      totalSoundUsed: json["total_sound_used"],
      videoLikes: json["video_likes"],
      likes: json["likes"],
      comments: json["comments"],
      share: json["share"],
      follow: json["follow"],
      videoThumb: json["video_thumb"],
      videoViewCount: json["video_view_count"],
      tblVideoSoundId: json["tbl_video_sound_id"],
      soundImage: json["sound_image"],
      soundUserName: json["sound_user_name"],
      videoName: json["video_name"],
      video: json["video"],
      profileVerified: json["profile_verified"]);

  Map<String, dynamic> toJson() => {
        "last_id": lastId,
        "tbl_vedio_id": tblVedioId,
        "user_id": userId,
        "user_image": userImage,
        "username": username,
        "tag": tag,
        "Video_Bitrate": videoBitrate,
        "Video_Resolution": videoResolution,
        "total_sound_used": totalSoundUsed,
        "video_likes": videoLikes,
        "likes": likes,
        "comments": comments,
        "share": share,
        "follow": follow,
        "video_thumb": videoThumb,
        "video_view_count": videoViewCount,
        "tbl_video_sound_id": tblVideoSoundId,
        "sound_image": soundImage,
        "sound_user_name": soundUserName,
        "video_name": videoName,
        "video": video,
        "profile_verified": profileVerified
      };
}
