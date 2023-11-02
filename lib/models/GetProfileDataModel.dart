// To parse this JSON data, do
//
//     final getProfileDataModel = getProfileDataModelFromJson(jsonString);

import 'dart:convert';

GetProfileDataModel getProfileDataModelFromJson(String str) => GetProfileDataModel.fromJson(json.decode(str));

String getProfileDataModelToJson(GetProfileDataModel data) => json.encode(data.toJson());

class GetProfileDataModel {
  GetProfileDataModel({
    required this.message,
    required this.status,
    required this.totalVideo,
    required this.totalLikesVideo,
    required this.data,
  });

  String message;
  String status;
  String totalVideo;
  String totalLikesVideo;
  Data data;

  factory GetProfileDataModel.fromJson(Map<String, dynamic> json) => GetProfileDataModel(
    message: json["message"],
    status: json["status"],
    totalVideo: json["total_video"],
    totalLikesVideo: json["total_likes_video"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "total_video": totalVideo,
    "total_likes_video": totalLikesVideo,
    "data": data.toJson(),
  };
}

class Data {
  Data({
   required this.userName,
    required this.userId,
    required  this.profileType,
    required this.name,
    required this.age,
    required this.dob,
    required this.interested,
    required this.mobile,
    required this.email,
    required this.referalCode,
    required this.usedReferalCode,
    required this.directId,
    required this.idActive,
    required this.walletAmt,
    required this.tokenWallet,
    required this.totalGiftSent,
    required this.totalGiftRecived,
    required this.aboutUs,
    required this.panNo,
    required this.facebook,
    required this.instagram,
    required this.youtube,
    required this.businessName,
    required this.gender,
    required this.businessUrl,
    required this.imageUrl,
    required this.pincode,
    required this.firebaseToken,
    required this.totalLikes,
    required this.packageAmount,
    required this.contractAddress,
    required this.like,
    required this.batchesImage,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.allVideoViewCount,
    required this.allVideoShareCount,
    required this.userImage,
    required this.coverImage,
    required this.galleryImage,required this.profileVerified
  });

  String userName;
  String userId;
  String profileType;
  String name;
  String age;
  String dob;
  String interested;
  String mobile;
  String email;
  String referalCode;
  String usedReferalCode;
  String directId;
  String idActive;
  String walletAmt;
  String tokenWallet;
  String totalGiftSent;
  String totalGiftRecived;
  String aboutUs;
  String panNo;
  String facebook;
  String instagram;
  String youtube;
  String businessName;
  String gender;
  String businessUrl;
  String imageUrl;
  String pincode;
  String firebaseToken;
  String totalLikes;
  String packageAmount;
  String contractAddress;
  String like;
  String batchesImage;
  String totalFollowers;
  String totalFollowing;
  String allVideoViewCount;
  String allVideoShareCount;
  String userImage;
  String coverImage;
  dynamic galleryImage;
  String profileVerified;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userName: json["user_name"],
    userId: json["user_id"],
    profileType: json["profile_type"],
    name: json["name"],
    age: json["age"],
    dob: json["dob"],
    interested: json["interested"],
    mobile: json["mobile"],
    email: json["email"],
    referalCode: json["referal_code"],
    usedReferalCode: json["used_referal_code"],
    directId: json["direct_id"],
    idActive: json["id_active"],
    walletAmt: json["wallet_amt"],
    tokenWallet: json["token_wallet"],
    totalGiftSent: json["total_gift_sent"],
    totalGiftRecived: json["total_gift_recived"],
    aboutUs: json["about_us"],
    panNo: json["pan_no"],
    facebook: json["facebook"],
    instagram: json["instagram"],
    youtube: json["youtube"],
    businessName: json["business_name"],
    gender: json["gender"],
    businessUrl: json["business_url"],
    imageUrl: json["image_url"],
    pincode: json["pincode"],
    firebaseToken: json["firebase_token"],
    totalLikes: json["total_likes"],
    packageAmount: json["package_amount"],
    contractAddress: json["contract_address"],
    like: json["like"],
    batchesImage: json["batches_image"],
    totalFollowers: json["total_followers"],
    totalFollowing: json["total_following"],
    allVideoViewCount: json["all_video_view_count"],
    allVideoShareCount: json["all_video_share_count"],
    userImage: json["user_image"],
    coverImage: json["cover_image"],
    galleryImage: json["gallery_image"],
    profileVerified: json["profile_verified"]
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "user_id": userId,
    "profile_type": profileType,
    "name": name,
    "age": age,
    "dob": dob,
    "interested": interested,
    "mobile": mobile,
    "email": email,
    "referal_code": referalCode,
    "used_referal_code": usedReferalCode,
    "direct_id": directId,
    "id_active": idActive,
    "wallet_amt": walletAmt,
    "token_wallet": tokenWallet,
    "total_gift_sent": totalGiftSent,
    "total_gift_recived": totalGiftRecived,
    "about_us": aboutUs,
    "pan_no": panNo,
    "facebook": facebook,
    "instagram": instagram,
    "youtube": youtube,
    "business_name": businessName,
    "gender": gender,
    "business_url": businessUrl,
    "image_url": imageUrl,
    "pincode": pincode,
    "firebase_token": firebaseToken,
    "total_likes": totalLikes,
    "package_amount": packageAmount,
    "contract_address": contractAddress,
    "like": like,
    "batches_image": batchesImage,
    "total_followers": totalFollowers,
    "total_following": totalFollowing,
    "all_video_view_count": allVideoViewCount,
    "all_video_share_count": allVideoShareCount,
    "user_image": userImage,
    "cover_image": coverImage,
    "gallery_image": galleryImage,
    "profile_verified":profileVerified
  };
}
