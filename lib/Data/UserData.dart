




import 'package:champcash/models/BadgesModel.dart';
import 'package:champcash/models/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/BankDetailsModel.dart';
import '../models/GetProfileDataModel.dart';
import '../models/SigninModel.dart';
import '../models/ViewProfileModel.dart';

LoginModel? userArtistModel;
ViewProfileModel? artistProfileModel;

/*
RecuiterLoginModel? userRecruiterModel;
ViewProfileModel? artistProfileModel;
RecuiterProfileModel? recruiterProfileModel;*/
String? token;
SigninModel? userLoginModel;
String? iAuthorization;
GetProfileDataModel? userProfileModel;
BankDetailsModel? userbankDetailsModel;
BadgesListModel? badgesList;

Future<bool> setArtistInfo(LoginModel? userArtistModel) async {
  final pref = await SharedPreferences.getInstance();
  String? data = userArtistModel != null ?
  loginModelToJson(userArtistModel) : null;
  bool isFirst = await pref.setString('user', data ?? 'logout');
  return isFirst;
}

Future<LoginModel?> getArtistInfo() async {
  final pref = await SharedPreferences.getInstance();
  String? data = pref.getString('user');
  if (data != null && data == 'logout') return null;
  userArtistModel = data != null ? loginModelFromJson(data) : null;
  return userArtistModel;
}

Future<bool>setLoginModelDetail(LoginModel? model)async{
  final prefs=await SharedPreferences.getInstance();
  String? data=model!=null?loginModelToJson(model):null;
  bool first=await prefs.setString("user",data??"logout");
  return first;
}
Future<bool>isUpdateProfileStatus(String val)async{
  final prefs=await SharedPreferences.getInstance();
  bool isFirst=await prefs.setString("IsUpdate", val);
  return isFirst;
}

Future<LoginModel?>getLoginModelDetail()async{
  final prefs=await SharedPreferences.getInstance();
  String? data=prefs.getString("user");
  if(data!=null&&data=="logout") return null;
  userArtistModel=data!=null?loginModelFromJson(data):null;
  return userArtistModel;
}

Future<bool> setUserInfo(SigninModel? userLoginModel) async {
  final pref = await SharedPreferences.getInstance();
  String? data = userLoginModel != null ?
  signinModelToJson(userLoginModel) : null;
  bool isFirst = await pref.setString('user', data ?? 'logout');
  return isFirst;
}

Future<SigninModel?> getUserInfo() async {
  final pref = await SharedPreferences.getInstance();
  String? data = pref.getString('user');
  if (data != null && data == 'logout') return null;
  userLoginModel = data != null ? signinModelFromJson(data) : null;
  return userLoginModel;
}




Future<bool>setAddress(String val)async{
  final prefs=await SharedPreferences.getInstance();
  bool isFirst=await prefs.setString("address", val);
  return isFirst;
}


Future<String>getAddress()async{
  final prefs=await SharedPreferences.getInstance();
  String isFirst=prefs.getString("address")??"";
  return isFirst;
}



Future<bool>setAccountType(String val)async{
  final prefs=await SharedPreferences.getInstance();
  bool isFirst=await prefs.setString("accountType", val);
  return isFirst;
}


Future<String>getAccountType()async{
  final prefs=await SharedPreferences.getInstance();
  String isFirst=prefs.getString("accountType")??"";
  return isFirst;
}

Future<bool>setAccessToken(String val)async{
  final prefs=await SharedPreferences.getInstance();
  bool isFirst=await prefs.setString("token", val);
  return isFirst;
}


Future<String>getAccessToken()async{
  final prefs=await SharedPreferences.getInstance();
  String isFirst=prefs.getString("token")??"";
  return isFirst;
}