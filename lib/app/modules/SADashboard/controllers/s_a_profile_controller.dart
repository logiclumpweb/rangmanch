import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/fr_constants.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/models/UserLikedVideoListModel.dart';
import 'package:champcash/models/UserUplodedVideoListModel.dart';
import 'package:champcash/models/issueListModel.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/extras.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/GetProfileDataModel.dart';
import '../../../../models/follow_model.dart';
import '../../../../models/followlist_model.dart';
import '../views/UserFollowersView.dart';

class ProfileController extends GetxController {
  RxList<likeVideoDatum> mLikedlist = <likeVideoDatum>[].obs;
  final PageController pageController = PageController();
  final PageController ffPageController = PageController();
  RxList<getVideoDatum> userVideosList = <getVideoDatum>[].obs;
  final ratingValue = 5,
      pageIndex = 0.obs,
      ffPageIndex = 0.obs,
      page = 0.obs,
      isMoreLoading = false.obs,
      lastID = "0".obs,
      userVideoLikedNoRecordsUI = false.obs,
      userVideoNoRecordsUI = false.obs,
      tblUserId = "0".obs,
      myUserId = "0".obs,
      myMoreVideosVal = false.obs,
      myMoreLikeVideosVal = false.obs;
  final userProfileModel = Rxn<GetProfileDataModel>();
  final dContoller = Get.find<SADashboardController>();

  final isVisilibiltyUserUi = true.obs, profileVisibilityVal = false.obs;

  RxList<RPTDatum> mIssueModelList = <RPTDatum>[].obs;
  RxList<followDatum> mFollowList = <followDatum>[].obs;
  RxList<fDatum> mFList = <fDatum>[].obs;
  final myLikesVideoNoRecordsFoundVal = false.obs;
  final followStatus = "".obs,
      isRefreshingVal = true.obs,
      isFollowVal = true.obs;

  final profileUrl = "https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg".obs;

  @override
  void onInit() {
    super.onInit();
    onInit1("");
  }

  void getProfileDetailAPIs() async {
    userVideoLikedNoRecordsUI.value = false;
    userVideoNoRecordsUI.value = false;
    print("QQQQQPROFILEEEEE${tblUserId.value}");
    APIResponse response =
        await getProfileDetailAPI({"user_id": tblUserId.value});
    if (response.status) {
      GetProfileDataModel model = response.data;
      userProfileModel.value = model;
      dContoller.profileUrl.value = userProfileModel.value!.data.userImage;
      profileUrl.value = userProfileModel.value!.data.userImage;
    } else {
      userProfileModel.value = null;
      showErrorBottomSheet(response.message.toString());
    }
    getUserLikedVideosData("");
    getUserVideosData("");
  }

  getUserLikedVideosData(String lastID) async {
    var hashMap = {
      "user_id": myUserId.value,
      "last_id": lastID == "" ? "" : lastID,
      "owner_id": tblUserId.value
    };
    print("LIKKKKKPARRM${hashMap}");
    userLikedVideoApi(hashMap).then((value) {
      myMoreLikeVideosVal.value = false;
      if (value.status) {
        myLikesVideoNoRecordsFoundVal.value = false;
        UserLikedVideoListModel model = value.data;
        List<likeVideoDatum> mVi = model.data;
        mLikedlist.addAll(mVi);
      } else {
        myLikesVideoNoRecordsFoundVal.value = true;
        userVideoLikedNoRecordsUI.value = true;
      }
    });
  }

//profile_verified
  void getUserVideosData(String lastID) {
    var hashMap = {
      "user_id": tblUserId.value,
      "tbl_vedio_id": lastID == "" ? "0" : lastID,
      "self_user_id": userLoginModel!.data.userId
    };
    print("HASGHHHMAP$hashMap");
    userUploadedVideoApi(hashMap).then((value) {
      if (value.status) {
        userVideoNoRecordsUI.value = false;
        UserUplodedVideoListModel model = value.data;
        List<getVideoDatum> vi = model.data;
        userVideosList.addAll(vi);
        userVideosList.refresh();
      } else {
        userVideoNoRecordsUI.value = true;
      }
      profileVisibilityVal.value = true;
      myMoreVideosVal.value = false;
    });
  }

  void deleteVideo(String vedioId) {
    var hashMap = {
      "tbl_vedio_id": vedioId,
      "user_id": tblUserId.value,
    };
    print(hashMap);
    userVideoDelete(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        userVideoNoRecordsUI.value = false;
        userVideosList.clear();
        getUserVideosData("");
      }
    });
  }

  void likeApi(String tblVedioId) {
    var hashMap = {
      "user_id": tblUserId.value,
      "video_id": tblVedioId,
      "like": "unlike",
    };

    homeVideoLikeApi(hashMap).then((value) {
      if (value.status) {
        print(value.message);
        mLikedlist.clear();
        getProfileDetailAPIs();
        //  getUserLikedVideosData("");
      } else {
        toastMessage(value.message);
      }
    });
  }

  callingOtherUserDetail(String string) {
    tblUserId.value = string;
    checkFollowingAPIs();
  }

  void onInit1(String userId) {
    tblUserId.value =
        userId == "" ? userLoginModel!.data.userId.toString() : userId;
    myUserId.value = userLoginModel!.data.userId.toString();
    mLikedlist.clear();
    userVideosList.clear();
    checkFollowingAPIs();
  }

  checkFollowingAPIs() {
    getUserFollowUnFollowingAPI(tblUserId.value).then((value) {
      if (value.status) {
        isFollowVal.value = true;
      } else {
        isFollowVal.value = false;
      }
      String status = isFollowVal.value ? "yes" : "no";
      FirebaseFirestore.instance
          .collection(FireBaseConstants.pathUserFollowCollection)
          .doc(userLoginModel!.data.userId.toString())
          .collection(FireBaseConstants.allFollowing)
          .doc(tblUserId.value)
          .update({FireBaseConstants.isFollow: status});
      getProfileDetailAPIs();
    });
  }

  void userBlockAPIs() {
    //  params.put("user_id", sessionManager.getUserDeatail().getUser_id() + "");
    //                 params.put("type", "block");
    //                 params.put("blocked_user_id", from_key);
    //                 params.put("report_msg", "Block from my end");
    //                 Log.e("newpar", params + "");
    userBlockAPI({
      "user_id": myUserId.value,
      "type": "block",
      "blocked_user_id": tblUserId.value,
      "report_msg": "Block from my end"
    }).then((value) {
      if (value.status) {
        Get.back();
        toastMessage(value.message);
        dContoller.updateBottomIndex(0);
        dContoller.videoList.clear();
        dContoller.videoList.refresh();
        dContoller.onInit();
      } else {
        showErrorBottomSheet(value.message);
      }
    });
  }

  void getUserReportAPIs(String s, String tblVedioId, String userId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "type": s,
    };
    print(hashMap);
    getIssueListApi(hashMap).then((value) {
      if (value.status) {
        IssueListModel model = value.data;
        List<RPTDatum> list = model.data;
        mIssueModelList.value = list;
        openUserReportDialogUI(mIssueModelList, tblVedioId, userId);
      }
    });
  }

  void openUserReportDialogUI(
      RxList<RPTDatum> mIssueModelList, String tblVedioId, String userId) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
          color: ColorConstants.APPPRIMARYWHITECOLOR,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      addPadding(10, 0),
                      headingText(
                          title: "Select Reason",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          align: TextAlign.center,
                          color: ColorConstants.APPPRIMARYBLACKCOLOR),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: NetworkImageView(
                            imgUrl:
                                "https://cdn-icons-png.flaticon.com/128/748/748122.png",
                          ).paddingAll(3),
                        ).paddingOnly(right: 10),
                      )
                    ],
                  ).paddingAll(8),
                  addPadding(0, 20),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mIssueModelList!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: GestureDetector(
                                onTap: () {
                                  callingVideoReportAPI(
                                      mIssueModelList[index].videoIssueListId,
                                      tblVedioId,
                                      userId);
                                  // reportVideoAPIs(
                                  //     mlist.data[index].videoIssueListId
                                  //         .toString(),
                                  //     videoModel);
                                },
                                child: headingLongText(
                                    title: mIssueModelList[index].title,
                                    fontWeight: FontWeight.w500,
                                    align: TextAlign.center,
                                    fontSize: 15,
                                    color: ColorConstants.APPPRIMARYBLACKCOLOR),
                              ),
                            ),
                            Divider(
                              color: ColorConstants.APPPRIMARYGREYCOLOR
                                  .withOpacity(0.7),
                            ).paddingAll(10),
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
    ));
  }

  void submitUserReportAPIs(String videoIssueListId, String title) {
    // params.put("user_id", sessionManager.getUserDeatail().getUser_id());
    //                 params.put("report_to_user_id", video_user_id);
    //                 params.put("reports_msg", video_issue_list_id);
    //                 Log.e("add_report_api", params.toString() + "");
    //{

    //     }

    submitUserReportAPI({
      "user_id": myUserId.value,
      "report_to_user_id": tblUserId.value,
      "reports_msg": title
    }).then((value) {
      if (value.status) {
        Get.back();
        toastMessage(value.message);
      }
    });
  }

  callingVideoReportAPI(String videoIssueId, String tblVedioId, String userId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": tblVedioId,
      "video_user_id": userId,
      "issue_list_id": videoIssueId,
    };
    print(hashMap);
    reportVideoApi(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        Get.back();
      } else {
        Get.back();
        showErrorBottomSheet(value.message);
      }
    });
  }

  Future<void> userFollowAPIs(String followingUserId) async {
    userFollowAPI(
            {"user_id": myUserId.value, "follwoing_user_id": followingUserId})
        .then((value) {
      if (value.status) {
        toastMessage(value.message);
        checkFollowingAPIs();
      }
    });
  }

  Future<void> userFollowAPIs1(String followingUserId) async {
    userFollowAPI(
            {"user_id": myUserId.value, "follwoing_user_id": followingUserId})
        .then((value) {
      if (value.status) {
        toastMessage(value.message);
        // checkFollowingAPIs();
      }
    });
  }

  void checkFollowingUserAPIs() {
    checkFollowingUserAPI(
            {"user_id": myUserId.value, "user_id_2": tblUserId.value})
        .then((value) {
      if (value.status) {
        Map data1 = value.data["data"];
        followStatus.value = data1["following_him"];
        //print(checkFollow["following_him"].toString()+"xgsdgsfdgsfgdfgsfd");
      }
    });
  }
}
