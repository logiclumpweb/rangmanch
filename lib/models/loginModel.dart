// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

//its not loginModel its for Signup

class LoginModel {
  LoginModel({
   required this.message,
   required this.status,
   required this.userId,
   required this.data,
  });

  String message;
  String status;
  String userId;
  Data data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: json["message"],
    status: json["status"],
    userId: json["user_id"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "user_id": userId,
    "data": data.toJson(),
  };
}

class Data {
  Data({
   required this.userId,
   required this.email,
   required this.mobile,
   required this.otp,
   required this.age,
   required this.referalCode,
   required this.dob,
   required this.otpVerify,
   required this.userName,
   required this.firebaseToken,
   required this.userImage,
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
  String userName;
  String firebaseToken;
  String userImage;
  String coverImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    email: json["email"],
    mobile: json["mobile"],
    otp: json["otp"],
    age: json["age"],
    referalCode: json["referal_code"],
    dob: json["dob"],
    otpVerify: json["otp_verify"],
    userName: json["user_name"],
    firebaseToken: json["firebase_token"],
    userImage: json["user_image"],
    coverImage: json["cover_image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "email": email,
    "mobile": mobile,
    "otp": otp,
    "age": age,
    "referal_code": referalCode,
    "dob": dob,
    "otp_verify": otpVerify,
    "user_name": userName,
    "firebase_token": firebaseToken,
    "user_image": userImage,
    "cover_image": coverImage,
  };
}
