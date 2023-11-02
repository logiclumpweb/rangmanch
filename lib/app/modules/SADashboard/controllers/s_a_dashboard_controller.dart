import 'package:champcash/Apis/api/api.dart';
import 'package:champcash/Apis/api/api_imp.dart';
import 'package:champcash/Apis/api/base_api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_chat_controller.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_hash_controller.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/app_controller.dart';
import 'package:champcash/models/GetProfileDataModel.dart';
import 'package:champcash/models/GiftModel.dart';
import 'package:champcash/models/ReelVideoListModel.dart';
import 'package:champcash/models/UserUplodedVideoListModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../ARGear/controllers/ar_gear_controller.dart';
import '../../../../Apis/api.dart';
import '../../../../Data/fr_constants.dart';
import '../../../../models/UserLikedVideoListModel.dart';
import '../../../../models/VideoTagListModel.dart';
import '../../../../models/issueListModel.dart';
import '../../../../models/videoCategoryListModel.dart';
import '../../../../models/viewcomment_model.dart';
import '../../../../shared/extras.dart';

class SADashboardController extends GetxController {
  final homePageController = PageController();
  final pageNumber = 1.obs;
  final pageLoading = false.obs;
  final videoList = RxList<VideoDatum>();
  RxList<cDatum> commentList = <cDatum>[].obs;
  var videoCategoryList = RxList<vCategoryDatum>();
  IssueListModel? mlist;
  final RxList<String> catVidListId = <String>[].obs;
  final bottomIndex = 0.obs;
  FocusNode focus = FocusNode();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final textSearch = "".obs;
  final ediTextSeachController = TextEditingController().obs;

  int page = 0;
  final PageController pageController = PageController();
  List<getVideoDatum> videoMlist = <getVideoDatum>[];
  List<likeVideoDatum> mLikedlist = <likeVideoDatum>[];

  final ratingValue = 5,
      pageIndex = 0.obs,
      isLikeVal = false.obs,
      likeCountVal = 0.obs;
  final lastID = "".obs, buttonVal = false.obs;
  bool isMoreLoading = false;

  final videoId1 = "0".obs, notificationCountVal = "0".obs;

  var EditCommentController = TextEditingController().obs;

  final isSelect = false.obs,
      tblVideoCommentsId = "".obs,
      replyCommentUI = false.obs,
      ignoreTappingVal = false.obs,
      profileUrl =
          "https://cdn-icons-png.flaticon.com/128/3011/3011270.png".obs,
      myProfileLinkVal =
          "https://cdn-icons-png.flaticon.com/128/3011/3011270.png".obs,
      refreshVal = true.obs,
      totalComCount = 0.obs,
      onCallingCommentListUI = false.obs,
      tagEmpty = "null".obs,
      giftIdVal = "".obs,
      giftAmtVal = "0".obs,
      giftHeaderIndexVal = 0.obs,
      giftIndexVal = 0.obs,
      userIdVal = "".obs,
      isOpenTagScreen = false.obs,
      isReelScreenVal = false.obs,shareUIVisibility=false.obs,
      progressVIUploadingVal = false.obs;
  var chatUserList = ["Anish", "Abul", "Rohit"];
  final appController = Get.find<AppController>();
  RxList<GFTDatum> giftModelList = <GFTDatum>[].obs;

  RxList<String> tagList = <String>[].obs;


  @override
  void onInit() {
    super.onInit();

    getVideoList(pageNumber.value);
    homePageController.removeListener(() {});
    homePageController.addListener(() {
      if (homePageController.position.pixels ==
          homePageController.position.maxScrollExtent) {
        pageNumber.value += 1;
        getVideoList(pageNumber.value);
      }
    });

    bottomIndex.listen((page) {
      if (page != 0) {
        videoStatusUpdate.add(PAUSE);
      }
      if (page == 0) {
        //   videoList.value.clear();
        //   videoList.refresh();
        //   getVideoList(1);
        callingNotificationAPIs();
        getProfileDetailAPIs();
      }
      if (page == 1) {
        appController.isForcePauseVal.value = true;
        Get.find<SAhashtagController>().onInit();
      } else if (page == 2) {
        appController.isForcePauseVal.value = true;
        getChatForFireStore(FireBaseConstants.pathUserCollection, 100);
      } else if (page == 3) {
        appController.isForcePauseVal.value = true;
        Get.find<ProfileController>().profileVisibilityVal.value = false;
        Get.find<ProfileController>().onInit1(userIdVal.value);
      }
    });
    getProfileDetailAPIs();
    callingNotificationAPIs();
    getFirebaseTokenAPIs();
  }

  callingNotificationAPIs() {
    getNotificationCountAPI({"user_id": userLoginModel!.data.userId.toString()})
        .then((value) {
      if (value.status) {
        notificationCountVal.value = value.data["count"];
      }
    });
  }

  Future<void> getVideoList(page) async {
    pageLoading.value = true;
    ApiResponse apiResponse = await ApiImpl().getVideoListAPI({
      "user_id": userLoginModel!.data.userId.toString(),
      "pagenumber": page.toString()
    });

    if (apiResponse.data.toString() != "null") {
      if (apiResponse.status) {
        if (pageNumber.value == 1) {
          isReelScreenVal.value = false;
          VideoListModel mModel = apiResponse.data;
          videoList.value = mModel.data;
        } else {
          isReelScreenVal.value = false;
          VideoListModel mModel = apiResponse.data;
          videoList.addAll(mModel.data);
        }
        videoList.forEach((element) {
          FirebaseFirestore.instance
              .collection(FireBaseConstants.pathUserFollowCollection)
              .doc(userLoginModel!.data.userId.toString())
              .collection(FireBaseConstants.allFollowing)
              .doc(element.userId)
              .set({
            FireBaseConstants.isFollow: element.follow,
          });
        });
        getVideoCat();
      } else {
        isReelScreenVal.value = true;
      }
    } else {
      isReelScreenVal.value = true;
    }
  }

  void getProfileDetailAPIs() async {
    APIResponse response =
        await getProfileDetailAPI({"user_id": userLoginModel!.data.userId});
    if (response.status) {
      GetProfileDataModel model = response.data;
      profileUrl.value = model.data.userImage;
      myProfileLinkVal.value=model.data.userImage;
    } else {
      showErrorBottomSheet(response.message.toString());
    }
  }

  void updateBottomIndex(int index) {
    bottomIndex.value = index;
  }

  void getIssuesList() {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "type": "video",
    };
    print(hashMap);
    getIssueListApi(hashMap).then((value) {
      if (value.status) {
        IssueListModel model = value.data;
        mlist = model;
      }
      giftListAPIs();
    });
  }

  void getVideoCat() {
    getVideoCategory().then((value) {
      if (value.status) {
        VideoCategoryListModel model = value.data;
        List<vCategoryDatum> mlist = model.data;
        videoCategoryList.value = mlist;
        print(value.message);
      } else {
        showErrorBottomSheet(value.message);
      }
      getIssuesList();
    });
  }

  void openIIssueDilough(
      BuildContext context, IssueListModel? mlist, VideoDatum videoModel) {
    showGeneralDialog(
        barrierDismissible: false,
        context: context,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SACellRoundContainer(
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: ColorConstants.APPPRIMARYCOLOR,
                            )),
                        radius: 30,
                        borderWidth: 0,
                        borderWidthColor: Colors.transparent,
                        color: ColorConstants.APPPRIMARYBLACKCOLOR),
                  ),
                  Container(
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          headingText(
                              title: "Select Reason",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              align: TextAlign.center,
                              color: ColorConstants.APPPRIMARYBLACKCOLOR),
                          Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: mlist!.data.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      height: 1,
                                      color: ColorConstants.APPPRIMARYGREYCOLOR,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          EasyLoading.show();
                                          reportVideoAPIs(
                                              mlist.data[index].videoIssueListId
                                                  .toString(),
                                              videoModel);
                                        },
                                        child: headingLongText(
                                            title: mlist.data[index].title,
                                            fontWeight: FontWeight.w500,
                                            align: TextAlign.center,
                                            fontSize: 15,
                                            color: ColorConstants
                                                .APPPRIMARYBLACKCOLOR),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0.5,
                                      color: ColorConstants.APPPRIMARYGREYCOLOR,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void reportVideoAPIs(String issueId, VideoDatum videoModel) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": videoModel.tblVedioId.toString(),
      "video_user_id": videoModel.userId.toString(),
      "issue_list_id": issueId.toString(),
    };
    print("SKSIKSKSSK${hashMap}");
    reportVideoApi(hashMap).then((value) {
      if (value.status) {
        EasyLoading.dismiss();
        toastMessage(value.message);
        Get.back();
      } else {
        EasyLoading.dismiss();
        Get.back();
        showErrorBottomSheet(value.message);
      }
    });
  }

  void seeVideoListByChannelAPIs(String catVidChannel) {
    seeVideoListByChannelAPI({
      "user_id": userLoginModel!.data.userId,
      "channel_id": catVidChannel
    }).then((value) {
      if (value.status) {
        Get.back();
        VideoListModel mModel = value.data;
        videoList.value = mModel.data;
        videoList.refresh();
      } else {
        showErrorBottomSheet(value.message.toString());
      }
    });
  }

  Stream<QuerySnapshot> getChatForFireStore(String pathCollection, int limit) {
    return firebaseFirestore
        .collection(pathCollection)
        .doc(userLoginModel!.data.userId)
        .collection(FireBaseConstants.allChat)
        .limit(100)
        .snapshots();
  }

  Stream<QuerySnapshot> getFollowFollowingFireStore() {
    return firebaseFirestore
        .collection(FireBaseConstants.pathUserFollowCollection)
        .doc(userLoginModel!.data.userId)
        .collection(FireBaseConstants.allFollowing)
        .limit(100)
        .snapshots();
  }

  callingUserBlocked(String Id, {unblock = false}) {
    FirebaseFirestore.instance
        .collection(FireBaseConstants.pathUserCollection)
        .doc(userLoginModel!.data.userId)
        .collection(FireBaseConstants.allChat)
        .where(FireBaseConstants.peerId, isEqualTo: Id)
        .get()
        .then((value) {
      QuerySnapshot<Map<String, dynamic>> allList = value;
      if (allList.docs.isNotEmpty) {
        allList.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection(FireBaseConstants.pathUserCollection)
              .doc(userLoginModel!.data.userId)
              .collection(FireBaseConstants.allChat)
              .doc(element[FireBaseConstants.peerId])
              .update({FireBaseConstants.isActive: unblock});
        });
      }
    });
    FirebaseFirestore.instance
        .collection(FireBaseConstants.pathUserCollection)
        .doc(Id)
        .collection(FireBaseConstants.allChat)
        .where(FireBaseConstants.peerId, isEqualTo: userLoginModel!.data.userId)
        .get()
        .then((value) {
      QuerySnapshot<Map<String, dynamic>> allList = value;
      if (allList.docs.isNotEmpty) {
        allList.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection(FireBaseConstants.pathUserCollection)
              .doc(Id)
              .collection(FireBaseConstants.allChat)
              .doc(element[FireBaseConstants.peerId])
              .update({FireBaseConstants.isActive: unblock});
        });
      }
    });
  }

  /*callingUserBlocked(String Id, {unblock = false}) {
    print(Id);
    FirebaseFirestore.instance
        .collection(FireBaseConstants.pathUserCollection)
        .doc(userLoginModel!.data.userId.toString())
        .collection(FireBaseConstants.allChat)
        .where(FireBaseConstants.peerId, isEqualTo: Id)
        .get()
        .then((value) {
      QuerySnapshot<Map<String, dynamic>> allList = value;

      if (allList.docs.isNotEmpty) {
        allList.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection(FireBaseConstants.pathUserCollection)
              .doc(userLoginModel!.data.userId.toString())
              .collection(FireBaseConstants.allChat)
              .doc(element[FireBaseConstants.peerId])
              .update({FireBaseConstants.isActive: unblock});
        });
      } else {
        FirebaseFirestore.instance
            .collection(FireBaseConstants.pathUserCollection)
            .doc(userLoginModel!.data.userId.toString())
            .collection(FireBaseConstants.allChat)
            .where(Id, isEqualTo: Id)
            .get()
            .then((value) {
          QuerySnapshot<Map<String, dynamic>> allList = value;

          if (allList.docs.isNotEmpty) {
            allList.docs.forEach((element) {
              print("BLOOCLCKKCKLISTTST${element.toString()}");
              FirebaseFirestore.instance
                  .collection(FireBaseConstants.pathUserCollection)
                  .doc(userLoginModel!.data.userId.toString())
                  .collection(FireBaseConstants.allChat)
                  .doc(element[FireBaseConstants.idFrom])
                  .update({FireBaseConstants.isActive: unblock});
            });
          }
        });
      }
    });
    // FirebaseFirestore.instance
    //     .collection(FireStoreConstants.pathUserCollection)
    //     .doc(viewLoginDetail!.data.first.tblUserId)
    //     .collection(FireStoreConstants.allChat)
    //     .doc("367")
    //     .update({FireStoreConstants.isActive: unblock});
  }*/

  Future<List<cDatum>> getCommentListAPIs(
      String videoID, bool isOpening) async {
    videoId1.value = videoID;
    print("HASHMAPPP");
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "tbl_vedio_id": videoID,
    };
    print("HASHMAPPP${hashMap}");

    APIResponse r = await getVideoComment_List(hashMap);
    ViewcommentModel m = r.data;
    totalComCount.value = m.data.length;
    return m.data;
  }

  Stream<List<cDatum>> getStreamComment(String videoId) {
    return Stream.fromFuture(getCommentListAPIs(videoId, false));
  }

  void deleteComment(String tblVideoCommentsId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "tbl_video_comments_id": tblVideoCommentsId,
      "comments_type": "Normal",
    };
    print("bfhdbfhdbfbdbfd${hashMap.toString()}");
    deletecomment_List(hashMap).then((value) {
      totalComCount.value = 0;
      if (value.status) {
        Get.back();
        toastMessage(value.message);
        getCommentListAPIs(videoId1.value, false);
      }
    });
  }

  Future sendCcomment() async {
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "video_id": videoId1.toString(),
      "comments": EditCommentController.value.text.trim().toString(),
      "time": DateTime.now().microsecondsSinceEpoch.toString(),
    };
    print("cgeckkkparam${hashMap.toString()}");
    addComment(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        EditCommentController.value.clear();
        // refreshVal.value = refreshVal.value ? false : true;
        // getCommentListAPIs(videoId1.value, false);
      }
    });
  }

  replyCommentAPI(String value) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "video_id": videoId1.toString(),
      "comments": EditCommentController.value.text.trim().toString(),
      "comment_id": value.toString(),
      "time": DateTime.now().microsecondsSinceEpoch.toString(),
    };
    print("REPLYCOMMANTHASH${hashMap}");
    commentReply(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        EditCommentController.value.clear();
        refreshVal.value = refreshVal.value ? false : true;
        //getCommentListAPIs(videoId1.value, false);
      }
    });
  }

  void likeCommentAPIs(
      String videoId, String tblVideoCommentiId, String isLike) {
    Map<String, String> params = {
      "user_id": userLoginModel!.data.userId.toString(),
      "video_id": videoId,
      "comment_id": tblVideoCommentiId,
      "like": isLike == "no" ? "like" : "unlike",
    };
    print("LIKEEECOMMENTTT$params");
    likeCommmentAPI(params).then((value) {
      if (value.status) {
        //toastMessage(value.message.toString());
        Get.back();
        getCommentListAPIs(videoId1.value, false);
      } else {
        toastMessage(value.message.toString());
      }
    });
  }

// {user_id: 2, follwoing_user_id: 3}
// I/flutter (26426): FOLLOW{"message":"Unfollow user Sucssefully.","status":"1"}
  void userFollowAPIs(VideoDatum model) {
    userFollowAPI({
      "user_id": userLoginModel!.data.userId.toString(),
      "follwoing_user_id": model.userId.toString()
    }).then((value) {
      if (value.status) {
        toastMessage(value.message.capitalized);

        videoList.value.forEach((element) {
          if (element.userId == model.userId) {
            model.follow =
                value.message == "User Follow Successfully." ? "yes" : "no";
          }
          videoList.refresh();
        });

        //checkFollowingUserAPIs();
      }
      Get.back();
    });
  }

  void giftListAPIs() {
    giftListAPI().then((value) {
      if (value.status) {
        GiftModel gift = value.data;
        giftModelList.value = gift.data;
        giftModelList.first.isSelected = true;
      } else {
        showErrorBottomSheet(value.message);
      }
    });
  }

  void getFirebaseTokenAPIs() {
    updateFirebaseTokenAPI({
      "user_id": userLoginModel!.data.userId,
      "firebase_token": appController.tokenVal.value
    }).then((value) {});
  }
}
