import 'dart:io';

import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/ARGear/views/ar_gear_view.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/NotificationService.dart';
import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/app/modules/SADashboard/views/AR.dart';
import 'package:champcash/app/modules/SADashboard/views/DeeparScreeen.dart';
import 'package:champcash/app/modules/SADashboard/views/reelCreateScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_chat_view.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_hashtags.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_home_view.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_profile_view.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/extras.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../tab/ProfileView.dart';
import '../controllers/s_a_dashboard_controller.dart';

class SADashboardView extends GetView<SADashboardController> {
  SADashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Obx(() => Stack(
              children: [
                IndexedStack(
                  index: controller.bottomIndex.value,
                  children: [
                    const SAHomeView(),
                    SAHashTagView(),
                    // const ArGearView(),
                    const SAChatView(),
                    const SAProfileView()
                  ],
                ),
                controller.appController.progressVIUploadingVal.value
                    ? SafeArea(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                            minHeight: 4,
                            color: ColorConstants.appPrimaryColor,
                            backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR
                                .withOpacity(0.66),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            )),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: ColorConstants.APPPRIMARYWHITECOLOR,
          onPressed: () {
            controller.appController.isForcePauseVal.value = true;
            videoStatusUpdate.add(PAUSE);
            Get.to(const ARCameraRecordingScreen(
              videoLink: "",
              tblVideoSoundId: "",
            ));
          },
          child: const Icon(
            Icons.add_outlined,
            color: ColorConstants.APPPRIMARYBLACKCOLOR,
          ),
        ).paddingOnly(top: 58),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: makeBottomNavigationWidget(),
      ),
    );
  }

  _backPressed(BuildContext context) async {
    if (controller.bottomIndex.value == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xffffffff),
            title: headingText(
                title: "Exit?", color: Colors.black, fontSize: 15.0),
            content: headingText(
                title: "Are you sure you want to exit?",
                color: Colors.black,
                fontSize: 15.0),
            actions: <Widget>[
              TextButton(
                child: headingText(
                    title: "CANCEL", color: Colors.red, fontSize: 14.5),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              TextButton(
                child:
                    headingText(title: "OK", color: Colors.red, fontSize: 14.5),
                onPressed: () {
                  exit(0);
                },
              ),
              // usually buttons at the bottom of the dialog
            ],
          );
        },
      );
    } else if (controller.isOpenTagScreen.value) {
      controller.bottomIndex.value = 1;
      controller.isOpenTagScreen.value = false;
    } else {
      controller.bottomIndex.value = 0;
    }
  }

  makeBottomNavigationWidget() {
    return Obx(() => BottomAppBar(
          // shape: const CircularNotchedRectangle(),
          notchMargin: 0.0,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.only(top: 12.0),
            height: 55,
            decoration: const BoxDecoration(
              color: ColorConstants.APPPRIMARYBLACKCOLOR,
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(15), topRight: Radius.circular(15))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bottomNavigationBarItem(
                    image: "assets/iconshome.png", type: 'Home', index: 0),
                bottomNavigationBarItem(
                  image: "assets/iconSearch.png",
                  type: "HashTag",
                  index: 1,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                bottomNavigationBarItem(
                    image: "assets/iconschat.png", type: "Chat", index: 2),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      controller.appController.isForcePauseVal.value = true;
                      controller.userIdVal.value =
                          userLoginModel!.data.userId.toString();
                      controller.updateBottomIndex(3);
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            border: Border.all(
                                width: 1.5,
                                color: controller.bottomIndex.value == 3
                                    ? ColorConstants.appPrimaryColor
                                        .withOpacity(0.80)
                                    : Colors.grey)),
                        child: ClipOval(
                          child: NetworkImageView(
                            fit: BoxFit.cover,
                            imgUrl: controller.profileUrl.value,
                          ),
                        ),
                      ),
                    ),
                  ).paddingOnly(bottom: 10, right: 15, left: 15),
                ),
              ],
            ),
          ),
        ));
  }

  bottomNavigationBarItem(
      {required String image, required String type, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (type == "Home") {
            controller.updateBottomIndex(0);
          } else if (type == "HashTag") {
            controller.appController.isForcePauseVal.value = true;
            controller.updateBottomIndex(1);
          } else if (type == "Chat") {
            controller.appController.isForcePauseVal.value = true;
            controller.updateBottomIndex(2);
          }
        },
        onDoubleTap: () {
          if (type == "Home") {
            controller.videoList.clear();
            controller.videoList.refresh();
            controller.getVideoList(1);
          }
        },
        child: SizedBox(
          child: Image.asset(
            image,
            height: 24,
            color: controller.bottomIndex.value == index
                ? Colors.white
                : Colors.white60,
          ),
        ),
      ).paddingOnly(bottom: 10),
    );
  }
}
