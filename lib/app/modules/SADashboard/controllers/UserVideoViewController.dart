import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Apis/api.dart';
import '../../../../Apis/api/api_imp.dart';
import '../../../../Apis/api/base_api.dart';
import '../../../../Data/UserData.dart';
import '../../../../models/ReelVideoListModel.dart';
import '../../../../models/UserUplodedVideoListModel.dart';
import '../../../../models/issueListModel.dart';
import '../../../../shared/extras.dart';

class UserVideoViewController extends GetxController {
  final homePageController = PageController();
  final videoList = RxList<getVideoDatum>();
  final pageNumber = 1.obs;
  final pageLoading = false.obs;
  IssueListModel? mlist;
  final bottomIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getVideoList(pageNumber.value);
    homePageController.addListener(() {
      if (homePageController.position.pixels ==
          homePageController.position.maxScrollExtent) {
        pageNumber.value += 1;
        getVideoList(pageNumber.value);
      }
    });
    /*  bottomIndex.listen((page) {
       if(page!=0)videoStatusUpdate.add(PAUSE);
     });*/
  }

  void getVideoList(int value) {
    pageLoading.value = true;
    var hashMap = {
      "user_id": userLoginModel?.data.userId,
    };
    print(hashMap);
    userUploadedVideoApi(hashMap).then((value) {
      if (value.status) {
        if (pageNumber.value == 1) {
          UserUplodedVideoListModel mModel = value.data;
          videoList.value = mModel.data;
        } else {
          UserUplodedVideoListModel mModel = value.data;
          videoList.addAll(mModel.data);
        }
      }
    });
  }

  void getIssuesList(BuildContext context, getVideoDatum Model) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "type": "video",
    };
    print(hashMap);
    getIssueListApi(hashMap).then((value) {
      if (value.status) {
        IssueListModel model = value.data;
        mlist = model;
        openIIssueDilough(context, mlist, Model);
        print(value.message);
      }
    });
  }

  void openIIssueDilough(
      BuildContext context, IssueListModel? mlist, getVideoDatum Model) {
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
                            icon: Icon(
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
                                          reportvideo(
                                              mlist.data[index].videoIssueListId
                                                  .toString(),
                                              Model);
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
                                    Divider(
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

  void reportvideo(String issueId, getVideoDatum Model) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": Model.tblVedioId.toString(),
      "video_user_id": Model.userId.toString(),
      "issue_list_id": issueId.toString(),
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
}
