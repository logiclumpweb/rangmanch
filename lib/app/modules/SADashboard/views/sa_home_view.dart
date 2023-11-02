import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:champcash/app/modules/SADashboard/views/UseMyMusicScreen.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:http/http.dart' as http;
import 'package:champcash/Apis/api.dart';
import 'package:champcash/Apis/api/api.dart';
import 'package:champcash/Apis/urls.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/fr_constants.dart';
import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/app/modules/SADashboard/views/NotificationPage.dart';
import 'package:champcash/app/modules/SADashboard/views/UserProfileScreen.dart';
import 'package:champcash/models/GiftModel.dart';
import 'package:champcash/models/ReelVideoListModel.dart';
import 'package:champcash/models/viewcomment_model.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/add_favorite.dart';
import 'package:champcash/shared/argear_button.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/label_button.dart';
import 'package:champcash/shared/sa_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import '../../../../shared/extras.dart';

class SAHomeView extends GetView<SADashboardController> {
  const SAHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: RefreshIndicator(
            strokeWidth: 3,
            color: ColorConstants.APPPRIMARYCOLOR,
            onRefresh: () {
              controller.videoList.clear();
              controller.getVideoList(0);
              return Future<void>.delayed(const Duration(milliseconds: 100));
            },
            child: Scaffold(
              backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
              body: controller.videoList.isEmpty
                  ? controller.isReelScreenVal.value
                      ? NoRecordFoundView()
                      : const GIFLaaderPage()
                  : SizedBox.expand(
                      child: PageView.builder(
                        controller: controller.homePageController,
                        allowImplicitScrolling: true,
                        onPageChanged: (page) {
                          Logger().d('Page-----------$page');
                          videoStatusUpdate.add(page);

                          FirebaseFirestore.instance
                              .collection(
                                  FireBaseConstants.pathUserFollowCollection)
                              .doc(userLoginModel!.data.userId.toString())
                              .collection(FireBaseConstants.allFollowing)
                              .doc(controller.videoList[page].userId)
                              .snapshots()
                              .listen((event) {
                            print(
                                "STTTATTSTS${event.get(FireBaseConstants.isFollow)}");
                            controller.videoList[page].isFollowStatus =
                                event.get(FireBaseConstants.isFollow);
                            controller.videoList.refresh();
                          });
                        },
                        itemBuilder: (context, index) {
                          VideoDatum model =
                              controller.videoList.elementAt(index);
                          print("EEEEEEE${model.tblVideoSoundId}");
                          return SizedBox(
                            child: Stack(
                              children: [
                                Container(
                                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                                    height: double.infinity,
                                    child: SAVideoPlayerNew(
                                      url: model.video,
                                      index: index,
                                      videoThumb: model.videoThumb,
                                    )),
                                Column(
                                  children: [
                                    appBarWidget(context, controller, model),
                                    const Spacer(),
                                    reelProfileWidget(model),
                                    //  useMusicUI(model),
                                    //addPadding(0, 5),
                                    model.tag.trim().isEmpty
                                        ? const SizedBox()
                                        : hashTagWidget(model, context),
                                    addPadding(0, 5),
                                    actionButtonWidget(context, model),
                                  ],
                                ),
                                Obx(() =>
                                    Visibility(
                                      visible:
                                          controller.shareUIVisibility.value,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: SACellRoundContainer(
                                          width: 115,
                                          color: ColorConstants
                                              .APPPRIMARYWHITECOLOR,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //

                                              TextButton(
                                                onPressed: () {
                                                  controller.shareUIVisibility
                                                      .value = false;
                                                  Share.share(model.video);
                                                },
                                                child: Text("Share",
                                                    style: textStyleW600(
                                                        fontSize: 15,
                                                        color: ColorConstants
                                                            .APPPRIMARYBLACKCOLOR)),
                                              ),
                                              TextButton(
                                                child: Text("Download",
                                                    style: textStyleW600(
                                                        fontSize: 15,
                                                        color: ColorConstants
                                                            .APPPRIMARYBLACKCOLOR)),
                                                onPressed: () {
                                                  controller.shareUIVisibility
                                                      .value = false;
                                                  downloadVideo(
                                                          context,
                                                          model.video,
                                                          model.videoName,
                                                          model.tblVedioId)
                                                      .whenComplete(() {
                                                    delay(
                                                        duration: 800,
                                                        onTap: () {
                                                          controller
                                                              .ignoreTappingVal
                                                              .value = false;
                                                        });
                                                  });
                                                },
                                              ),
                                            ],
                                          ).paddingOnly(left: 5),
                                          radius: 15,
                                          borderWidth: 0,
                                          borderWidthColor: Colors.transparent,
                                        ).paddingOnly(bottom: 60, right: 20),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        },
                        itemCount: controller.videoList.length,
                        scrollDirection: Axis.vertical,
                      ),
                    ),
              /* endDrawer: Obx(() => Drawer(
                backgroundColor: Colors.transparent,
                width: MediaQuery.of(context).size.width / 1.4,
                child: Container(
                  margin: const EdgeInsets.only(top: 90, bottom: 50),
                  width: double.infinity,
                  // padding: EdgeInsets.only(left: 16, right: 8, bottom: 8, top: 0),
                  decoration: BoxDecoration(
                      color: ColorConstants.APPPRIMARYBLACKCOLOR,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 8, bottom: 8),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: ColorConstants.APPPRIMARYBLACKCOLOR,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Channels',
                              style: TextStyle(
                                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                                  fontSize: 16),
                            ),
                            addPadding(0, 5),
                            Text(
                              'Select content you wish to see',
                              style: TextStyle(
                                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: ColorConstants.APPPRIMARYBLACKCOLOR,
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 10),
                            itemCount: controller.videoCategoryList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 135,
                                    crossAxisSpacing: 4),
                            itemBuilder: (BuildContext context, int index) {
                              print(controller.videoCategoryList[index].image);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6, top: 4, bottom: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller
                                        .videoCategoryList[index].isSelected) {
                                      controller.videoCategoryList[index]
                                          .isSelected = false;
                                      controller.catVidListId.remove(controller
                                          .videoCategoryList[index]
                                          .tblVideoCategoryId);
                                    } else {
                                      controller.catVidListId.add(controller
                                          .videoCategoryList[index]
                                          .tblVideoCategoryId);
                                      controller.videoCategoryList[index]
                                          .isSelected = true;
                                    }
                                    controller.videoCategoryList.refresh();
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 1.5,
                                                color: ColorConstants
                                                    .APPPRIMARYGREYCOLOR
                                                    .withOpacity(0.20))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: ImageViewCovered(
                                            photoUrl: controller
                                                .videoCategoryList[index].image,
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: headingFullText(
                                              title: controller
                                                  .videoCategoryList[index].name,
                                              align: TextAlign.center,
                                              fontSize: 14,
                                              color: ColorConstants
                                                  .APPPRIMARYWHITECOLOR)),
                                      controller
                                              .videoCategoryList[index].isSelected
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SACellRoundContainer(
                                                    height: 25,
                                                    width: 25,
                                                    color: ColorConstants
                                                        .APPPRIMARYWHITECOLOR,
                                                    child: const Icon(
                                                      Icons.check,
                                                      color: ColorConstants
                                                          .APPPRIMARYCOLOR,
                                                    ),
                                                    radius: 5,
                                                    borderWidth: 0,
                                                    borderWidthColor:
                                                        ColorConstants
                                                            .APPPRIMARYWHITECOLOR),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      GradientButton1(
                          height: 43,
                          text: "Submit",
                          onPressed: () {
                            String catVidChannel = controller.catVidListId
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "");
                            print(catVidChannel);
                            controller.videoList.clear();
                            controller.videoList.refresh();
                            controller.seeVideoListByChannelAPIs(catVidChannel);
                          }).paddingAll(14)
                    ],
                  ),
                ),
              )),*/
            ),
          ),
        ));
  }

  Future<void> downloadVideo(BuildContext context, String video,
      String videoName, String tblVedioId) async {
    EasyLoading.show(status: "Downloading");

    Dio dio = Dio();
    //if (await Permission.manageExternalStorage.request().isGranted) {
    Directory directory = Directory('/storage/emulated/0/Download/');
    // final downloadPath=(await getExternalStorageDirectory());
    var filePath = "${directory!.path}$videoName.mp4";
    await dio.download(video, filePath).then((value) {
      shareVCount(tblVedioId);
      dio.close();
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: headingFullText(
            title: "Downloading Complete File Save In Phone Storage ",
            fontWeight: FontWeight.w300),
        backgroundColor: ColorConstants.APPPRIMARYGREENCOLOR,
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: "OKAY",
          textColor: ColorConstants.APPPRIMARYWHITECOLOR,
          onPressed: () {
            // print("FILLEELELEL$filePath");
            // Share.shareFiles([filePath],
            //     subject: 'Hi Install this app and earn guaranteed rewards',
            //     text:
            //         "Enjoy and entertaining viral short videos on Rangmanch Download from Google playstore. https://play.google.com/store/apps/details?id=com.app.rangmanch");
            // //    FlutterDownloader.open(taskId: filePath);
          },
        ),
      ));
    }).catchError((e) {
      EasyLoading.dismiss();
      print(e.toString());
      showErrorBottomSheet(e.toString());
    });
    // }
  }

  void shareVCount(String tblVedioId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": tblVedioId.toString(),
    };
    print(hashMap);
    shareCountVideo(hashMap).then((value) {});
  }

  Future<void> likeApi(bool val, VideoDatum model) async {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": model.tblVedioId,
      "like": val == true ? "like" : "unlike",
    };
    homeVideoLikeApi(hashMap).then((value) {
      if (value.status) {
        if (value.message != "unlike video") {
          model.videoLikes = "yes";
          int like = int.parse(model.likes);
          like++;
          model.likes = like.toString();
        } else {
          model.videoLikes = "no";
          int like = int.parse(model.likes);
          like--;
          model.likes = like.toString();
        }
        /*model.videoLikes = "yes";
        int like = int.parse(model.likes);
        like++;*/
      }
      controller.videoList.refresh();
    });
  }

  actionButtonWidget(BuildContext context, VideoDatum model) {
    bool val = model.videoLikes == "no" ? false : true;

    return Obx(() => Row(
          mainAxisAlignment: userLoginModel!.data.userId == model.userId
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            userLoginModel!.data.userId == model.userId
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      controller.userIdVal.value = model.userId;
                      final pCont = Get.find<ProfileController>();
                      pCont.onInit1(controller.userIdVal.value);
                      pCont.profileVisibilityVal.value = false;
                      pCont.mLikedlist.clear();
                      pCont.userVideosList.clear();

                      Get.to(UserProfileScreen(
                        userId: model.userId,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorConstants.APPPRIMARYWHITECOLOR
                                  .withOpacity(0.4),
                              width: 1)),
                      height: 37,
                      width: 70,
                      child: Center(
                        child: Text(
                            model.isFollowStatus == "yes"
                                ? "Following"
                                : "Follow",
                            style: textStyleW600(
                                color: ColorConstants.appPrimaryColor,
                                fontSize: 12)),
                      ),
                    ),
                  ).paddingOnly(left: 4),

            userLoginModel!.data.userId == model.userId
                ? addPadding(4, 0)
                : addPadding(0, 0),
            // addFavoriteWidget(model, context),
            IgnorePointer(
              ignoring: controller.ignoreTappingVal.value,
              child: GestureDetector(
                onTap: () {
                  controller.ignoreTappingVal.value = true;
                  val = model.videoLikes == "no" ? true : false;
                  likeApi(val, model).whenComplete(() {
                    delay(
                        duration: 800,
                        onTap: () {
                          controller.ignoreTappingVal.value = false;
                        });
                  });
                },
                child: SACellRoundContainer1(
                        height: 37,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            addPadding(10, 0),
                            Icon(
                              val ? Icons.favorite : Icons.favorite_border,
                              color: val ? Colors.red : Colors.white,
                              size: 18,
                            ),
                            addPadding(10, 0),
                            Text(
                              (int.parse(model.likes)).toString(),
                              style: textStyleW600(
                                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                                  fontSize: 13),
                            ),
                            addPadding(10, 0)
                          ],
                        ).paddingOnly(left: 10, right: 10),
                        radius: 10,
                        borderWidth: 1.5,
                        borderWidthColor: ColorConstants.APPPRIMARYWHITECOLOR
                            .withOpacity(0.4))
                    .paddingOnly(left: 0),
              ),
            ),

            userLoginModel!.data.userId == model.userId
                ? addPadding(4, 0)
                : addPadding(0, 0),

            SALabelButton(
              onTap: () {
                Get.to(AllCommentsPage(
                        tblVideoId: model.tblVedioId.toString()))!
                    .then((value) {
                  if (value != null) {
                    model.comments = value;
                    controller.videoList.refresh();
                  }
                });
                //commentBottomSheetUI(model.tblVedioId.toString());
              },
              assetImage: "assets/chat.png",
              textColor: ColorConstants.APPPRIMARYWHITECOLOR,
              bColor: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.4),
              bWidth: 1.5,
              imgColor: ColorConstants.APPPRIMARYWHITECOLOR,
              title: model.comments,
              color: Colors.transparent,
            ),
            userLoginModel!.data.userId == model.userId
                ? addPadding(4, 0)
                : addPadding(0, 0),
            SALabelButton(
              onTap: () {
                controller.ignoreTappingVal.value = true;
                if (controller.shareUIVisibility.value) {
                  controller.shareUIVisibility.value = false;
                } else {
                  controller.shareUIVisibility.value = true;
                }
              },
              imgColor: ColorConstants.APPPRIMARYWHITECOLOR,
              assetImage: "assets/share.png",
              textColor: ColorConstants.APPPRIMARYWHITECOLOR,
              title: model.share,
              bColor: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.4),
              bWidth: 1.5,
              color: Colors.transparent,
            ).paddingOnly(left: 0, right: 2),
            userLoginModel!.data.userId == model.userId
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      giftingBottomSheet(model.userId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorConstants.APPPRIMARYWHITECOLOR
                                  .withOpacity(0.4),
                              width: 1)),
                      height: 37,
                      width: 60,
                      child: Icon(
                        Ionicons.gift_sharp,
                        size: 14,
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                      ),
                    ),
                  ),

            addPadding(8, 0)
          ],
        ).paddingOnly(bottom: 10));
  }

  reelProfileWidget(VideoDatum model) {
    return GestureDetector(
      onTap: () {
        if (userLoginModel!.data.userId == model.userId) {
          controller.userIdVal.value = model.userId;
          controller.updateBottomIndex(3);
        } else {
          controller.userIdVal.value = model.userId;
          final pCont = Get.find<ProfileController>();
          pCont.onInit1(controller.userIdVal.value);
          pCont.profileVisibilityVal.value = false;
          pCont.mLikedlist.clear();
          pCont.userVideosList.clear();

          Get.to(UserProfileScreen(
            userId: model.userId,
          ));
        }

        //  controller.updateBottomIndex(3);
      },
      child: Row(
        children: [
          addPadding(10, 0),
          ClipOval(
            child: Image.network(
              model.userImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.white, width: 2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 10),
            child: Text(
              model.username,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          addPadding(5, 0),
          model.profileVerified == "0"
              ? SizedBox()
              : const SizedBox(
                  height: 18,
                  width: 18,
                  child: NetworkImageView(
                      imgUrl:
                          "https://cdn-icons-png.flaticon.com/128/9918/9918694.png"),
                ).paddingOnly(top: 3),
          Spacer(),
          GestureDetector(
            onTap: () {
              videoStatusUpdate.add(PAUSE);
              Get.to(UseMyMusicScreen(
                videoLink: model.video,
                soundImage: model.soundImage,
                soundUserName: model.soundUserName,
                tblVideoSoundId: model.tblVideoSoundId,
              ));
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: AssetImageView(
                    fit: BoxFit.cover, img: "assets/useMusicGif.gif"),
              ),
            ).paddingOnly(bottom: 0, right: 10),
          )
        ],
      ),
    ).paddingOnly(bottom: model.tag.trim().isEmpty ? 15 : 15, left: 6);
  }

  hashTagWidget(VideoDatum model, BuildContext context) {
    var tagList = [];
    var split = model.tag.toString().trim().split("   ");
    print("TAHHHHHHGGGG${split.toString().trim()}");
    split.forEach((element) {
      tagList.add(element);
    });
    print("TAGGGLS${tagList.toString()}");

    return Positioned(
      bottom: 60,
      left: 15,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Wrap(
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: tagList
                    .map((e) => SACellRoundContainer1(
                            color: Colors.grey.withOpacity(0.22),
                            child: Text(
                              e,
                              style: textStyleW600(
                                  fontSize: 12,
                                  color: ColorConstants.APPPRIMARYWHITECOLOR),
                            ).paddingAll(8),
                            radius: 6,
                            borderWidth: 0,
                            borderWidthColor: Colors.transparent)
                        .paddingAll(3))
                    .toList(),
              ),
            ).paddingOnly(left: 5),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  addFavoriteWidget(VideoDatum model, BuildContext context) {
    print("LIKEEEEEEEE${model.videoLikes}");
    bool val = model.videoLikes == "no" ? false : true;
    return SizedBox();
  }

  appBarWidget(BuildContext context, SADashboardController controller,
      VideoDatum model) {
    return Obx(() => SafeArea(
          child: Row(
            children: [
              controller.bottomIndex.value == 0
                  ? addPadding(15, 0)
                  : addPadding(15, 0),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  videoStatusUpdate.add(PAUSE);
                  Get.to(const NotificationPage())!.then((value) {
                    controller.callingNotificationAPIs();
                  });
                },
                child: controller.notificationCountVal.value == "0"
                    ? SizedBox(
                        child: Image.asset(
                          "assets/notificationicon.png",
                          height: 24,
                          width: 24,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                        ),
                      )
                    : Badge(
                        label: Text(controller.notificationCountVal.value),
                        child: Image.asset(
                          "assets/notificationicon.png",
                          height: 24,
                          width: 24,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                        ),
                      ),
              ),
              addPadding(7, 0),
              RotatedBox(
                  quarterTurns: 3,
                  child: IconButton(
                      onPressed: () {
                        Get.find<ProfileController>().getUserReportAPIs(
                            "video", model.tblVedioId, model.userId);
                      },
                      icon: Icon(
                        Icons.more_horiz,
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                      )))
            ],
          ).paddingOnly(top: 15),
        ));
  }

  void giftingBottomSheet(String userId) {
    Get.bottomSheet(GiftingScreen(receiverId: userId));
  }

  void commentBottomSheetUI(String string) {
    Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 460,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            children: [
              10.heightBox,
              Row(
                children: [
                  const Spacer(),
                  "${controller.totalComCount.value} Comments"
                      .text
                      .size(15)
                      .black
                      .make(),
                  const Spacer(),
                  SizedBox(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.cancel),
                    ),
                  ),
                ],
              ),
              5.heightBox,
              const Divider(),
              SizedBox(
                height: 300,
                child: FutureBuilder(
                    future: controller.getCommentListAPIs(string, false),
                    builder: (_, snapShot) {
                      if (snapShot.hasData) {
                        List<cDatum> comm = snapShot.data!;
                        return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: comm.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(comm[index].userImage),
                                      ),
                                      title: comm[index]
                                          .username
                                          .text
                                          .semiBold
                                          .color(Colors.black.withOpacity(0.9))
                                          .make(),
                                      subtitle: comm[index]
                                          .comments
                                          .text
                                          .black
                                          .make(),
                                      trailing: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 8),
                                        child: IconButton(
                                          icon: Icon(
                                            comm[index].commentsLike == "no"
                                                ? Icons.favorite_border
                                                : Icons.favorite,
                                            size: 30,
                                            color:
                                                comm[index].commentsLike == "no"
                                                    ? null
                                                    : Colors.red,
                                          ),
                                          onPressed: () {
                                            controller.likeCommentAPIs(
                                                controller.videoId1.toString(),
                                                comm[index]
                                                    .tblVideoCommentsId
                                                    .toString(),
                                                comm[index].commentsLike);
                                          },
                                        ),
                                      )),
                                  Row(
                                    children: [
                                      comm[index].time == ""
                                          ? const Text("")
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 60.0),
                                              child: DateFormat('hh:mm aa')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(comm[index]
                                                              .time)))
                                                  .text
                                                  .make(),
                                            ),
                                      GestureDetector(
                                        onTap: () {
                                          //  cont._focus.requestFocus();
                                          controller.isSelect.value = true;
                                          controller.tblVideoCommentsId.value =
                                              comm[index]
                                                  .tblVideoCommentsId
                                                  .toString();
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "Reply",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: controller.isSelect.value
                                                    ? Colors.blue
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "Report",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                controller.deleteComment(
                                                    comm[index]
                                                        .tblVideoCommentsId);
                                              },
                                              child: userLoginModel!.data.userId
                                                          .toString() ==
                                                      comm[index].userId
                                                  ? const Text("Delete",
                                                      style: TextStyle(
                                                          fontSize: 12))
                                                  : const Text("")),
                                        ),
                                      ),
                                    ],
                                  ),
                                  addPadding(0, 5),
                                  Visibility(
                                    visible:
                                        comm[index].commentsRepyData.isEmpty
                                            ? false
                                            : true,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (comm[index].replyUI) {
                                            comm[index].replyUI = false;
                                          } else {
                                            comm[index].replyUI = true;
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            const Expanded(
                                                flex: 1, child: Divider()),
                                            addPadding(5, 0),
                                            "View Reply"
                                                .text
                                                .size(14)
                                                .color(Colors.blue)
                                                .make(),
                                            addPadding(5, 0),
                                            const Expanded(
                                                flex: 1, child: Divider()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: comm[index].replyUI,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 80.0),
                                        child: ListView.builder(
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: comm[index]
                                                .commentsRepyData
                                                .length,
                                            itemBuilder: (c, i) {
                                              CommentsReplyDatum crDatum =
                                                  comm[index]
                                                      .commentsRepyData
                                                      .elementAt(i);
                                              return Column(
                                                children: [
                                                  ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(crDatum
                                                                .userImage),
                                                      ),
                                                      title: crDatum.username
                                                          .text.semiBold
                                                          .color(Colors.black
                                                              .withOpacity(0.9))
                                                          .make(),
                                                      subtitle: crDatum
                                                          .comments.text.black
                                                          .make(),
                                                      trailing: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15.0,
                                                                right: 8),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            crDatum.commentsLike ==
                                                                    "no"
                                                                ? Icons
                                                                    .favorite_border
                                                                : Icons
                                                                    .favorite,
                                                            size: 30,
                                                            color:
                                                                crDatum.commentsLike ==
                                                                        "no"
                                                                    ? null
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                          onPressed: () {
                                                            controller.likeCommentAPIs(
                                                                controller
                                                                    .videoId1
                                                                    .toString(),
                                                                crDatum
                                                                    .tblCommentsReplyId
                                                                    .toString(),
                                                                crDatum
                                                                    .commentsLike);
                                                          },
                                                        ),
                                                      )),
                                                  Row(
                                                    children: [
                                                      crDatum.time == ""
                                                          ? const Text("")
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          60.0),
                                                              child: DateFormat(
                                                                      'hh:mm aa')
                                                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                                                      int.parse(
                                                                          crDatum
                                                                              .time)))
                                                                  .text
                                                                  .make(),
                                                            ),
                                                      addPadding(40, 0),
                                                      GestureDetector(
                                                          onTap: () {
                                                            print("KKSKSKSK");
                                                            controller
                                                                .deleteComment(
                                                                    crDatum
                                                                        .tblCommentsReplyId);
                                                          },
                                                          child: userLoginModel!
                                                                      .data
                                                                      .userId
                                                                      .toString() ==
                                                                  crDatum.userId
                                                              ? const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black))
                                                              : const Text("")),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else if (snapShot.connectionState ==
                          ConnectionState.waiting) {
                        return const GIFLaaderPage();
                      } else {
                        return Center(
                            child: headingText(title: "No Record Found"));
                      }
                    }),
              ),
              const Spacer(),
              Container(
                color: ColorConstants.APPPRIMARYWHITECOLOR,
                height: 65,
                // color: redColor,
                child: Center(
                  child: TextFormField(
                    focusNode: controller.focus,
                    controller: controller.EditCommentController.value,
                    textAlign: TextAlign.start,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 30, top: 11),
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w500),
                      suffixIconConstraints:
                          BoxConstraints(minHeight: 20, minWidth: 20),
                      hintText: "Say something...",
                      prefixIconConstraints:
                          BoxConstraints(minHeight: 30, maxWidth: 55),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: CircleAvatar(
                          // radius: 20,
                          backgroundImage: NetworkImage(
                            userLoginModel!.data.userImage,
                          ),
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          headingText(
                              title: "GIF",
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          15.widthBox,
                          const Icon(
                            Icons.send_rounded,
                            color: Colors.grey,
                          ).onTap(() {
                            controller.isSelect.value
                                ? controller.replyCommentAPI(controller
                                    .tblVideoCommentsId.value
                                    .toString())
                                : controller.sendCcomment().whenComplete(() {
                                    setState(() {});
                                  });
                          })
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: 10),
        );
      }),
      isScrollControlled: true,
      enableDrag: true,
      // ignoreSafeArea: false,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      isDismissible: false,
      clipBehavior: Clip.antiAlias,
    );
  }

  useMusicUI(VideoDatum model) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () async {
          videoStatusUpdate.add(PAUSE);
          Get.to(UseMyMusicScreen(
            videoLink: model.video,
            soundImage: model.soundImage,
            soundUserName: model.soundUserName,
            tblVideoSoundId: model.tblVideoSoundId,
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.APPPRIMARYBLACKCOLOR.withOpacity(0.30)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.music_video,
                color: ColorConstants.appPrimaryWhiteColor,
              ).paddingOnly(left: 15),
              addPadding(8, 0),
              Text(
                model.soundUserName,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.APPPRIMARYWHITECOLOR),
              )
            ],
          ).paddingAll(4),
        ),
      ),
    ).paddingOnly(left: 10);
  }
}

class GiftingScreen extends StatelessWidget {
  final String receiverId;
  const GiftingScreen({super.key, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetX(
        init: SADashboardController(),
        builder: (controller) {
          return Container(
              decoration: BoxDecoration(
                  color: ColorConstants.APPPRIMARYBLACKCOLOR,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  border: Border.all(
                      width: 1,
                      color: ColorConstants.APPPRIMARYGREYCOLOR
                          .withOpacity(0.20))),
              child: Column(
                children: [
                  controller.giftHeaderIndexVal.value == 0
                      ? const SizedBox()
                      : const SizedBox(),
                  SizedBox(
                    height: 40,
                    child: headingText(
                        title: "Gift",
                        fontSize: 18,
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                        fontWeight: FontWeight.w600),
                  ).paddingOnly(top: 8, bottom: 8),
                  //giftTabsWidget(),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.giftModelList.length ?? 0,
                        itemBuilder: (_, index) {
                          GFTDatum e =
                              controller.giftModelList.elementAt(index);
                          if (controller.giftHeaderIndexVal.value == index) {
                            e.isSelected = true;
                          } else {
                            e.isSelected = false;
                          }
                          return GestureDetector(
                            onTap: () {
                              controller.giftHeaderIndexVal.value = index;
                              controller.giftModelList.refresh();
                            },
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  headingText(
                                          title: e.name,
                                          color: ColorConstants
                                              .APPPRIMARYWHITECOLOR)
                                      .paddingAll(2),
                                  Container(
                                      width: 60,
                                      height: 2,
                                      decoration: BoxDecoration(
                                          color: e.isSelected
                                              ? ColorConstants
                                                  .APPPRIMARYWHITECOLOR
                                              : ColorConstants
                                                  .APPPRIMARYGREYCOLOR
                                                  .withOpacity(0.02),
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                ],
                              ).paddingOnly(left: 0, top: 8, bottom: 3),
                            ),
                          );
                        }),
                  ),

                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 12, top: 10),
                      child: GridView.builder(
                          padding: const EdgeInsets.only(bottom: 15),
                          itemCount: controller
                                  .giftModelList[
                                      controller.giftHeaderIndexVal.value]
                                  .giftList
                                  .length ??
                              0,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, mainAxisExtent: 125),
                          itemBuilder: (_, inx) {
                            GiftList gift = controller
                                .giftModelList.first.giftList
                                .elementAt(inx);
                            if (controller.giftIndexVal.value == inx) {
                              gift.isGiftSelected = true;
                              controller.giftIdVal.value = gift.tblGiftId;
                              controller.giftAmtVal.value = gift.token;
                            } else {
                              gift.isGiftSelected = false;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  controller.giftIdVal.value = gift.tblGiftId;
                                  controller.giftAmtVal.value = gift.token;
                                  controller.giftIndexVal.value = inx;
                                  controller.giftModelList.refresh();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants
                                            .APPPRIMARYGREYCOLOR
                                            .withOpacity(0.06),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            width: gift.isGiftSelected ? 1 : 0,
                                            color: gift.isGiftSelected
                                                ? Colors.deepPurple
                                                : Colors.transparent)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 65,
                                            child: NetworkImageView(
                                              imgUrl: gift.image,
                                            )),
                                        addPadding(0, 5),
                                        headingText(
                                            title: gift.name,
                                            fontSize: 15,
                                            color: ColorConstants
                                                .APPPRIMARYWHITECOLOR),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.diamond,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            addPadding(3, 0),
                                            headingText(
                                                title: gift.token.toString(),
                                                fontSize: 10,
                                                color: ColorConstants
                                                    .APPPRIMARYGREYCOLOR),
                                          ],
                                        ).paddingOnly(top: 2)
                                      ],
                                    )),
                              ),
                            );
                          }),
                    ),
                  ),
                  GradientButton1(
                    text: 'Send Gift',
                    onPressed: () {
                      var hashMap = {
                        "sender_id": userLoginModel!.data.userId.toString(),
                        "receiver_id": receiverId,
                        "tbl_gift_id": controller.giftIdVal.value,
                        "tokens": controller.giftAmtVal.value
                      };
                      print("RRRRR${hashMap}");
                      sendGiftsAPI(hashMap).then((value) {
                        if (value.status) {
                          Get.back();
                          toastMessage(value.message);
                        } else {
                          toastMessage(value.message);
                        }
                      });
                    },
                  ).paddingAll(8)
                ],
              ));
        });
  }
}

class SALabelButton extends StatelessWidget {
  final String title, assetImage;
  final double bWidth;
  Color color = Color(0xfff7fce2);
  Color textColor = Color(0xfff7fce2);
  Color bColor = Colors.transparent;
  Color imgColor = Colors.transparent;
  Function() onTap;

  SALabelButton(
      {super.key,
      required this.title,
      required this.color,
      required this.bWidth,
      required this.bColor,
      required this.textColor,
      required this.assetImage,
      required this.imgColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: SACellRoundContainer1(
              height: 37,
              color: color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  addPadding(5, 0),
                  Image.asset(
                    assetImage,
                    height: 17,
                    width: 17,
                    color: imgColor,
                  ),
                  addPadding(7, 0),
                  Text(
                    title,
                    style: textStyleW600(color: textColor, fontSize: 12),
                  ),
                  addPadding(0, 10)
                ],
              ).paddingOnly(left: 10, right: 10),
              radius: 10,
              borderWidth: bWidth,
              borderWidthColor: bColor)
          .paddingOnly(left: 0),
    );
  }
}

class AllCommentsPage extends StatefulWidget {
  final String tblVideoId;
  const AllCommentsPage({super.key, required this.tblVideoId});

  @override
  State<AllCommentsPage> createState() => _AllCommentsPageState();
}

class _AllCommentsPageState extends State<AllCommentsPage> {
  var editCommentController = TextEditingController();
  String iVideoId = "", tblVideoCommentsId = "", totalComments = "0";
  StreamController<List<cDatum>> streamController = StreamController();
  var isReplySelected = false, ignoreTappingVal = false;
  int sIndex = 6546;

  Stream<List<cDatum>> get dataStream => streamController.stream;
  FocusNode focus = FocusNode();
  @override
  void initState() {
    super.initState();
    getCommentListAPIs(widget.tblVideoId, false);
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(result: totalComments);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        body: SafeArea(
          child: Column(
            children: [
              10.heightBox,
              headingNoOfCommentsWidget(),
              5.heightBox,
              const Divider(),
              Expanded(child: allCommentWidget()),
              writeUrCommentWidget(),
            ],
          ).paddingOnly(top: 10),
        ),
      ),
    );
  }

  headingNoOfCommentsWidget() {
    return Row(
      children: [
        Text(
          "Comment",
          style: textStyleW600(
              fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR),
        ),
        addPadding(4, 0),
        SACellNSRoundContainer(
            height: 25,
            width: 25,
            color: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15),
            child: Center(
              child: Text(
                totalComments,
                style: textStyleW600(
                    fontSize: 13, color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
            ),
            radius: 50,
            borderWidth: 0,
            borderWidthColor: ColorConstants.APPPRIMARYBLACKCOLOR),
        const Spacer(),
        SizedBox(
          child: IconButton(
            onPressed: () {
              Get.back(result: totalComments);
            },
            icon: Icon(
              Icons.cancel,
              color: ColorConstants.APPPRIMARYWHITECOLOR,
            ),
          ),
        ),
      ],
    ).paddingOnly(left: 15);
  }

  allCommentWidget() {
    return StreamBuilder(
        stream: streamController.stream,
        builder: (_, AsyncSnapshot snapShot) {
          print("DDAATAA${snapShot.data.toString()}");
          if (snapShot.hasData) {
            List<cDatum> comm = snapShot.data!;
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: comm.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (sIndex == index) {
                    comm[index].isReplySelected = true;
                  } else {
                    comm[index].isReplySelected = false;
                  }
                  return Column(
                    children: [
                      ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(comm[index].userImage),
                          ),
                          title: Text(
                            comm[index].username,
                            style: textStyleW600(
                                fontSize: 15,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                          ),
                          subtitle: Text(
                            comm[index].comments,
                            style: textStyleW500(
                                fontSize: 13,
                                color: ColorConstants.APPPRIMARYWHITECOLOR
                                    .withOpacity(0.70)),
                          ).paddingOnly(top: 5),
                          trailing: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 8),
                            child: IconButton(
                              icon: Icon(
                                comm[index].commentsLike == "no"
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                size: 20,
                                color: comm[index].commentsLike == "no"
                                    ? ColorConstants.APPPRIMARYGREYCOLOR
                                        .withOpacity(0.50)
                                    : Colors.red,
                              ),
                              onPressed: () {
                                likeCommentAPIs(
                                    comm[index].tblVideoCommentsId.toString(),
                                    comm[index].commentsLike);
                              },
                            ),
                          )),
                      Row(
                        children: [
                          /* comm[index].time == ""
                              ? const Text("")
                              : Padding(
                                  padding: const EdgeInsets.only(left: 60.0),
                                  child: Text(
                                    DateFormat('hh:mm aa').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(comm[index].time))),
                                    style: textStyleW500(
                                        fontSize: 12,
                                        color:
                                            ColorConstants.APPPRIMARYGREYCOLOR),
                                  ),
                                ),*/
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sIndex = index;
                                focus.requestFocus();
                                isReplySelected = true;
                                tblVideoCommentsId =
                                    comm[index].tblVideoCommentsId.toString();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 60.0),
                              child: Text(
                                "Reply",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: comm[index].isReplySelected
                                        ? Colors.blue
                                        : ColorConstants.APPPRIMARYWHITECOLOR),
                              ),
                            ),
                          ),
                          comm[index].userId == userLoginModel!.data.userId
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    print("REEEEPORRTTT");
                                    reportInCommentAPIs({
                                      "tbl_video_comments_id":
                                          comm[index].tblVideoCommentsId,
                                      "reported_user_id": comm[index].userId,
                                      "reported_by_user_id":
                                          userLoginModel!.data.userId
                                    }).then((value) {
                                      if (value.status) {
                                        toastMessage(value.message);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Report",
                                      style: textStyleW500(
                                          fontSize: 12,
                                          color: ColorConstants
                                              .appPrimaryWhiteColor),
                                    ),
                                  ),
                                ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    deleteComment(
                                        comm[index].tblVideoCommentsId);
                                  },
                                  child:
                                      userLoginModel!.data.userId.toString() ==
                                              comm[index].userId
                                          ? const Text("Delete",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorConstants
                                                      .appPrimaryWhiteColor))
                                          : const Text("")),
                            ),
                          ),
                        ],
                      ),
                      addPadding(0, 5),
                      Visibility(
                        visible:
                            comm[index].commentsRepyData.isEmpty ? false : true,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (comm[index].replyUI) {
                                comm[index].replyUI = false;
                              } else {
                                comm[index].replyUI = true;
                              }
                            });
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Divider(
                                      height: 1,
                                      color: ColorConstants.APPPRIMARYGREYCOLOR
                                          .withOpacity(0.20),
                                    )),
                                addPadding(5, 0),
                                Text(
                                  "View Reply",
                                  style: textStyleW500(
                                      fontSize: 13,
                                      color:
                                          ColorConstants.APPPRIMARYWHITECOLOR),
                                ),
                                addPadding(5, 0),
                                Expanded(
                                    flex: 1,
                                    child: Divider(
                                      height: 1,
                                      color: ColorConstants.APPPRIMARYGREYCOLOR
                                          .withOpacity(0.20),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: comm[index].replyUI,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 15),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: comm[index].commentsRepyData.length,
                                itemBuilder: (c, i) {
                                  CommentsReplyDatum crDatum =
                                      comm[index].commentsRepyData.elementAt(i);
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(crDatum.userImage),
                                    ),
                                    title: Text(
                                      crDatum.username,
                                      style: textStyleW600(
                                          fontSize: 15,
                                          color: ColorConstants
                                              .APPPRIMARYWHITECOLOR),
                                    ),
                                    subtitle: Text(
                                      crDatum.comments,
                                      style: textStyleW500(
                                          fontSize: 13,
                                          color: ColorConstants
                                              .APPPRIMARYWHITECOLOR
                                              .withOpacity(0.70)),
                                    ),
                                    /* trailing: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 8),
                                        child: IconButton(
                                          icon: Icon(
                                            crDatum.commentsLike == "no"
                                                ? Icons.favorite_border
                                                : Icons.favorite,
                                            size: 20,
                                            color:
                                                crDatum.commentsLike == "no"
                                                    ? ColorConstants
                                                        .APPPRIMARYGREYCOLOR
                                                        .withOpacity(0.50)
                                                    : Colors.red,
                                          ),
                                          onPressed: () {
                                            likeCommentAPIs(
                                                crDatum.tblCommentsReplyId
                                                    .toString(),
                                                crDatum.commentsLike);
                                          },
                                        ),
                                      )*/
                                  );
                                }),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else if (snapShot.connectionState == ConnectionState.waiting) {
            return const GIFLaaderPage();
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mode_comment_outlined,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  size: 40,
                ),
                addPadding(0, 20),
                headingText(
                    title: "No Comment Found",
                    color: ColorConstants.APPPRIMARYWHITECOLOR),
              ],
            ));
          }
        });
  }

  writeUrCommentWidget() {
    return Center(
      child: TextFormField(
        focusNode: focus,
        style: textStyleW500(color: ColorConstants.APPPRIMARYWHITECOLOR),
        controller: editCommentController,
        textAlign: TextAlign.start,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 30, top: 11),
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w500),
          suffixIconConstraints: BoxConstraints(minHeight: 20, minWidth: 20),
          hintText: "Say something...",
          prefixIconConstraints: BoxConstraints(minHeight: 30, maxWidth: 55),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: CircleAvatar(
              // radius: 20,
              backgroundImage: NetworkImage(
                  Get.find<SADashboardController>().myProfileLinkVal.value),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              /* headingText(
                  title: "GIF",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.APPPRIMARYWHITECOLOR),
              15.widthBox,*/
              IgnorePointer(
                ignoring: ignoreTappingVal,
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.grey,
                ).onTap(() {
                  setState(() {
                    ignoreTappingVal = true;
                  });
                  isReplySelected
                      ? replyCommentAPI(tblVideoCommentsId.toString())
                          .whenComplete(() {
                          delay(
                              duration: 800,
                              onTap: () {
                                ignoreTappingVal = false;
                                setState(() {});
                              });
                        })
                      : sendComment().whenComplete(() {
                          delay(
                              duration: 800,
                              onTap: () {
                                ignoreTappingVal = false;
                                setState(() {});
                              });
                        });
                }),
              )
            ]),
          ),
        ),
      ).paddingOnly(bottom: 10),
    );
  }

  getCommentListAPIs(String videoID, bool isOpening) async {
    print("HASHMAPPP");
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "tbl_vedio_id": videoID,
    };
    print("HASHMAPPP${hashMap}");
    APIResponse res = await getVideoComment_List(hashMap);
    if (res.status) {
      ViewcommentModel m = res.data;
      setState(() {
        sIndex = 6655;
        totalComments = m.data.length.toString();
      });
      streamController.add(m.data);
    } else {
      streamController.addError(res.message);
    }

    //  totalComCount.value = m.data.length;
  }

  // Stream<List<cDatum>> getStreamComment(String videoId) {
  //   return Stream.fromFuture(getCommentListAPIs(videoId, false));
  // }

  Future sendComment() async {
    if (editCommentController.text.trim().isEmpty) {
      return toastMessage("Please enter comment");
    }
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "video_id": widget.tblVideoId,
      "comments": editCommentController.value.text.trim().toString(),
      "time": DateTime.now().microsecondsSinceEpoch.toString(),
    };
    print("cgeckkkparam${hashMap.toString()}");
    addComment(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        editCommentController.clear();
        getCommentListAPIs(widget.tblVideoId, true);
      }
    });
  }

  void deleteComment(String tblVideoCommentsId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "tbl_video_comments_id": tblVideoCommentsId,
      "comments_type": "Normal",
    };
    print("bfhdbfhdbfbdbfd${hashMap.toString()}");
    deletecomment_List(hashMap).then((value) {
      if (value.status) {
        Get.back();
        toastMessage(value.message);
        getCommentListAPIs(widget.tblVideoId, false);
      }
    });
  }

  void likeCommentAPIs(String tblVideoCommentiId, String isLike) {
    Map<String, String> params = {
      "user_id": userLoginModel!.data.userId.toString(),
      "video_id": widget.tblVideoId,
      "comment_id": tblVideoCommentiId,
      "like": isLike == "no" ? "like" : "unlike",
    };
    print("LIKEEECOMMENTTT$params");
    likeCommmentAPI(params).then((value) {
      if (value.status) {
        //toastMessage(value.message.toString());
        getCommentListAPIs(widget.tblVideoId, false);
      } else {
        toastMessage(value.message.toString());
      }
    });
  }

  Future<void> replyCommentAPI(String value) async {
    if (editCommentController.text.trim().isEmpty) {
      return toastMessage("Please enter comment");
    }
    var hashMap = {
      "user_id": userLoginModel!.data.userId.toString(),
      "video_id": widget.tblVideoId.toString(),
      "comments": editCommentController.value.text.trim().toString(),
      "comment_id": value.toString(),
      "time": DateTime.now().microsecondsSinceEpoch.toString(),
    };
    print("REPLYCOMMANTHASH${hashMap}");
    commentReply(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        editCommentController.clear();
        getCommentListAPIs(widget.tblVideoId, false);
        //getCommentListAPIs(videoId1.value, false);
      }
    });
  }
}
