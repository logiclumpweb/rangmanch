import 'dart:io';

import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/fr_constants.dart';
import 'package:champcash/app/modules/SADashboard/controllers/UserVideoViewController.dart';
import 'package:champcash/app/modules/SADashboard/views/UserProfileScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_home_view.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/sa_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import '../Data/global_constant.dart';
import '../Routes/AppRoutes.dart';
import '../models/UserLikedVideoListModel.dart';
import '../models/UserUplodedVideoListModel.dart';
import '../shared/add_favorite.dart';
import '../shared/extras.dart';
import '../shared/label_button.dart';
import 'myVideoPlayer.dart';

class UserVideoPlayerView extends StatefulWidget {
  final String thumbnail, videoUrl, type;
  final int index;
  final List<getVideoDatum> userVideoList;
  final List<likeVideoDatum> likeVideoList;
  const UserVideoPlayerView(
      {Key? key,
      required this.thumbnail,
      required this.videoUrl,
      required this.type,
      required this.userVideoList,
      required this.likeVideoList,
      required this.index})
      : super(key: key);

  @override
  State<UserVideoPlayerView> createState() => _UserVideoPlayerViewState();
}

class _UserVideoPlayerViewState extends State<UserVideoPlayerView> {
  bool ignoreTappingVal = false, ignoreTappingVal1 = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(result: widget.likeVideoList.isNotEmpty ? "P" : "U");
        return Future.value(true);
      },
      child: Scaffold(
          body: Stack(
        children: [
          PageView.builder(
            controller: PageController(
                initialPage: widget.index, keepPage: true, viewportFraction: 1),
            allowImplicitScrolling: true,
            onPageChanged: (page) {
              Logger().d('Page-----------$page');
              videoStatusUpdate.add(page);
              FirebaseFirestore.instance
                  .collection(FireBaseConstants.pathUserFollowCollection)
                  .doc(userLoginModel!.data.userId.toString())
                  .collection(FireBaseConstants.allFollowing)
                  .doc(widget.userVideoList[page].userId)
                  .snapshots()
                  .listen((event) {
                print("STTTATTSTS${event.get(FireBaseConstants.isFollow)}");

                setState(() {
                  widget.userVideoList[page].followStatus =
                      event.get(FireBaseConstants.isFollow);
                });
              });
            },
            itemBuilder: (context, index) {
              var m;
              if (widget.type == "User") {
                getVideoDatum model = widget.userVideoList.elementAt(index);
                m = model;
              } else {
                likeVideoDatum model = widget.likeVideoList.elementAt(index);
                m = model;
              }

              return _buildVideoListItem(m, index);
            },
            itemCount: widget.type == "User"
                ? widget.userVideoList.length
                : widget.likeVideoList.length,
            scrollDirection: Axis.vertical,
          ),
        ],
      )),
    );
  }

  Future<void> likeApi(bool val, model) async {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": model.tblVedioId.toString(),
      "like": val == true ? "like" : "unlike",
    };
    print("LIKKKKKE${hashMap}");
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
        setState(() {});
        /*model.videoLikes = "yes";
        int like = int.parse(model.likes);
        like++;*/
      }
      //   Get.back();
    });
  }

  Widget _buildVideoListItem(model, int index) {
    bool val = model.videoLikes == "no" ? false : true;
    return Stack(
      children: [
        SAVideoPlayerNew(
          url: model.video,
          index: index,
          videoThumb: model.videoThumb,
        ),
        Positioned(
            left: 8,
            right: 8,
            bottom: 60,
            child: GestureDetector(
              onTap: () {
                if (userLoginModel!.data.userId.toString() !=
                    model.userId.toString()) {
                  Get.to(UserProfileScreen(
                    userId: model.userId,
                  ));
                }
              } /* => controller.bottomIndex.value=2*/,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
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
                  ).paddingOnly(left: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 5),
                        child: Text(
                          model.username,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  model.profileVerified == "0"
                      ? SizedBox()
                      : const SizedBox(
                          height: 18,
                          width: 18,
                          child: NetworkImageView(
                              imgUrl:
                                  "https://cdn-icons-png.flaticon.com/128/9918/9918694.png"),
                        ).paddingOnly(top: 3)
                ],
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              /* userLoginModel!.data.userId == model.userId
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                       Get.back();
                        */
              /*EasyLoading.show(status: "Loading");
                    userFollowAPI({
                      "user_id": userLoginModel!.data.userId.toString(),
                      "follwoing_user_id": model.userId.toString()
                    }).then((value) {
                      if (value.status) {
                        toastMessage(value.message.capitalizeFirst!);
                        model.follow =
                            value.message == "User Follow Successfully."
                                ? "yes"
                                : "no";

                        setState(() {
                          EasyLoading.dismiss();
                        });
                        //checkFollowingUserAPIs();
                      }
                    });*/
              /*
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
                              model.follow == "no" ? "Follow" : "Following",
                              style: textStyleW600(
                                  color: ColorConstants.appPrimaryColor,
                                  fontSize: 12)),
                        ),
                      ),
                    ).paddingOnly(left: 15),*/
              userLoginModel!.data.userId == model.userId
                  ? addPadding(20, 0)
                  : addPadding(0, 0),
              IgnorePointer(
                ignoring: ignoreTappingVal,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      ignoreTappingVal = true;
                    });
                    bool val = model.videoLikes == "no" ? true : false;
                    likeApi(val, model).whenComplete(() {
                      delay(
                          duration: 800,
                          onTap: () {
                            ignoreTappingVal = false;
                            setState(() {});
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
              ).paddingOnly(left: 15, right: 5),
              SALabelButton(
                onTap: () {
                  Get.to(AllCommentsPage(
                          tblVideoId: model.tblVedioId.toString()))!
                      .then((value) {
                    setState(() {});
                  });
                },
                assetImage: "assets/chat.png",
                textColor: ColorConstants.APPPRIMARYWHITECOLOR,
                bColor: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.4),
                bWidth: 1.5,
                imgColor: ColorConstants.APPPRIMARYWHITECOLOR,
                title: model.comments,
                color: Colors.transparent,
              ).paddingOnly(left: 5, right: 5),
              SALabelButton(
                onTap: () {
                  Share.share(model.video);
                  // setState(() {
                  //   ignoreTappingVal1 = true;
                  // });
                  // downloadVideo(context, model.video, model.videoName,
                  //         model.tblVedioId)
                  //     .whenComplete(() {
                  //   delay(
                  //       duration: 800,
                  //       onTap: () {
                  //         ignoreTappingVal1 = false;
                  //         setState(() {});
                  //       });
                  // });
                },
                imgColor: ColorConstants.APPPRIMARYWHITECOLOR,
                assetImage: "assets/share.png",
                textColor: ColorConstants.APPPRIMARYWHITECOLOR,
                title: model.share,
                bColor: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.4),
                bWidth: 1.5,
                color: Colors.transparent,
              ),
              addPadding(10, 0)
            ],
          ).paddingOnly(bottom: 10),
        )
      ],
    );
  }

  Future<void> downloadVideo(BuildContext context, String video,
      String videoName, String tblVedioId) async {
    EasyLoading.show(status: "Loading");
    Dio dio = Dio();
    //if (await Permission.manageExternalStorage.request().isGranted) {
    Directory directory = Directory('/storage/emulated/0/Download/');
    // final directory = await getExternalStorageDirectory();
    // final downloadPath=(await getExternalStorageDirectory());
    var filePath = "${directory!.path}$videoName.mp4";
    await dio.download(video, filePath).then((value) {
      dio.close();
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: headingFullText(
            title: "Downloading Complete File Save In Phone Storage ",
            fontWeight: FontWeight.w300),
        backgroundColor: ColorConstants.APPPRIMARYGREENCOLOR,
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: "Share",
          textColor: ColorConstants.APPPRIMARYWHITECOLOR,
          onPressed: () {
            print("FILLEELELEL$filePath");
            Share.shareFiles([filePath],
                    subject: 'Hi Install this app and earn guaranteed rewards',
                    text:
                        "Enjoy and entertaining viral short videos on Rangmanch Download from Google playstore. https://play.google.com/store/apps/details?id=com.app.rangmanch")
                .then((value) {
              shareVCount(tblVedioId);
            });
            //    FlutterDownloader.open(taskId: filePath);
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
}
