// To parse this JSON data, do
//
//     final videoTagListModel = videoTagListModelFromJson(jsonString);

import 'dart:convert';

VideoTagListModel videoTagListModelFromJson(String str) =>
    VideoTagListModel.fromJson(json.decode(str));

String videoTagListModelToJson(VideoTagListModel data) =>
    json.encode(data.toJson());

class VideoTagListModel {
  VideoTagListModel({
    required this.message,
    required this.status,
    required this.tagList,
    required this.userList,
  });

  String message;
  String status;
  List<TagList> tagList;
  List<UserList> userList;

  factory VideoTagListModel.fromJson(Map<String, dynamic> json) =>
      VideoTagListModel(
        message: json["message"],
        status: json["status"],
        tagList: List<TagList>.from(
            json["tag_list"].map((x) => TagList.fromJson(x))),
        userList: List<UserList>.from(
            json["user_list"].map((x) => UserList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "tag_list": List<dynamic>.from(tagList.map((x) => x.toJson())),
        "user_list": List<dynamic>.from(userList.map((x) => x.toJson())),
      };
}

class TagList {
  TagList({
    required this.tblHashTagId,
    required this.hashTagName,
  });

  String tblHashTagId;
  String hashTagName;

  factory TagList.fromJson(Map<String, dynamic> json) => TagList(
        tblHashTagId: json["tbl_hash_tag_id"],
        hashTagName: json["hash_tag_name"],
      );

  Map<String, dynamic> toJson() => {
        "tbl_hash_tag_id": tblHashTagId,
        "hash_tag_name": hashTagName,
      };
}

class UserList {
  UserList({
    required this.userId,
    required this.userName,
    required this.name,
    required this.aboutUs,
    required this.age,
    required this.interested,
    required this.facebook,
    required this.instagram,
    required this.youtube,
    required this.gender,
    required this.zipcode,
    required this.like,
    required this.userImage,
    required this.userMultiImage,
  });

  String userId;
  String userName;
  String name;
  String aboutUs;
  String age;
  String interested;
  String facebook;
  String instagram;
  String youtube;
  String gender;
  String zipcode;
  String like;
  String userImage;
  List<dynamic> userMultiImage;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        userId: json["user_id"],
        userName: json["user_name"],
        name: json["name"],
        aboutUs: json["about_us"],
        age: json["age"],
        interested: json["interested"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        youtube: json["youtube"],
        gender: json["gender"]!,
        zipcode: json["zipcode"],
        like: json["like"]!,
        userImage: json["user_image"],
        userMultiImage:
            List<dynamic>.from(json["user_multi_image"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "name": name,
        "about_us": aboutUs,
        "age": age,
        "interested": interested,
        "facebook": facebook,
        "instagram": instagram,
        "youtube": youtube,
        "gender": gender,
        "zipcode": zipcode,
        "like": like,
        "user_image": userImage,
        "user_multi_image": List<dynamic>.from(userMultiImage.map((x) => x)),
      };
}
