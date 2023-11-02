import 'package:champcash/tab/MyProfileView.dart';
import 'package:champcash/Apis/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Apis/api.dart';
import '../Data/UserData.dart';
import '../View/myVideoPlayer.dart';
import '../View/UsersAndLikesVideosScreen.dart';
import '../shared/extras.dart';
import '../models/GetProfileDataModel.dart';
import '../models/UserLikedVideoListModel.dart';
import '../models/UserUplodedVideoListModel.dart';
import '../shared/sa_video_player.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int page = 0;
  PageController _controller = PageController();
  List<getVideoDatum> mlist = <getVideoDatum>[];
  List<likeVideoDatum> mLikedlist = <likeVideoDatum>[];
  int ratingValue = 5, pageIndex = 0;
  String lastID = "";
  bool isMoreLoading = false;

  @override
  void initState() {
    super.initState();
    print("ASDFFFFF");
    getUserVideosData("");
    getUserLikedVideosData("");
    getProfileDetailAPIs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xf2f2f2f2),
      body: Column(
        children: [
          Container(
            height: 180,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 140,
                      color: Color(0xffFE9B0E),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            Spacer(),
                            Image.asset(
                              "assets/notificationicon.png",
                              width: 25,
                            ),
                            GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                showPopUpMenu(details.globalPosition, context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/menuicon.png",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 20),
                      child: Container(
                          height: 135,
                          width: 115,
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(2, 2),
                                )
                              ]),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: userProfileModel == null
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        fit: BoxFit.fill,
                                        image: userProfileModel!.data.userImage,
                                      ),
                              ))),
                    ),
                    Spacer(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(MyProfileView());
                            },
                            child: Image.asset(
                              "assets/menuprofile.png",
                              width: 25,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: GestureDetector(
                  child: _createItem(pageIndex == 0, 'My Videos'),
                  onTap: () {
                    pageIndex = 0;
                    _controller.jumpToPage(pageIndex);
                  },
                )),
                Expanded(
                    child: GestureDetector(
                  child: _createItem(pageIndex == 1, 'Liked Videos'),
                  onTap: () {
                    pageIndex = 1;
                    _controller.jumpToPage(pageIndex);
                  },
                )),
              ],
            ),
          ),
          Expanded(
              child: PageView.builder(
            controller: _controller,
            allowImplicitScrolling: false,
            //  physics: NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                pageIndex = page;
              });
            },
            itemBuilder: (context, index) {
              return pageIndex == 0
                  ? userVideoPage()
                  : userLikedVideoPage(context);
            },
            itemCount: 2,
          ))
        ],
      ),
    ));
  }

  Widget _createItem(bool selected, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: selected ? Color(0xffFFA513) : Colors.white,
                  width: 2))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(
          child: headingText(
              title: title,
              color: ColorConstants.APPPRIMARYBLACKCOLOR,
              fontWeight: FontWeight.w600,
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
                  color: selected ? const Color(0xff8BCF52) : Color(0xffEFEFEF),
                  width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, bottom: 10, top: 10),
          child: headingText(
              title: title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: selected ? Color(0xff8BCF52) : Color(0xff3E57B4)),
        ));
  }

  Future<void> showPopUpMenu(
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
              children: [
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
              children: [
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
      print(value);
      if (value == 1) {
        //do your task here for menu 1
      }
      if (value == 2) {
        blockBottomSheetView();
        //do your task here for menu 2
      }
    });
  }

  blockBottomSheetView() {
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
                  child: GestureDetector(
                      onTap: () {
                        getAccountType().then((value) {
                          // blockBothUsersAPIs(value, tblUserId.toString(), postBy);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
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
                                          color: ColorConstants
                                              .appPrimaryBlackColor),
                                    ),
                                    radius: 5,
                                    borderWidth: 0,
                                    borderWidthColor: Colors.transparent),
                              ),
                            ),
                            SACellRoundContainer(
                                height: 45,
                                width: 120,
                                color: ColorConstants.appPrimaryColor,
                                child: Center(
                                  child: headingText(
                                      title: "Block",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          ColorConstants.appPrimaryWhiteColor),
                                ),
                                radius: 5,
                                borderWidth: 0,
                                borderWidthColor: Colors.transparent),
                          ],
                        ),
                      )),
                ),
                addPadding(15, 0),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void getUserVideosData(String lastID) {
    var hashMap = {
      "user_id": userLoginModel?.data.userId,
      "tbl_vedio_id": lastID == "" ? "" : lastID,
    };
    print(hashMap);
    userUploadedVideoApi(hashMap).then((value) {
      setState(() {
        mlist.clear();
        if (value.status) {
          UserUplodedVideoListModel model = value.data;
          List<getVideoDatum> list = model.data;
          mlist = list;
        }
      });
    });
  }

  void getUserLikedVideosData(String lastID) {
    var hashMap = {
      "user_id": userLoginModel?.data.userId,
      "tbl_vedio_id": lastID == "" ? "" : lastID,
    };
    print(hashMap.toString() + "fsdfsdfsdfsfsdfsdf");
    userLikedVideoApi(hashMap).then((value) {
      setState(() {
        if (value.status) {
          UserLikedVideoListModel model = value.data;
          List<likeVideoDatum> list = model.data;
          //  mLikedlist = list;
          var arr = list;
          mLikedlist.addAll(arr);
        }
      });
    });
  }

  void getProfileDetailAPIs() async {
    APIResponse response = await getProfileDetailAPI(
        {"user_id": userLoginModel!.data.userId.toString()});
    if (response.status) {
      setState(() {
        GetProfileDataModel model = response.data;
        userProfileModel = model;
      });

      if (userProfileModel != null) {}
    } else {
      showErrorBottomSheet(response.message.toString());
    }
  }

  userVideoPage() {
    return mlist.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5),
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isMoreLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  isMoreLoading = true;
                  lastID = mlist.last.lastId.toString();
                  getUserVideosData(lastID);
                }
                return false;
              },
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: mlist.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 142,
                      crossAxisSpacing: 5),
                  itemBuilder: (_, index) {
                    //MFDatum mDatum=controller.myFavoritesModelList.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 5),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(UserVideoPlayerView(
                            thumbnail: mlist[index].videoThumb,
                            videoUrl: mlist[index].video,
                            type: "User",
                            index: index,
                            userVideoList: mlist,
                            likeVideoList: [],
                          ));
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          fit: BoxFit.fitWidth,
                                          image: mlist[index].videoThumb,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Positioned(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    deleteVideo(mlist[index].tblVedioId);
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
                                        color:
                                            ColorConstants.APPPRIMARYBLACKCOLOR,
                                      )),
                                ),
                              ),
                            )),
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
          )
        : NoRecord();
  }

  userLikedVideoPage(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isMoreLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          isMoreLoading = true;
          lastID = mlist.last.lastId.toString();
          print(lastID + "hbbgbhvb");
          getUserLikedVideosData(lastID);
        }
        return false;
      },
      child: mLikedlist.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: mLikedlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisExtent: 142, crossAxisSpacing: 5),
              itemBuilder: (_, index) {
                //MFDatum mDatum=controller.myFavoritesModelList.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 5),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            child: SizedBox(
                                width: double.infinity,
                                height: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(UserVideoPlayerView(
                                        thumbnail: mLikedlist[index].videoThumb,
                                        videoUrl: mLikedlist[index].video,
                                        type: "Like",
                                        index: index,
                                        userVideoList: [],
                                        likeVideoList: mLikedlist,
                                      ));
                                    },
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      fit: BoxFit.fitWidth,
                                      image: mLikedlist[index].videoThumb,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Positioned(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: GestureDetector(
                            onTap: () {
                              likeApi(mLikedlist[index].tblVedioId);
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
                                  color: ColorConstants.APPPRIMARYBLACKCOLOR,
                                )),
                          ),
                        ),
                      )),
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
                );
              }),
    );
  }

  void deleteVideo(String vedioId) {
    var hashMap = {
      "tbl_vedio_id": vedioId,
      "user_id": userLoginModel!.data.userId,
    };
    print(hashMap);
    userVideoDelete(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
        setState(() {
          mLikedlist.clear();
          getUserLikedVideosData("");
        });
      }
    });
  }

  void likeApi(String tblVedioId) {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "video_id": tblVedioId,
      "like": "unlike",
    };
    print(hashMap.toString() + "chbshfbhdbfbdbf");
    homeVideoLikeApi(hashMap).then((value) {
      if (value.status) {
        print(value.message);
        toastMessage("Video removed");
        getUserLikedVideosData("");
      } else {
        toastMessage(value.message);
      }
    });
  }
}
