import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/app/modules/SADashboard/views/UserProfileScreen.dart';
import 'package:champcash/models/follow_model.dart';
import 'package:champcash/models/followlist_model.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../shared/cell_container.dart';
import '../../../../shared/extras.dart';
import '../controllers/s_a_dashboard_controller.dart';
import '../controllers/s_a_profile_controller.dart';
import 'package:flutter/material.dart';

class UserFollowersView extends StatefulWidget {
  final String userId, pageType;
  const UserFollowersView(
      {Key? key, required this.userId, required this.pageType})
      : super(key: key);

  @override
  State<UserFollowersView> createState() => _UserFollowersViewState();
}

class _UserFollowersViewState extends State<UserFollowersView> {
  int ffPageIndex = 0;

  PageController ffPageController = PageController();

  // SADashboardController dashBoardController = Get.find<SADashboardController>();
  @override
  void initState() {
    super.initState();
    ffPageIndex = widget.pageType == "Followers" ? 0 : 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: SABackButton(
          onPressed: () {
            Get.back();
          },
          color: ColorConstants.APPPRIMARYWHITECOLOR,
        ),
        backgroundColor: ColorConstants.APPPRIMARYCOLOR,
        title: headingText(title: ffPageIndex == 0 ? "Followers" : "Following"),
      ),
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      body: Column(
        children: [
          bTabsWidget(),
          Expanded(
              child: PageView.builder(
            controller: ffPageController,
            allowImplicitScrolling: false,
            //  physics: NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              ffPageIndex = page;
              setState(() {});
            },
            itemBuilder: (context, index) {
              return ffPageIndex == 0
                  ? _buildItemFWListUI()
                  : _buildFWGListUI(context);
            },
            itemCount: 2,
          ))
        ],
      ),
    );
  }

  bTabsWidget() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: GestureDetector(
            child: _createItem(ffPageIndex == 0, 'Followers'),
            onTap: () {
              ffPageIndex = 0;
              ffPageController.jumpToPage(ffPageIndex);
            },
          )),
          Expanded(
              child: GestureDetector(
            child: _createItem(ffPageIndex == 1, 'Following'),
            onTap: () {
              ffPageIndex = 1;
              ffPageController.jumpToPage(ffPageIndex);
            },
          )),
        ],
      ),
    );
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

  _buildItemFWListUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 5),
      child: FutureBuilder(
        future: fetchUserFollowListAPI({"user_id": widget.userId}),
        builder: (BuildContext context, AsyncSnapshot<APIResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const GIFLaaderPage();
          }
          if (!snapshot.hasData || !snapshot.data!.status) {
            return NoRecordFoundView();
          }
          FollowModel flmodel = snapshot.data!.data;
          List<fDatum> flist = flmodel.data;
          //PackageListModel m = snapshot.data!.data;
          // List<PKGDatum> packageModelList = m.data;
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: flist.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              fDatum m = flist.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                      color: ColorConstants.APPPRIMARYBLACKCOLOR,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 3,
                            color: Colors.grey.withOpacity(0.5))
                      ]),
                  child: GestureDetector(
                    onTap: () {
                      final pCont = Get.find<ProfileController>();
                      pCont.onInit1(m.followingUserId);
                      pCont.profileVisibilityVal.value = false;
                      pCont.mLikedlist.clear();
                      pCont.userVideosList.clear();

                      Get.to(UserProfileScreen(
                        userId: m.followingUserId,
                      ));
                      // Get.back();
                      // dashBoardController.updateBottomIndex(3);
                      // Get.find<ProfileController>()
                      //     .onInit1(m.followingUserId);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: SACellNSRoundContainer(
                                child: ClipOval(
                                  child: ImageViewCovered(
                                    photoUrl: m.image,
                                  ),
                                ).paddingAll(2),
                                radius: 55,
                                borderWidth: 1,
                                borderWidthColor: ColorConstants
                                    .APPPRIMARYGREYCOLOR
                                    .withOpacity(
                                        0.40)), /* ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: ImageViewCovered(
                                      photoUrl: controller.mFList[index].image,
                                    ),
                                  ),*/
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: headingText(
                                  title: m.username.capitalizeFirst,
                                  fontSize: 14,
                                  color: ColorConstants.APPPRIMARYWHITECOLOR)
                              .paddingOnly(left: 10),
                        ),
                        // const Spacer(),
                        // userLoginModel!.data.userId ==
                        //         profileCont.tblUserId.value
                        //     ? GestureDetector(
                        //         onTap: () {
                        //           profileCont
                        //               .userFollowAPIs1(m.followingUserId);
                        //           setState(() {});
                        //         },
                        //         child: Container(
                        //           height: 35,
                        //           width: 85,
                        //           decoration: BoxDecoration(
                        //               borderRadius:
                        //                   BorderRadius.circular(15),
                        //               gradient: const LinearGradient(
                        //                   begin: Alignment.topLeft,
                        //                   end: Alignment.topRight,
                        //                   colors: [
                        //                     ColorConstants.appPrimaryColor,
                        //                     ColorConstants.appPrimaryColor,
                        //                     ColorConstants.appPrimaryColor,
                        //                     // Color(0xffFE9B0E),
                        //                     // Color(0xffEF840C),
                        //                   ])),
                        //           child: Center(
                        //             child: headingText(
                        //                 title: "Unfollow",
                        //                 fontSize: 13,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: Color(0xffffffff)),
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox(),
                        addPadding(8, 0)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _buildFWGListUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5),
      child: FutureBuilder(
        future: getuserfollowing_List({"user_id": widget.userId}),
        builder: (BuildContext context, AsyncSnapshot<APIResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const GIFLaaderPage();
          }
          if (!snapshot.hasData || !snapshot.data!.status) {
            return NoRecordFoundView();
          }
          FollowlistModel fmodel = snapshot.data!.data;
          List<followDatum> fllist = fmodel.data;
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: fllist.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              followDatum m = fllist.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    final pCont = Get.find<ProfileController>();
                    pCont.onInit1(m.followingUserId);
                    pCont.profileVisibilityVal.value = false;
                    pCont.mLikedlist.clear();
                    pCont.userVideosList.clear();

                    Get.to(UserProfileScreen(
                      userId: m.followingUserId,
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: ColorConstants.APPPRIMARYBLACKCOLOR,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 3,
                              color: Colors.grey.withOpacity(0.5))
                        ]),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: SACellNSRoundContainer(
                                child: ClipOval(
                                  child: ImageViewCovered(
                                    photoUrl: m.image,
                                  ),
                                ).paddingAll(2),
                                radius: 55,
                                borderWidth: 1,
                                borderWidthColor: ColorConstants
                                    .APPPRIMARYGREYCOLOR
                                    .withOpacity(0.40)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: headingText(
                                  title: m.username.capitalizeFirst,
                                  fontSize: 14,
                                  color: ColorConstants.APPPRIMARYWHITECOLOR)
                              .paddingOnly(left: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
