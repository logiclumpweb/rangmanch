// To parse this JSON data, do
//
//     final userUplodedVideoListModel = userUplodedVideoListModelFromJson(jsonString);

import 'dart:convert';

UserUplodedVideoListModel userUplodedVideoListModelFromJson(String str) =>
    UserUplodedVideoListModel.fromJson(json.decode(str));

String userUplodedVideoListModelToJson(UserUplodedVideoListModel data) =>
    json.encode(data.toJson());

class UserUplodedVideoListModel {
  UserUplodedVideoListModel({
    required this.message,
    required this.status,
    required this.tagCount,
    required this.videoCount,
    required this.data,
  });

  String message;
  String status;
  String tagCount;
  String videoCount;
  List<getVideoDatum> data;

  factory UserUplodedVideoListModel.fromJson(Map<String, dynamic> json) =>
      UserUplodedVideoListModel(
        message: json["message"],
        status: json["status"],
        tagCount: json["tag_count"],
        videoCount: json["video_count"],
        data: List<getVideoDatum>.from(
            json["data"].map((x) => getVideoDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "tag_count": tagCount,
        "video_count": videoCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class getVideoDatum {
  getVideoDatum({
    required this.lastId,
    required this.tblVedioId,
    required this.userId,
    required this.userImage,
    required this.username,
    required this.tag,
    required this.videoBitrate,
    required this.videoResolution,
    required this.videoLikes,
    required this.videoViewCount,
    required this.totalSoundUsed,
    required this.likes,
    required this.comments,
    required this.share,
    required this.follow,
    required this.videoThumb,
    required this.tblVideoSoundId,
    required this.soundUserName,
    required this.soundImage,
    required this.videoName,
    required this.video,
    required this.profileVerified,
    required this.followStatus
  });

  String lastId;
  String tblVedioId;
  String userId;
  String userImage;
  String username;
  String tag;
  String videoBitrate;
  String videoResolution;
  String videoLikes;
  String videoViewCount;
  String totalSoundUsed;
  String likes;
  String comments;
  String share;
  String follow;
  String videoThumb;
  String tblVideoSoundId;
  String soundUserName;
  String soundImage;
  String videoName;
  String video;
  String profileVerified;
  String followStatus;

  factory getVideoDatum.fromJson(Map<String, dynamic> json) => getVideoDatum(
        lastId: json["last_id"],
        tblVedioId: json["tbl_vedio_id"],
        userId: json["user_id"],
        userImage: json["user_image"],
        username: json["username"],
        tag: json["tag"],
        videoBitrate: json["Video_Bitrate"],
        videoResolution: json["Video_Resolution"],
        videoLikes: json["video_likes"],
        videoViewCount: json["video_view_count"],
        totalSoundUsed: json["total_sound_used"],
        likes: json["likes"],
        comments: json["comments"],
        share: json["share"],
        follow: json["follow"],
        videoThumb: json["video_thumb"],
        tblVideoSoundId: json["tbl_video_sound_id"],
        soundUserName: json["sound_user_name"],
        soundImage: json["sound_image"],
        videoName: json["video_name"],
        video: json["video"],
        profileVerified: json["profile_verified"],
    followStatus: "no"
      );

  Map<String, dynamic> toJson() => {
        "last_id": lastId,
        "tbl_vedio_id": tblVedioId,
        "user_id": userId,
        "user_image": userImage,
        "username": username,
        "tag": tag,
        "Video_Bitrate": videoBitrate,
        "Video_Resolution": videoResolution,
        "video_likes": videoLikes,
        "video_view_count": videoViewCount,
        "total_sound_used": totalSoundUsed,
        "likes": likes,
        "comments": comments,
        "share": share,
        "follow": follow,
        "video_thumb": videoThumb,
        "tbl_video_sound_id": tblVideoSoundId,
        "sound_user_name": soundUserName,
        "sound_image": soundImage,
        "video_name": videoName,
        "video": video,
        "profile_verified": profileVerified
      };
}
