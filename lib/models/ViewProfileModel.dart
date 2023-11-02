// To parse this JSON data, do
//
//     final viewProfileModel = viewProfileModelFromJson(jsonString);

import 'dart:convert';

ViewProfileModel viewProfileModelFromJson(String str) => ViewProfileModel.fromJson(json.decode(str));

String viewProfileModelToJson(ViewProfileModel data) => json.encode(data.toJson());

class ViewProfileModel {
  ViewProfileModel({
   required this.status,
   required this.message,
   required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory ViewProfileModel.fromJson(Map<String, dynamic> json) => ViewProfileModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),

  };
}

class Datum {


  Datum({
   required this.tblArtistId,
   required this.fullName,
   required this.email,
   required this.mobile,
   required this.artistImage,
   required this.profileBanner,
   required this.joiningDate,
   required this.location,
   required this.status,
    required this.gender,
    required this.dateOfBirth,
    required this.aboutMe,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.youtubeUrl,
    required this.twitterUrl,
    required this.artistSkills,
    required this.isAuthorized,
    required this.fatherName,
    required this.maritalStatus,
    required this.religion,
    required this.careerObj,
    required this.KeyWorkAera,
    required this.followerCount,
    required this.followingConut,
    required this.hobbies,
    required this.isFollow,required this.achievement,required this.memberType,required this.license,required this.passport,
    required this.overallRating,
    required this.totalProfileVisitCount
  });

  int tblArtistId;
  String fullName;
  String email;
  String mobile;
  String artistImage;
  String profileBanner;
  String joiningDate;
  String location;
  int status;
  String gender;
  String dateOfBirth;
  String aboutMe;
  String instagramUrl;
  String facebookUrl;
  String youtubeUrl;
  String twitterUrl;
  String artistSkills;
  String fatherName;
  String religion;
  String maritalStatus;
  bool isAuthorized;
  String careerObj;
  String KeyWorkAera;
  int followerCount;
  int followingConut;
  String hobbies;
  String isFollow;
  String achievement;
  String memberType;
  String license;
  String passport;
  int overallRating;
  int totalProfileVisitCount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    tblArtistId: json["tbl_artist_id"],
    fullName: json["full_name"],
    email: json["email"],
    mobile: json["mobile"],
    artistImage: json["artist_image"],
    profileBanner: json["profile_banner"],
    joiningDate: json["joining_date"],
    location: json["location"],
    status: json["status"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    aboutMe: json["about_me"],
    instagramUrl:json["instagram_url"],
    facebookUrl: json["facebook_url"],
    youtubeUrl: json["youtube_url"],
      twitterUrl:json["twitter_url"],
    religion: json["religion"],
    fatherName: json["father_name"],
    maritalStatus: json["marital_status"],
    artistSkills: json["artist_skill"],
      isAuthorized: false,
    careerObj: json["career_objective"],
    KeyWorkAera: json["artist_key_workaera"],
    followerCount: json["total_follower"],
    followingConut: json["total_following"],
    hobbies:json["artist_hobbies"],
    isFollow: json["isFollow"],
    achievement: json["artist_achievement"],
    memberType: json["member_type"],
    passport: json["passport"],license: json["license"],
    overallRating:json["overall_rating"], totalProfileVisitCount:json["total_profile_visit_count"]



  );

  Map<String, dynamic> toJson() => {
    "tbl_artist_id": tblArtistId,
    "full_name": fullName,
    "email": email,
    "mobile": mobile,
    "artist_image": artistImage,
    "profile_banner": profileBanner,
    "joining_date": joiningDate,
    "location": location,
    "status": status,
    "gender": gender,
    "date_of_birth": dateOfBirth,
    "about_me": aboutMe,
    "instagram_url":instagramUrl,
    "facebook_url":facebookUrl,
    "youtube_url":youtubeUrl,"twitter_url":twitterUrl,"father_name":fatherName,"religion":religion,
    "marital_status":maritalStatus,"artist_skill":artistSkills,
    "career_objective":careerObj,
    "artist_key_workaera":KeyWorkAera,
    "total_follower":followerCount,
    "total_following":followingConut,
    "artist_hobbies":hobbies,
    "isFollow":isFollow,
    "artist_achievement":achievement,"member_type":memberType,
    "license":license,passport:"passport",
    "overall_rating":overallRating,
    "total_profile_visit_count":totalProfileVisitCount
  };
}



