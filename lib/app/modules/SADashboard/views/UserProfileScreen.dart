import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/fr_constants.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/View/UsersAndLikesVideosScreen.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/app/modules/SADashboard/views/GiftTransactionScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/UserFollowersView.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_conversion_iew.dart';
import 'package:champcash/controller/DashBoardController.dart';
import 'package:champcash/models/GetProfileDataModel.dart';
import 'package:champcash/models/UserUplodedVideoListModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/extras.dart';
import 'package:champcash/tab/MyProfileView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final dContoller = Get.find<SADashboardController>();
  GetProfileDataModel? userProfileModel;

  String profileUrl = "https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg",
      ownerUserId = "0";

  List<getVideoDatum> userVideosList = [];

  bool myMoreVideosVal = false, followingStatusVal = false;

  @override
  void initState() {
    super.initState();
    ownerUserId = userLoginModel!.data.userId;
    checkFollowingAPIs(widget.userId);
  }

  void getProfileDetailAPIs() async {
    APIResponse response =
        await getProfileDetailAPI({"user_id": widget.userId});
    if (response.status) {
      GetProfileDataModel model = response.data;
      userProfileModel = model;
      //  dContoller.profileUrl.value = userProfileModel.value!.data.userImage;
      profileUrl = userProfileModel!.data.userImage;
    } else {
      userProfileModel = null;
      showErrorBottomSheet(response.message.toString());
    }
    setState(() {});
    getUserVideosData("");
  }

  void getUserVideosData(String lastID) {
    var hashMap = {
      "user_id": widget.userId,
      "tbl_vedio_id": lastID == "" ? "0" : lastID,
      "self_user_id": userLoginModel!.data.userId
    };
    print("HASGHHHMAP$hashMap");
    userUploadedVideoApi(hashMap).then((value) {
      if (value.status) {
        UserUplodedVideoListModel model = value.data;
        List<getVideoDatum> vi = model.data;
        userVideosList.addAll(vi);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: userProfileModel == null
              ? const Center(
                  child: GIFLaaderPage(),
                )
              : Column(
                  children: [
                    buildAppBarUI(),
                    profileUI(context),
                    addPadding(0, 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleSubTitleTextUI(
                            userProfileModel == null
                                ? "0"
                                : userProfileModel!.data.totalFollowers,
                            "Followers"),
                        titleSubTitleTextUI(
                            userProfileModel == null
                                ? "0"
                                : userProfileModel!.data.totalFollowing,
                            "Followings"),
                        titleSubTitleTextUI(
                            userProfileModel == null
                                ? "0"
                                : userProfileModel!.totalLikesVideo,
                            "Likes"),
                      ],
                    ).paddingOnly(left: 60, right: 60, bottom: 15),
                    cGridViewListItem(context)
                  ],
                ),
        ));
  }

  buildAppBarUI() {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          SABackButton(
              onPressed: () {
                Get.back();
              },
              color: ColorConstants.APPPRIMARYWHITECOLOR),
          const Spacer(),
          IconButton(
              onPressed: () {
                Get.to(ConversionView(
                  peerId: userProfileModel!.data.userId,
                  nickName: userProfileModel!.data.userName,
                  photoUrl: userProfileModel!.data.userImage,
                ));
              },
              icon: Icon(
                Icons.messenger_outline,
                size: 20,
                color: ColorConstants.APPPRIMARYWHITECOLOR,
              )),
          IconButton(
            onPressed: () {
              blockAndReportBottomUI();
            },
            icon: RotatedBox(
              quarterTurns: 2,
              child: Image.asset(
                "assets/menuicon.png",
                width: 18,
                height: 15,
              ),
            ),
          ),
          addPadding(10, 0)
        ],
      ),
    );
  }

  profileUI(BuildContext context) {
    String url = "https://cdn-icons-png.flaticon.com/128/748/748004.png";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 20, right: 10),
          child: SizedBox(
              height: 115,
              width: 115,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 1,
                          color: ColorConstants.appPrimaryColor
                              .withOpacity(0.50))),
                  child: ClipOval(
                    child: userProfileModel == null
                        ? const Center(child: CircularProgressIndicator())
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            fit: BoxFit.cover,
                            image: profileUrl,
                          ),
                  ).paddingAll(1),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headingText(
                  title: userProfileModel == null
                      ? ""
                      : userProfileModel!.data.userName.capitalize,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.APPPRIMARYWHITECOLOR),
              addPadding(4, 0),
              userProfileModel!.data.profileVerified == "0"
                  ? const SizedBox()
                  : const Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: NetworkImageView(
                            imgUrl:
                                "https://cdn-icons-png.flaticon.com/128/9918/9918694.png"),
                      ),
                    ).paddingOnly(right: 1.5),
            ],
          ),
        ),

       GestureDetector(
          onTap: () {
            userVideosList.clear();
            userFollowAPIs(widget.userId);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.4),
                    width: 1)),
            height: 37,
            width: 110,
            child: Center(
              child: Text(followingStatusVal ? "Following" : "Follow",
                  style: textStyleW600(
                      color: ColorConstants.appPrimaryColor, fontSize: 13)),
            ),
          ),
        ).paddingOnly(left: 10, top: 10),
        //   const Spacer(),
      ],
    );
  }

  void blockAndReportBottomUI() {
    Get.bottomSheet(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.APPPRIMARYWHITECOLOR,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55),
                            color: ColorConstants.APPPRIMARYWHITECOLOR,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 0,
                                  color: Colors.grey.withOpacity(0.0))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.network(
                            "https://cdn-icons-png.flaticon.com/128/748/748122.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //buildCloseButton(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 5, 30, 0),
                  child: Image.asset("assets/imgReportBlockheader.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: headingFullText(
                      title:
                          "If a user is violating Verbling policy,you can block them from messaging you and report them.",
                      fontWeight: FontWeight.w600,
                      align: TextAlign.center,
                      fontSize: 16,
                      color: ColorConstants.APPPRIMARYBLACKCOLOR),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32, top: 8),
                  child: headingFullText(
                      title:
                          "Only block/report a user who is violating Verbling policy.",
                      fontWeight: FontWeight.w300,
                      align: TextAlign.center,
                      fontSize: 14,
                      color: ColorConstants.APPPRIMARYBLACKCOLOR),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: CommonButton(
                        text: "Block",
                        onPressed: () {
                          Get.back();
                          blockBottomSheetUI();
                          // blockBottomSheetUI();
                        },
                        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
                      )),
                      addPadding(10, 0),
                      Expanded(
                          child: CommonButton(
                        text: "Report",
                        onPressed: () {
                          Get.back();
                          Get.find<ProfileController>()
                              .getUserReportAPIs("user", "", "");
                        },
                        backgroundColor: Colors.red,
                      )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    }), isScrollControlled: true);
  }

  blockBottomSheetUI() {
    Get.bottomSheet(Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorConstants.appPrimaryWhiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              children: [
                addPadding(25, 15),
                headingText(
                    title: "Are you sure you want to block?",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.appPrimarylightBlackColor),
                addPadding(15, 0),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20),
                ),
                addPadding(17, 0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SACellRoundContainer(
                                height: 45,
                                width: 120,
                                color: const Color(0xffffffff),
                                child: Center(
                                  child: headingText(
                                      title: "Cancel",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ColorConstants.appPrimaryBlackColor),
                                ),
                                radius: 15,
                                borderWidth: 0,
                                borderWidthColor: Colors.transparent),
                          ),
                        ),
                        Expanded(
                          child: GradientButton1(
                              width: 120,
                              height: 45,
                              text: "Block",
                              onPressed: () {
                                userBlockAPIs();
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                addPadding(15, 0),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  titleSubTitleTextUI(String label, String value) {
    return GestureDetector(
      onTap: () {
        if (value != "Likes") {
          Get.find<ProfileController>().ffPageIndex.value =
              value == "Followers" ? 0 : 1;
          Get.to(UserFollowersView(
            userId: widget.userId,pageType:value
          ));
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ).paddingOnly(left: 0),
            addPadding(0, 4),
            Text(
              value,
              style: GoogleFonts.urbanist(
                  fontSize: 13.5,
                  color: Color(0xff6f6f6f),
                  fontWeight: FontWeight.w500),
            )
          ],
        ).paddingOnly(right: 14),
      ),
    );
  }

  cGridViewListItem(BuildContext context) {
    return Expanded(
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          // print("JJJJUUPPPP");
          if (myMoreVideosVal &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            myMoreVideosVal = true;

            getUserVideosData(userVideosList.last.tblVedioId.toString());
          }
          return false;
        },
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: userVideosList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 225, crossAxisSpacing: 5),
            itemBuilder: (_, index) {
              //MFDatum mDatum=controller.myFavoritesModelList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5),
                child: GestureDetector(
                  onTap: () {
                    Get.to(UserVideoPlayerView(
                      thumbnail: userVideosList[index].videoThumb,
                      videoUrl: userVideosList[index].video,
                      type: "User",
                      index: index,
                      userVideoList: userVideosList,
                      likeVideoList: [],
                    ))?.then((value) {
                      videoStatusUpdate.add(PAUSE);
                    });
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 215,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: NetworkImageView(
                                  imgUrl: userVideosList[index].videoThumb,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),

                      /*Positioned(
                     right: 40,
                     top: 45,
                     child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: SizedBox(
                         height: 25,width: 25,
                         child:  Icon(Icons.play_circle_outline,size: 24,color:ColorConstants.APPPRIMARYWHITECOLOR,),
                       ),
                     )),*/
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> userFollowAPIs(String followingUserId) async {
    userFollowAPI({
      "user_id": userLoginModel!.data.userId,
      "follwoing_user_id": followingUserId
    }).then((value) {
      if (value.status) {
        toastMessage(value.message);
        checkFollowingAPIs(followingUserId);
      }
    });
  }

  checkFollowingAPIs(String followingUserId) {
    getUserFollowUnFollowingAPI(followingUserId).then((value) {
      followingStatusVal = value.status;
      String status = value.status ? "yes" : "no";
      FirebaseFirestore.instance
          .collection(FireBaseConstants.pathUserFollowCollection)
          .doc(userLoginModel!.data.userId.toString())
          .collection(FireBaseConstants.allFollowing)
          .doc(followingUserId)
          .update({FireBaseConstants.isFollow: status});
      setState(() {});
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
      "user_id": ownerUserId,
      "type": "block",
      "blocked_user_id": widget.userId,
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
}
