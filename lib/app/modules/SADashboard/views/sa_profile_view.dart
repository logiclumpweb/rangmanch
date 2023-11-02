import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/fr_constants.dart';

import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/View/UsersAndLikesVideosScreen.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/app/modules/SADashboard/views/GiftTransactionScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_conversion_iew.dart';
import 'package:champcash/models/UserLikedVideoListModel.dart';
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

import '../../../../Auth/UpdateProfileDetailView.dart';
import 'UserFollowersView.dart';

class SAProfileView extends GetView<ProfileController> {
  const SAProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
            child: Scaffold(
          backgroundColor: Colors.black,
          body: controller.profileVisibilityVal.value
              ? Column(
                  children: [
                    headingWwidget(context),
                    profileWidget(context),
                    addPadding(0, 15),
                    followingFLWidget(context),
                    tabsWidget(),
                    addPadding(0, 4),
                    Expanded(
                        child: PageView.builder(
                      controller: controller.pageController,
                      allowImplicitScrolling: false,
                      //  physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (page) {
                        controller.pageIndex.value = page;
                      },
                      itemBuilder: (context, index) {
                        return controller.pageIndex.value == 0
                            ? MyVideosScreen()
                            : MyLikeVideosScreen();
                      },
                      itemCount: 2,
                    ))
                  ],
                )
              : const Center(child: GIFLaaderPage()),
        )));
  }

  Widget _createItem(bool selected, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color:
                      selected ? Colors.white : Colors.white.withOpacity(0.5),
                  width: 2))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(
          child: headingText(
              title: title,
              color: selected ? Colors.white : Color(0xff534F5A),
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
      ),
    );
  }

  createFragmentUI(bool selected, String title) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: selected
                      ? const Color(0xff8BCF52)
                      : const Color(0xffEFEFEF),
                  width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, bottom: 10, top: 10),
          child: headingText(
              title: title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  selected ? const Color(0xff8BCF52) : const Color(0xff3E57B4)),
        ));
  }

  Future<void> menuPopUpActionMethod(
      Offset globalPosition, BuildContext context) async {
    print("gcvdvgdvdgvgvv");
    double left = globalPosition.dx;
    double top = globalPosition.dy;
    await showMenu(
      color: Colors.white,
      //add your color
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 40),
            child: Row(
              children: const [
                Icon(Icons.report),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Report",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 40),
            child: Row(
              children: const [
                Icon(Icons.block),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Block",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 1) {
        controller.getUserReportAPIs("user", "", "");
        //do your task here for menu 1
      }
      if (value == 2) {
        blockBottomSheetUI();
        //do your task here for menu 2
      }
    });
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
                                controller.userBlockAPIs();
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

  headingWwidget(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          SABackButton(
              onPressed: () {
                controller.dContoller.updateBottomIndex(0);
              },
              color: ColorConstants.APPPRIMARYWHITECOLOR),
          const Spacer(),
          controller.myUserId.value == controller.tblUserId.value
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: IconButton(
                      onPressed: () {
                        Get.to(const GiftTransactionScreen());
                      },
                      icon: const NetworkImageView(
                        imgUrl:
                            "https://cdn-icons-png.flaticon.com/128/8146/8146553.png",
                      )),
                ).paddingOnly(right: 10)
              : IconButton(
                  onPressed: () {
                    Get.to(ConversionView(
                      peerId: controller.userProfileModel.value!.data.userId,
                      nickName:
                          controller.userProfileModel.value!.data.userName,
                      photoUrl:
                          controller.userProfileModel.value!.data.userImage,
                    ));
                  },
                  icon: Icon(
                    Icons.messenger_outline,
                    size: 20,
                    color: ColorConstants.APPPRIMARYWHITECOLOR,
                  )),
          controller.myUserId.value == controller.tblUserId.value
              ? GestureDetector(
                  onTap: () {
                    Get.to(const MyProfileView())!.then((value) {
                      controller.mLikedlist.clear();
                      controller.userVideosList.clear();
                      controller.getProfileDetailAPIs();
                    });
                  },
                  child: SizedBox(
                      height: 18, child: Image.asset("assets/menuprofile.png")),
                )
              : IconButton(
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

  profileWidget(BuildContext context) {
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 20, right: 10),
              child: SizedBox(
                  height: 115,
                  width: 115,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 115,
                            height: 115,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    width: 1,
                                    color: ColorConstants.appPrimaryColor
                                        .withOpacity(0.50))),
                            child: ClipOval(
                              child: controller.userProfileModel.value == null
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      fit: BoxFit.cover,
                                      image: controller.profileUrl.value,
                                    ),
                            ).paddingAll(1),
                          ),
                          userLoginModel!.data.userId ==
                                  controller.tblUserId.value
                              ? SizedBox()
                              : Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // easyProgressDialog(context);

                                      controller.userFollowAPIs(
                                          controller.tblUserId.value);
                                    },
                                    child: SACellNSRoundContainer(
                                        height: 24,
                                        width: 24,
                                        color: controller.isFollowVal.value
                                            ? Colors.red
                                            : ColorConstants
                                                .APPPRIMARYWHITECOLOR,
                                        child: Icon(
                                          controller.isFollowVal.value
                                              ? Icons.remove
                                              : Icons.add,
                                          color: controller.isFollowVal.value
                                              ? ColorConstants
                                                  .APPPRIMARYWHITECOLOR
                                              : ColorConstants
                                                  .APPPRIMARYBLACKCOLOR,
                                          size: 12,
                                        ),
                                        radius: 50,
                                        borderWidth: 0,
                                        borderWidthColor:
                                            ColorConstants.APPPRIMARYCOLOR1),
                                  ),
                                ).paddingOnly(bottom: 4),
                        ],
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headingText(
                      title: controller.userProfileModel.value == null
                          ? ""
                          : controller
                              .userProfileModel.value!.data.userName.capitalize,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.APPPRIMARYWHITECOLOR),
                  addPadding(4, 0),
                  controller.userProfileModel.value!.data.profileVerified == "0"
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
                        ).paddingOnly(right: 1.5)
                ],
              ),
            ),
            //   const Spacer(),
          ],
        ));
  }

  tabsWidget() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: GestureDetector(
            child: _createItem(controller.pageIndex.value == 0, 'Videos'),
            onTap: () {
              controller.pageIndex.value = 0;
              controller.pageController.jumpToPage(controller.pageIndex.value);
            },
          )),
          Expanded(
              child: GestureDetector(
            child: _createItem(controller.pageIndex.value == 1, 'Liked Videos'),
            onTap: () {
              controller.pageIndex.value = 1;
              controller.pageController.jumpToPage(controller.pageIndex.value);
            },
          )),
        ],
      ),
    );
  }

  followingFLWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        titleSubTitleTextWidget(
            controller.userProfileModel.value == null
                ? "0"
                : controller.userProfileModel.value!.data.totalFollowers,
            "Followers"),
        titleSubTitleTextWidget(
            controller.userProfileModel.value == null
                ? "0"
                : controller.userProfileModel.value!.data.totalFollowing,
            "Followings"),
        titleSubTitleTextWidget(
            controller.userProfileModel.value == null
                ? "0"
                : controller.userProfileModel.value!.totalLikesVideo,
            "Likes"),
      ],
    ).paddingOnly(left: 60, right: 60, bottom: 15);
  }

  titleSubTitleTextWidget(String label, String value) {
    return GestureDetector(
      onTap: () {
        if (value != "Likes") {
          Get.to(UserFollowersView(
            userId: controller.tblUserId.value, pageType: value,
          ));
        };
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
                closeBottomSheetUI(),
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
                          controller.getUserReportAPIs("user", "", "");
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
    /*Get.dialog(Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: ColorConstants.APPPRIMARYWHITECOLOR,
                borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
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
                                  offset: const Offset(2, 3),
                                  blurRadius: 4,
                                  color: Colors.grey.withOpacity(0.8))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CachedNetworkImage(
                            imageUrl: cancelIconUrl,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GradientRedButton2(
                      text: "Report".tr.toUpperCase(),
                      onPressed: () {
                        Get.back();
                        reportBottomSheetUI();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GradientButton1(
                      text: "BLOCK".tr,
                      onPressed: () {
                        Get.back();
                        blockBottomSheetUI();
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    ));*/
  }

  closeBottomSheetUI() {
    return Padding(
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
    );
  }
}

class MyLikeVideosScreen extends StatelessWidget {
  MyLikeVideosScreen({super.key});
  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => controller.mLikedlist.isNotEmpty
        ? NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.myMoreLikeVideosVal.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                controller.myMoreLikeVideosVal.value = true;

                controller.getUserLikedVideosData(
                    controller.mLikedlist.last.lastId.toString());
              }
              return false;
            },
            child: GridView.builder(
                itemCount: controller.mLikedlist.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 225,
                    crossAxisSpacing: 0),
                itemBuilder: (_, index) {
                  likeVideoDatum? m = controller.mLikedlist.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5, right: 8),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(UserVideoPlayerView(
                                        thumbnail: m!.videoThumb,
                                        videoUrl: m.video,
                                        type: "Like",
                                        index: index,
                                        userVideoList: [],
                                        likeVideoList: controller.mLikedlist!,
                                      ))!
                                          .then((value) {
                                        if (value != null) {
                                          controller.mLikedlist.clear();
                                          controller.getUserLikedVideosData("");
                                        }
                                      });
                                    },
                                    child: NetworkImageView(
                                      fit: BoxFit.cover,
                                      imgUrl: m!.videoThumb,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        controller.myUserId.value == controller.tblUserId.value
                            ? Positioned(
                                child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.likeApi(m.tblVedioId);
                                      // deleteVideo(mLikedlist[index].tblVedioId);
                                    },
                                    child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor:
                                            ColorConstants.APPPRIMARYWHITECOLOR,
                                        foregroundColor:
                                            ColorConstants.APPPRIMARYWHITECOLOR,
                                        child: const Icon(
                                          Icons.delete,
                                          size: 16,
                                          color: ColorConstants
                                              .APPPRIMARYBLACKCOLOR,
                                        )),
                                  ),
                                ),
                              ))
                            : const SizedBox(),
                      ],
                    ),
                  );
                }))
        : controller.myLikesVideoNoRecordsFoundVal.value
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: NoRecordFoundView(),
              )
            : const GIFLaaderPage());
  }
}

class MyVideosScreen extends StatelessWidget {
  MyVideosScreen({super.key});

  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => controller.userVideosList.isNotEmpty
        ? NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              // print("JJJJUUPPPP");
              if (!controller.myMoreVideosVal.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                controller.myMoreVideosVal.value = true;

                controller.getUserVideosData(
                    controller.userVideosList.last.tblVedioId.toString());
              }
              return false;
            },
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: controller.userVideosList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 225,
                    crossAxisSpacing: 5),
                itemBuilder: (_, index) {
                  //MFDatum mDatum=controller.myFavoritesModelList.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(UserVideoPlayerView(
                          thumbnail:
                              controller.userVideosList[index].videoThumb,
                          videoUrl: controller.userVideosList[index].video,
                          type: "User",
                          index: index,
                          userVideoList: controller.userVideosList,
                          likeVideoList: [],
                        ))?.then((value) {
                          videoStatusUpdate.add(PAUSE);
                          print("GTTTBKKVAKL${value}");
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
                                      imgUrl: controller
                                          .userVideosList[index].videoThumb,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          controller.myUserId.value ==
                                  controller.tblUserId.value
                              ? Positioned(
                                  child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        dialog(
                                            context,
                                            controller.userVideosList[index]
                                                .tblVedioId);
                                      },
                                      child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: ColorConstants
                                              .APPPRIMARYWHITECOLOR,
                                          foregroundColor: ColorConstants
                                              .APPPRIMARYWHITECOLOR,
                                          child: const Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: ColorConstants
                                                .APPPRIMARYBLACKCOLOR,
                                          )),
                                    ),
                                  ),
                                ))
                              : const SizedBox(),
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
          )
        : controller.userVideoNoRecordsUI.value
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: NoRecordFoundView(),
              )
            : const GIFLaaderPage());
  }

  void dialog(BuildContext context, dynamic m) {
    showDialog(
        context: context,
        builder: (ct) => AlertDialog(
              title: Text("Confirmation?",
                  style: textStyleW500(
                      color: ColorConstants.APPPRIMARYBLACKCOLOR)),
              content: Text(
                "Do you want to delete this video.",
                style:
                    textStyleW500(color: ColorConstants.APPPRIMARYBLACKCOLOR),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("No",
                        style: textStyleW500(
                            color: ColorConstants.APPPRIMARYBLACKCOLOR))),
                TextButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteVideo(m);
                    },
                    child: Text("Yes",
                        style: textStyleW500(
                            color: ColorConstants.APPPRIMARYBLACKCOLOR)))
              ],
            ));
  }
}
