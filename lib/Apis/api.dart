import 'dart:convert';
import 'dart:io';

import 'package:champcash/Data/UserData.dart';
import 'package:champcash/models/BankDetailsModel.dart';
import 'package:champcash/models/Categories.dart';
import 'package:champcash/models/GetProfileDataModel.dart';
import 'package:champcash/models/GiftModel.dart';
import 'package:champcash/models/GiftReceiveModel.dart';
import 'package:champcash/models/Languages.dart';
import 'package:champcash/models/LevelBonusViewListModel.dart';
import 'package:champcash/models/LevelDetailsViewListModel.dart';
import 'package:champcash/models/NotificationModel.dart';
import 'package:champcash/models/PackageListModel.dart';
import 'package:champcash/models/PackageTransListModel.dart';
import 'package:champcash/models/SigninModel.dart';
import 'package:champcash/models/SongCategories.dart';
import 'package:champcash/models/TrendingSong.dart';
import 'package:champcash/models/UseMySoundModel.dart';
import 'package:champcash/models/UsersBlockListModel.dart';
import 'package:champcash/models/loginModel.dart';
import 'package:get/get.dart';

import '../models/INRWalletHistoryListModel.dart';
import '../models/OUDWalletHistoryListModel.dart';
import '../models/ReelVideoListModel.dart';
import 'package:http/http.dart' as http;

import '../models/UserLikedVideoListModel.dart';
import '../models/UserUplodedVideoListModel.dart';
import '../models/VideoTagListModel.dart';
import '../models/WalletDetailsViewModel.dart';
import '../models/WithdrawalHistoryModel.dart';
import '../models/follow_model.dart';
import '../models/followlist_model.dart';
import '../models/issueListModel.dart';
import '../models/tag_wise_videlList_model.dart';
import '../models/user_searchlist_model.dart';
import '../models/videoCategoryListModel.dart';
import '../models/viewcomment_model.dart';

//https://aiboxstudios.com/junglee/web_services/login.php
//const String CAdsBaseUrl = "https://aiboxstudios.com/junglee/web_services/";
const String CAdsBaseUrl = "http://rangmanch.live/web_services/";
const String reelVideoUrl = "${CAdsBaseUrl}new_video_list_api_phase2.php";

const String login = "${CAdsBaseUrl}login.php";
const String sign_up = "${CAdsBaseUrl}sign_up.php";
const String resendotp_api = "${CAdsBaseUrl}resendotp_api.php";
const String verify_otp = "${CAdsBaseUrl}verify_otp.php";
const String getProfileDetail = "${CAdsBaseUrl}my_profile_phase2_api.php";
const String uploadProfileImageUrl = "${CAdsBaseUrl}profile_image.php";
const String updateProfileUrl = "${CAdsBaseUrl}edit_profile.php";
const String updateUserFirebaseTokenUrl =
    "${CAdsBaseUrl}update_user_firebase_token_api.php";
const String add_report_api = "${CAdsBaseUrl}add_report_api.php";
const String block_user_api = "${CAdsBaseUrl}block_user_api.php";
const String UpdateBankDetailsApi = "${CAdsBaseUrl}add_bank_detail_api.php";
const String GetBankDetailsApi = "${CAdsBaseUrl}user_bank_detail_api.php";
const String ChangePasswordApi = "${CAdsBaseUrl}reset_password.php";
const String DeleteProfileApi = "${CAdsBaseUrl}request_account_delete_api.php";
const String levelListApi = "${CAdsBaseUrl}user_level_list_api.php";
const String levelListDetailsViewApi =
    "${CAdsBaseUrl}user_level_wise_list_api.php";
const String BadgesListApiUrl = "${CAdsBaseUrl}badge_list_api.php";
const String user_video_list_api =
    "${CAdsBaseUrl}user_video_list_api_phase2.php";
const String user_Liked_video_list_api =
    "${CAdsBaseUrl}likes_videos_phase2_api.php";
const String OUDwallet_history_list_api =
    "${CAdsBaseUrl}wallet_history_list_api.php";
const String INRwallet_history_list_api =
    "${CAdsBaseUrl}inr_wallet_history_list_api.php";
const String user_wallet_api = "${CAdsBaseUrl}user_wallet_api.php";
const String withdrawal_history_list_api =
    "${CAdsBaseUrl}payout_request_list_api.php";
const String videoLikesApi = "${CAdsBaseUrl}video_likes_api.php";
const String issueistApi = "${CAdsBaseUrl}issue_list_api.php";
const String checkFollowingUrl = "${CAdsBaseUrl}check_following_api_new.php";
const String categoryWiseGifUrl =
    "${CAdsBaseUrl}category_wise_gift_list_api.php";

const String notificationCountUrl = "${CAdsBaseUrl}notification_count_api.php";
const String receivedGiftUrl = "${CAdsBaseUrl}user_recived_gift_api.php";
const String receivedSendUrl = "${CAdsBaseUrl}user_send_gift_list_api.php";
const String sendGiftsUrl = "${CAdsBaseUrl}send_gift_api.php";
const String reportListApi = "${CAdsBaseUrl}add_report_api.php";
const String deleteListApi = "${CAdsBaseUrl}delete_video_api.php";
const String chatNotificationUrl =
    "${CAdsBaseUrl}chat_push_notification_api.php";
const String videoCategoryListApi = "${CAdsBaseUrl}video_category_list_api.php";
const String videoByChannelListApi =
    "${CAdsBaseUrl}new_video_list_api_phase2.php";

const String submitUserReportUrl = "${CAdsBaseUrl}add_user_report_api.php";
const String userFollowUrl = "${CAdsBaseUrl}user_following_api.php";
const String checkUserFollowingUrl = "${CAdsBaseUrl}check_following_api.php";
const String videoTagListApi = "${CAdsBaseUrl}tag_list_api.php";
const String notificationListApi =
    "${CAdsBaseUrl}user_notification_list_api.php";
const String search_ListApi = "${CAdsBaseUrl}search_api.php";
const String searchWiseVideo_ListApi =
    "${CAdsBaseUrl}tag_wise_video_list_api.php";
const String follower_ListApi = "${CAdsBaseUrl}follower_list_api.php";
const String following_ListApi = "${CAdsBaseUrl}view_following_list_api.php";
const String viewcomment_ListApi = "${CAdsBaseUrl}view_comments_api.php";
const String deletecomment_ListApi = "${CAdsBaseUrl}delete_comment_api.php";
const String add_Comment_Api = "${CAdsBaseUrl}video_comments_api.php";
const String reportCommentUrl = "${CAdsBaseUrl}comment_report_api.php";
const String commentReply_Api = "${CAdsBaseUrl}comments_reply_api.php";
const String commentLikeUrl = "${CAdsBaseUrl}comments_likes_api.php";
const String uploadChatImageUrl = "${CAdsBaseUrl}upload_image_file_api.php";

const String language_list_api = "${CAdsBaseUrl}language_list_api.php";
const String video_category_list_api =
    "${CAdsBaseUrl}video_category_list_api.php";

const String trending_songs_api = "${CAdsBaseUrl}trending_songs_api.php";
const String sound_category_list_api =
    "${CAdsBaseUrl}sound_category_list_api.php";
const String sound_list_api = "${CAdsBaseUrl}sound_list_api.php";
const String shareVideoCount_Api = "${CAdsBaseUrl}video_share_api.php";
const String packageListUrl = "${CAdsBaseUrl}package_list_api.php";
const String qrCodeUrl = "${CAdsBaseUrl}inr_qr_API.php";
const String uploadPaymentScreenShotUrl =
    "${CAdsBaseUrl}payment_screenshot_api.php";
const String blockListUrl = "${CAdsBaseUrl}blocked_user_list_api.php";
const String unblockUserURL = "${CAdsBaseUrl}unblock_user_api.php";
const String packageTransactionURL =
    "${CAdsBaseUrl}package_purchase_list_api.php";
const String useMySoundURL = "${CAdsBaseUrl}user_sound_video_phase_2_api.php";

late Map data;
String status = "status";

String message = "message";
String authorization = "Authorization";
String bKey = "Bearer";

Future<APIResponse> reelVideoListAPI(Map<String, String> hashMap) async {
  try {
    final response = await http.post(Uri.parse(reelVideoUrl), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      VideoListModel model = videoListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> SignUpApi(Map<String, Object> hashMap) async {
  try {
    final response = await http.post(Uri.parse(sign_up), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      LoginModel model = loginModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> OUDWalletHistory(Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(OUDwallet_history_list_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      OudWalletHistoryListModel model =
          oudWalletHistoryListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> withdrawal_history_list(
    Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(withdrawal_history_list_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      WithdrawalHistoryModel model =
          withdrawalHistoryModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> homeVideoLikeApi(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(videoLikesApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("LIKEEES${response.body.toString()}");
    if (data[status] == "1") {
      // WithdrawalHistoryModel model= withdrawalHistoryModelFromJson(response.body);
      return APIResponse(
        message: data[message],
        status: true,
      );
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getIssueListApi(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(issueistApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      IssueListModel model = issueListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getUserFollowUnFollowingAPI(String value) async {
  try {
    String url =
        "$checkFollowingUrl?user_id=${userLoginModel!.data.userId}&owner_id=$value";
    print("$url}");
    final response = await http.get(Uri.parse(url));
    // print(iAuthorization);
    data = json.decode(response.body);
    print("$url    FLLLLLLLWWW${response.body.toString()}");
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true, data: data);
    } else {
      return APIResponse(message: data[message], status: false, data: data);
    }
  } catch (e) {
    print('WWWWWWWError4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> uploadChatImageAPI(File imageFile) async {
  try {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(uploadChatImageUrl),
    );
    request.fields.addAll({"tbl_user_id": userLoginModel!.data.userId});
    request.files
        .add(await http.MultipartFile.fromPath("file", imageFile.path));
    request.headers.addAll({authorization: "$bKey $iAuthorization"});
    var response = await request.send();
    var response2 = await response.stream.toBytes();

    var responseString = String.fromCharCodes(response2);
    print("UUUUUUU${responseString}");
    Map resJson = jsonDecode(responseString);
    if (resJson["status"] == "1") {
      String? msg = resJson["message"].toString().capitalize;
      return APIResponse(message: msg.toString(), data: resJson, status: true);
    } else {
      String? msg = resJson["message"].toString().capitalize;
      return APIResponse(message: msg.toString(), status: false);
    }
  } catch (e) {
    print("SCREEENSHHOTT${e.toString()}");
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> giftListAPI() async {
  try {
    final response = await http.get(Uri.parse(categoryWiseGifUrl));
    // print(iAuthorization);
    data = json.decode(response.body);
    print("GIFTTTTRE${response.body.toString()}");
    if (data[status] == "1") {
      GiftModel model = giftModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getQrCodeAPIAPI() async {
  try {
    final response = await http.get(Uri.parse(qrCodeUrl));
    // print(iAuthorization);
    data = json.decode(response.body);
    print("GIFTTTTREQQQQQ${response.body.toString()}");
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true, data: data);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> packageListAPIs() async {
  try {
    final response = await http.post(Uri.parse(packageListUrl));
    // print(iAuthorization);
    data = json.decode(response.body);
    print("GIFTTTTRE${response.body.toString()}");
    if (data[status] == "1") {
      PackageListModel model = packageListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getNotificationCountAPI(Map body) async {
  try {
    final response =
        await http.post(Uri.parse(notificationCountUrl), body: body);
    data = json.decode(response.body);
    print("NOTIFICTIONNN$data$body");
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true, data: data);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> paymentScreenShotAPI(PKGDatum model, File? file) async {
  try {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(uploadPaymentScreenShotUrl),
    );
    request.fields.addAll({
      "user_id": userLoginModel!.data.userId.toString(),
      "package_id": model.tblPackageId,
      "package_name": model.packageName,
      "amount": model.amount,
    });
    request.files.add(await http.MultipartFile.fromPath("image", file!.path));
    print("PAYYYYMENTTTTT${request.fields}");
    var response = await request.send();
    var response2 = await response.stream.toBytes();
    var responseString = String.fromCharCodes(response2);

    Map resJson = jsonDecode(responseString);
    if (resJson["status"] == "1") {
      String? msg = resJson["message"].toString().capitalize;
      return APIResponse(message: msg.toString(), status: true);
    } else {
      String? msg = resJson["message"].toString().capitalize;
      return APIResponse(message: msg.toString(), status: false);
    }
  } catch (e) {
    print(e.toString());
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> reportVideoApi(Map<String, dynamic> hashMap) async {
  try {
    final response = await http.post(Uri.parse(reportListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      // IssueListModel model= issueListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> seeVideoListByChannelAPI(
    Map<String, String> hashMap) async {
  print(hashMap);
  try {
    final response =
        await http.post(Uri.parse(videoByChannelListApi), body: hashMap);

    data = json.decode(response.body);
    print("$hashMap CHHAHHAHHHAANELLID${data}");
    if (data[status] == "1") {
      // IssueListModel model= issueListModelFromJson(response.body);
      VideoListModel mModel = videoListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: mModel);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> userVideoDelete(Map<String, dynamic> hashMap) async {
  try {
    final response = await http.post(Uri.parse(deleteListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      // IssueListModel model= issueListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error4456 -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> INRWalletHistory(Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(INRwallet_history_list_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      InrWalletHistoryListModel model =
          inrWalletHistoryListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorINRWallet -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getVideoCategory() async {
  try {
    final response = await http.get(
      Uri.parse("$videoCategoryListApi/user_id=${userLoginModel!.data.userId}"),
    );
    // print(iAuthorization);
    data = json.decode(response.body);
    print("Video Cat $data");
    if (data[status] == "1") {
      VideoCategoryListModel model =
          videoCategoryListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> WalletDetails(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(user_wallet_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("" + response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");

      return APIResponse(message: data[message], status: true, data: data);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorWalletDetails -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> userUploadedVideoApi(Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(user_video_list_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("My Videos ${response.body}");
    if (data[status] == "1") {
      UserUplodedVideoListModel model =
          userUplodedVideoListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErroruserUploaded -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> userLikedVideoApi(Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(user_Liked_video_list_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("UUUUUUIIII${response.body.toString()}");
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      UserLikedVideoListModel model =
          userLikedVideoListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErroruserLiked -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> SaveBankDetailsApi(Map<String, Object> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(UpdateBankDetailsApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      // LoginModel model= loginModelFromJson(response.body);
      return APIResponse(
        message: data[message],
        status: true,
      );
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorSaveBank-$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getBankDetailsApi(Map<String, Object> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(GetBankDetailsApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      BankDetailsModel model = bankDetailsModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorgetBankDetai -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> LoginApi(Map<String, Object> hashMap) async {
  try {
    final response = await http.post(Uri.parse(login), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("LOGIGIGNGNNG${response.body.toString()}");
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      SigninModel model = signinModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorLoginApi -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> ResendOTPApi(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(resendotp_api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("OTPTPTOT${response.body.toString()}");
    if (data[status] == true) {
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorResend -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> VerifyOTPApi(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(verify_otp), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorVerifyO -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getProfileDetailAPI(Map<String, String> hashMap) async {
  print("HASGHHHHH${hashMap}");
  try {
    final response = await http.post(
      Uri.parse(getProfileDetail),
      body: hashMap,
    );
    data = json.decode(response.body);
    print("POFILERESR${response.body.toString()}");
    if (data["status"] == "1") {
      GetProfileDataModel model = getProfileDataModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorgetProfile -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> deleteProfileAPI(Map<String, String> hashMap) async {
  print(iAuthorization);
  try {
    final response = await http.post(
      Uri.parse(DeleteProfileApi),
      body: hashMap,
    );
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      // GetProfileDataModel model= getProfileDataModelFromJson(response.body);
      return APIResponse(
        message: data[message],
        status: true,
      );
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrordeleteProfile -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> levelListViewAPI(Map<String, String> hashMap) async {
  print(iAuthorization);
  try {
    final response = await http.post(
      Uri.parse(levelListApi),
      body: hashMap,
    );
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      LevelBonusViewListModel model =
          levelBonusViewListModelFromJson(response.body);
      return APIResponse(
          message: data['total_income'], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorlevelList -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> levelDetailsViewAPI(Map<String, String?> hashMap) async {
  print(iAuthorization);
  try {
    final response = await http.post(
      Uri.parse(levelListDetailsViewApi),
      body: hashMap,
    );
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      LevelDetailsViewListModel model =
          levelDetailsViewListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> changePassword(Map<String, String> hashMap) async {
  print(iAuthorization);
  try {
    final response = await http.post(
      Uri.parse(ChangePasswordApi),
      body: hashMap,
    );
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      return APIResponse(
        message: data[message],
        status: true,
      );
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> uploadProfileViewAPI(File imageFile) async {
  try {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(uploadProfileImageUrl),
    );
    request.fields.addAll({
      "user_id": userLoginModel!.data.userId.toString(),
    });
    request.files
        .add(await http.MultipartFile.fromPath("image", imageFile.path));
    print(request.fields.toString() + "dhsgsygdsgdgdg");
    var response = await request.send();
    var response2 = await response.stream.toBytes();
    var responseString = String.fromCharCodes(response2);
    print(responseString);
    Map resJson = jsonDecode(responseString);
    if (resJson["status"] == "1") {
      String? msg = resJson["message"].toString().capitalize;
      return APIResponse(message: msg.toString(), status: true);
    } else {
      String? msg = resJson["message"].toString().capitalize;
      return APIResponse(message: msg.toString(), status: false);
    }
  } catch (e) {
    print(e.toString());
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> saveProfileDetailAPI(Map<String, String> hashMap) async {
  try {
    final response = await http.post(Uri.parse(updateProfileUrl),
        body: hashMap, headers: {authorization: "$bKey $iAuthorization"});
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> updateFirebaseTokenAPI(Map<String, String> hashMap) async {
  try {
    final response = await http.post(Uri.parse(updateUserFirebaseTokenUrl),
        body: hashMap, headers: {authorization: "$bKey $iAuthorization"});
    data = json.decode(response.body);
    print("TTTTOTKKKEENENNE${response.body.toString()} $hashMap");
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getBadgesListApi() async {
  try {
    final response = await http.get(Uri.parse(BadgesListApiUrl));
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> chatNotificationAPIs(Map params) async {
  try {
    final response =
        await http.post(Uri.parse(chatNotificationUrl), body: params);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> userBlockAPI(Map body) async {
  print(body);
  try {
    final response = await http.post(Uri.parse(block_user_api), body: body);
    data = json.decode(response.body);
    print("BLOCK USER${response.body}");
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> submitUserReportAPI(Map body) async {
  print(body);
  try {
    final response =
        await http.post(Uri.parse(submitUserReportUrl), body: body);
    data = json.decode(response.body);
    print("SubmitBLOCK${response.body}");
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> userFollowAPI(Map body) async {
  print("HASHHHSH${body}");
  try {
    final response = await http.post(Uri.parse(userFollowUrl), body: body);
    data = json.decode(response.body);
    print("FOLLOWEEERRRR${response.body}");
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> checkFollowingUserAPI(Map body) async {
  print(body);
  try {
    final response =
        await http.post(Uri.parse(checkUserFollowingUrl), body: body);
    data = json.decode(response.body);
    print("FOLLOW${response.body}");
    if (data["status"] == "1") {
      return APIResponse(message: data[message], status: true, data: data);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Error -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getvideoTagList(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(videoTagListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      VideoTagListModel model = videoTagListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getNotificationListAPIs(
    Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(notificationListApi), body: hashMap);

    data = json.decode(response.body);
    if (data[status] == "1") {
      NotificationModel model = notificationModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getsearch_List(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(search_ListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("sdgsfdsdfsfds");
      UserSearchlistModel model = userSearchlistModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorgetsearch_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> giftReceivedListAPI(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(receivedGiftUrl), body: hashMap);

    data = json.decode(response.body);
    print("GIIFTFTFTREE${data}");
    if (data[status] == "1") {
      GiftReceiveModel model = giftReceiveModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorgetsearch_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getBlockUserListAPIs(Map body) async {
  try {
    final response = await http.post(Uri.parse(blockListUrl), body: body);

    data = json.decode(response.body);
    print("GIIFTFTFTREE${data} $body");
    if (data[status] == "1") {
      UserBlockListModel model = userBlockListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorgetsearch_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> unBlockUserAPIs(Map body) async {
  try {
    final response = await http.post(Uri.parse(unblockUserURL), body: body);

    data = json.decode(response.body);
    print("GIIFTFTFTREE${data} $body");
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true, data: null);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorgetsearch_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> giftSendListAPI(Map<String, String?> hashMap) async {
  try {
    print("HASHHGIIFTFTFTREE  $hashMap");
    final response = await http.post(Uri.parse(receivedSendUrl), body: hashMap);

    data = json.decode(response.body);
    print("GIIFTFTFTREE${data}    $hashMap");
    if (data[status] == "1") {
      GiftSendModel model = giftSendModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorgetsearch_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> sendGiftsAPI(Map<String, String?> hashMap) async {
  try {
    final response = await http.post(Uri.parse(sendGiftsUrl), body: hashMap);

    data = json.decode(response.body);
    print("KKKSKSKS${data}");
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true, data: data);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorgetsearch_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getsearchWiseVideo_List(
    Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(searchWiseVideo_ListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("searchWiseVideo");
      TagWiseVideolListModel model =
          tagWiseVideolListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorgetsearchWiseVideo_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> fetchUserFollowListAPI(Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(follower_ListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("FOLLLLLOOOWW${response.body.toString()}");
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      FollowModel model = followModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorgetsearchWiseVideo_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getPackageTransactionAPIs(
    Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(packageTransactionURL), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("FOLLLLLOOOWW${response.body.toString()}");
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      PackageTrasListModel model = packageTrasListModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorgetsearchWiseVideo_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getuserfollowing_List(Map<String, String?> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(following_ListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      FollowlistModel model = followlistModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorfollowing_ListApi_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getVideoComment_List(Map<String, dynamic> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(viewcomment_ListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("RESSSSS${response.body.toString()}");
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      ViewcommentModel model = viewcommentModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorfollowing_ListApi_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> deletecomment_List(Map<String, dynamic> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(deletecomment_ListApi), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      // ViewcommentModel model= viewcommentModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorfollowing_ListApi_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> reportInCommentAPIs(Map<String, dynamic> hashMap) async {
  print("$hashMap REEEEPORRTTT");
  try {
    final response =
        await http.post(Uri.parse(reportCommentUrl), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("$hashMap REEEEPORRTTT${response.body.toString()}");
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      // ViewcommentModel model= viewcommentModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('Errorfollowing_ListApi_List -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> addComment(Map<String, dynamic> hashMap) async {
  try {
    final response = await http.post(Uri.parse(add_Comment_Api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      // ViewcommentModel model= viewcommentModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErroraddComment -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> commentReply(Map<String, dynamic> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(commentReply_Api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("searchWiseVideo+$data");
      // ViewcommentModel model= viewcommentModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErroraddComment -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> likeCommmentAPI(Map<String, String> hashMap) async {
  try {
    final response = await http.post(Uri.parse(commentLikeUrl), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("LLIKKEECOMENTAPPPII${response.body.toString()}");
    if (data[status] == "1") {
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ERRorAddCoMMnt -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getLanguage() async {
  try {
    final response = await http.get(
      Uri.parse(language_list_api),
    );
    data = json.decode(response.body);
    if (data[status] == "1") {
      Languages model = languagesFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getCategory() async {
  try {
    final response = await http.get(
      Uri.parse(video_category_list_api),
    );
    data = json.decode(response.body);
    if (data[status] == "1") {
      Categories model = categoriesFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getTrendingSongs() async {
  try {
    final response = await http.get(
      Uri.parse(trending_songs_api),
    );
    data = json.decode(response.body);
    print("TRENDINGSONNGDDD${data.toString()}");
    if (data[status] == "1") {
      TrendingSongs songs = trendingSongsFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: songs);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getSongCategory() async {
  try {
    final response = await http.get(
      Uri.parse(sound_category_list_api),
    );
    data = json.decode(response.body);
    if (data[status] == "1") {
      SongCategoris songs = songCategorisFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: songs);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErrorCat -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> getSongCategoryByID(Map<String, String> hashMap) async {
  try {
    final response = await http.post(Uri.parse(sound_list_api), body: hashMap);
    data = json.decode(response.body);
    if (data[status] == "1") {
      TrendingSongs songs = trendingSongsFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: songs);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ERRorAddCoMMnt -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> shareCountVideo(Map<String, dynamic> hashMap) async {
  try {
    final response =
        await http.post(Uri.parse(shareVideoCount_Api), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print(response.body.toString());
    if (data[status] == "1") {
      print("shareCountVideo+$data");
      // ViewcommentModel model= viewcommentModelFromJson(response.body);
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErroraddComment -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

Future<APIResponse> useMySoundAPI(Map<String, dynamic> hashMap) async {
  try {
    final response = await http.post(Uri.parse(useMySoundURL), body: hashMap);
    // print(iAuthorization);
    data = json.decode(response.body);
    print("USEEEEMUSSIOCIC${response.body.toString()}");
    if (data[status] == "1") {
      print("shareCountVideo+$data");
      UseMySoundModel model = useMySoundModelFromJson(response.body);
      return APIResponse(message: data[message], status: true, data: model);
    } else {
      return APIResponse(message: data[message], status: false, data: null);
    }
  } catch (e) {
    print('ErroraddComment -$e');
    return APIResponse(message: e.toString(), status: false);
  }
}

class APIResponse {
  dynamic data;
  String message;
  bool status;

  APIResponse({this.data, required this.message, required this.status});
}

//setState() or markNeedsBuild() called during build.
// This Obx widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
// The widget on which setState() or markNeedsBuild() was called was:
//   Obx
// The widget which was currently being built when the offending call was made was:
//   Obx
