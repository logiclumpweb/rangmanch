import 'dart:async';
import 'dart:io';

import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/View/myVideoPlayer.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/app/modules/SADashboard/views/UserProfileScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_home_view.dart';
import 'package:champcash/models/tag_wise_videlList_model.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/add_favorite.dart';
import 'package:champcash/shared/extras.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import '../../../../models/UserUplodedVideoListModel.dart';
import '../../../../shared/label_button.dart';

class SAHashTagVideoPlayerView extends StatefulWidget {
  final int index;
  final List<tVideoDatum> hashTagList;
  const SAHashTagVideoPlayerView(
      {Key? key, required this.index, required this.hashTagList})
      : super(key: key);

  @override
  State<SAHashTagVideoPlayerView> createState() =>
      _SAHashTagVideoPlayerViewState();
}

class _SAHashTagVideoPlayerViewState extends State<SAHashTagVideoPlayerView> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      controller: PageController(
          initialPage: widget.index, keepPage: true, viewportFraction: 1),
      allowImplicitScrolling: true,
      onPageChanged: (page) {
        Logger().d('Page-----------$page');
        videoStatusUpdate.add(page);
      },
      itemBuilder: (context, index) {
        tVideoDatum model = widget.hashTagList.elementAt(index);
        bool val = model.videoLikes == "no" ? false : true;
        return Stack(
          children: [
            SizedBox(
                height: double.infinity,
                child: myVideoPlayer(
                  url: model.video,
                  index: index,
                  videoThumb: model.videoThumb,
                )),
            Positioned(
                left: 8,
                right: 8,
                bottom: 60,
                child: GestureDetector(
                  onTap: () {
                    final pCont = Get.find<ProfileController>();
                    pCont.onInit1(model.userId);
                    pCont.profileVisibilityVal.value = false;
                    pCont.mLikedlist.clear();
                    pCont.userVideosList.clear();

                    Get.to(UserProfileScreen(
                      userId: model.userId,
                    ));
                  } /* => controller.bottomIndex.value=2*/,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              model.userImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 5),
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
                    ],
                  ),
                )),
          ],
        );
      },
      itemCount: widget.hashTagList.length,
      scrollDirection: Axis.vertical,
    ));
  }

  Future<void> downloadVideo(BuildContext context, String video,
      String videoName, String tblVedioId) async {
    EasyLoading.show(status: "Loading");
    Dio dio = Dio();
    if (await Permission.manageExternalStorage.request().isGranted) {
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
                      subject:
                          'Hi Install this app and earn guaranteed rewards',
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
    }
  }

  void shareVCount(String tblVedioId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": tblVedioId.toString(),
    };
    print(hashMap);
    shareCountVideo(hashMap).then((value) {});
  }

  void likeApi(bool val, model) {
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
}
