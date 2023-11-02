// To parse this JSON data, do
//
//     final videoListModel = videoListModelFromJson(jsonString);

import 'dart:convert';

VideoListModel videoListModelFromJson(String str) =>
    VideoListModel.fromJson(json.decode(str));

String videoListModelToJson(VideoListModel data) => json.encode(data.toJson());

class VideoListModel {
  VideoListModel({
    required this.message,
    required this.status,
    required this.tagCount,
    required this.data,
  });

  String message;
  String status;
  String tagCount;
  List<VideoDatum> data;

  factory VideoListModel.fromJson(Map<String, dynamic> json) => VideoListModel(
        message: json["message"],
        status: json["status"],
        tagCount: json["tag_count"],
        data: List<VideoDatum>.from(
            json["data"].map((x) => VideoDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "tag_count": tagCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class VideoDatum {
  VideoDatum(
      {required this.tblVedioId,
      required this.lastId,
      required this.userId,
      required this.userImage,
      required this.username,
      required this.tag,
      required this.videoBitrate,
      required this.videoResolution,
      required this.videoLikes,
      required this.likes,
      required this.comments,
      required this.videoViewCount,
      required this.totalSoundUsed,
      required this.share,
      required this.follow,
      required this.videoThumb,
      required this.tblVideoSoundId,
      required this.soundUserName,
      required this.soundImage,
      required this.videoName,
      required this.video,
      required this.profileVerified,
      required this.isFollowStatus});

  String tblVedioId;
  String lastId;
  String userId;
  String userImage;
  String username;
  String tag;
  String videoBitrate;
  String videoResolution;
  String videoLikes;
  String likes;
  String comments;
  String videoViewCount;
  String totalSoundUsed;
  String share;
  String follow;
  String videoThumb;
  String tblVideoSoundId;
  String soundUserName;
  String soundImage;
  String videoName;
  String video;
  String profileVerified;
  String isFollowStatus;

  factory VideoDatum.fromJson(Map<String, dynamic> json) => VideoDatum(
      tblVedioId: json["tbl_vedio_id"],
      lastId: json["last_id"],
      userId: json["user_id"],
      userImage: json["user_image"],
      username: json["username"],
      tag: json["tag"],
      videoBitrate: json["Video_Bitrate"],
      videoResolution: json["Video_Resolution"],
      videoLikes: json["video_likes"],
      likes: json["likes"],
      comments: json["comments"],
      videoViewCount: json["video_view_count"],
      totalSoundUsed: json["total_sound_used"],
      share: json["share"],
      follow: json["follow"],
      videoThumb: json["video_thumb"],
      tblVideoSoundId: json["tbl_video_sound_id"],
      soundUserName: json["sound_user_name"],
      soundImage: json["sound_image"],
      videoName: json["video_name"],
      video: json["video"],
      profileVerified: json["profile_verified"],
      isFollowStatus: "no");

  Map<String, dynamic> toJson() => {
        "tbl_vedio_id": tblVedioId,
/*    "last_id": lastId,
    "user_id": userId,
    "user_image": userImage,
    "username": username,
    "tag": tag,
    "Video_Bitrate": videoBitrate,
    "Video_Resolution": videoResolution,
    "video_likes": videoLikes,
    "likes": likes,
    "comments": comments,
    "video_view_count": videoViewCount,
    "total_sound_used": totalSoundUsed,
    "share": share,
    "follow": follow,
    "video_thumb": videoThumb,
    "tbl_video_sound_id": tblVideoSoundId,
    "sound_user_name": soundUserName,
    "sound_image": soundImage,*/
        "video_name": videoName,
        "video": video,
        "tag": tag,
        "username": username,
      };
}
