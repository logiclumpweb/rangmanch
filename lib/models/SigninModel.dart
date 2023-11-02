// To parse this JSON data, do
//
//     final signinModel = signinModelFromJson(jsonString);

import 'dart:convert';

SigninModel signinModelFromJson(String str) => SigninModel.fromJson(json.decode(str));

String signinModelToJson(SigninModel data) => json.encode(data.toJson());

class SigninModel {
  SigninModel({
    required this.message,
    required  this.status,
    required this.data,
  });

  String message;
  String status;
  Data data;

  factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
    message: json["message"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
   required this.userId,
    required this.email,
    required this.mobile,
    required  this.otp,
    required this.age,
    required this.referalCode,
    required this.dob,
    required this.otpVerify,
    required this.userName,
    required this.firebaseToken,
    required this.usedReferalCode,
    required this.userImage,
    required this.mobileOtpVerify,
    required this.coverImage,
  });

  String userId;
  String email;
  String mobile;
  String otp;
  String age;
  String referalCode;
  String dob;
  String otpVerify;
  String mobileOtpVerify;
  String userName;
  String firebaseToken;
  String usedReferalCode;
  String userImage;
  String coverImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    email: json["email"],
    mobile: json["mobile"],
    mobileOtpVerify: json["mobile_otp_verify"],
    otp: json["otp"],
    age: json["age"],
    referalCode: json["referal_code"],
    dob: json["dob"],
    otpVerify: json["otp_verify"],
    userName: json["user_name"],
    firebaseToken: json["firebase_token"],
    usedReferalCode: json["used_referal_code"],
    userImage: json["user_image"],
    coverImage: json["cover_image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "email": email,
    "mobile": mobile,
    "mobile_otp_verify":mobileOtpVerify,
    "otp": otp,
    "age": age,
    "referal_code": referalCode,
    "dob": dob,
    "otp_verify": otpVerify,
    "user_name": userName,
    "firebase_token": firebaseToken,
    "used_referal_code": usedReferalCode,
    "user_image": userImage,
    "cover_image": coverImage,
  };
}
