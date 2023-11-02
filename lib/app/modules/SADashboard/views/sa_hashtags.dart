import 'package:champcash/app/modules/SADashboard/views/UserProfileScreen.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Routes/AppRoutes.dart';
import '../../../../View/hashTagDetailsView.dart';
import '../../../../shared/extras.dart';
import '../controllers/s_a_dashboard_controller.dart';
import '../controllers/s_a_hash_controller.dart';
import '../controllers/s_a_profile_controller.dart';

class SAHashTagView extends GetView<SAhashtagController> {
  SAHashTagView({Key? key}) : super(key: key);

  SADashboardController dashBoardController = Get.find<SADashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              addPadding(10, 50),
              searchTextFieldWidget(),
              Expanded(
                child: controller.isSearchDataFound.value
                    ? searchUserUI()
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: headingLongText(
                                            title: "TAGS",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstants
                                                .APPPRIMARYWHITECOLOR)
                                        .paddingOnly(left: 10),
                                  ),
                                ),
                                const Divider(
                                  color:
                                      ColorConstants.appPrimarylightGreyColor,
                                ).paddingOnly(
                                    left: 20, right: 20, bottom: 8, top: 5),

                                //#Tag
                                /*    Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: SizedBox(
                                    height: 185,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: GridView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              controller.hashTagList.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisExtent: 45),
                                          itemBuilder: (_, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes.S_A_HASTAGDETAILS,
                                                      arguments: [
                                                        {
                                                          "hashTagName":
                                                              controller
                                                                  .hashTagList
                                                                  .value[index]
                                                                  .hashTagName
                                                                  .toString(),
                                                        },
                                                        {
                                                          "hashTagID":
                                                              controller
                                                                  .hashTagList
                                                                  .value[index]
                                                                  .tblHashTagId
                                                                  .toString(),
                                                        }
                                                      ]);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 8.0,
                                                            offset:
                                                                Offset(2, 2),
                                                            spreadRadius: 1)
                                                      ]),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: headingText(
                                                          title: controller
                                                              .hashTagList[
                                                                  index]
                                                              .hashTagName
                                                              .capitalize,
                                                          align: TextAlign
                                                              .center)),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),*/

                                /*  Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    controller.hashTagList[2].hashTagName
                                        .capitalizeFirst
                                        .toString(),
                                    style: GoogleFonts.urbanist(
                                        fontSize: 15,
                                        color:
                                            ColorConstants.APPPRIMARYWHITECOLOR,
                                        fontWeight: FontWeight.w600),
                                  ).paddingOnly(left: 20, top: 10),
                                ),

                                tagsVideoListWidget(context),*/

                                /*  Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    controller.hashTagList[5].hashTagName
                                        .capitalizeFirst
                                        .toString(),
                                    style: GoogleFonts.urbanist(
                                        fontSize: 15,
                                        color:
                                            ColorConstants.APPPRIMARYWHITECOLOR,
                                        fontWeight: FontWeight.w600),
                                  ).paddingOnly(left: 20, top: 10),
                                ),

                                lastTagsVideoListWidget(context)*/

                                Wrap(
                                  children:
                                      controller.hashTagList.map((element) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Get.toNamed(Routes.S_A_HASTAGDETAILS,
                                            arguments: [
                                              {
                                                "hashTagName": element
                                                    .hashTagName
                                                    .toString(),
                                              },
                                              {
                                                "hashTagID": element
                                                    .tblHashTagId
                                                    .toString(),
                                              }
                                            ]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color(0xff545353)
                                                    .withOpacity(0.9))),
                                        child: headingText(
                                                title:
                                                    "#${element.hashTagName.capitalize}",
                                                fontSize: 14,
                                                color: ColorConstants
                                                    .APPPRIMARYWHITECOLOR)
                                            .paddingAll(8),
                                      ).paddingOnly(left: 10, top: 8, right: 5),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            // const Divider(
                            //   color: Colors.white,
                            // ).paddingOnly(
                            //     left: 15, right: 15, top: 10, bottom: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, left: 15),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: headingLongText(
                                        title: "PEOPLE",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            ColorConstants.APPPRIMARYWHITECOLOR)
                                    .paddingOnly(left: 10),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 12, top: 10),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 15),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.userTagList.length,
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisExtent: 150),
                                  itemBuilder: (_, inx) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: ColorConstants
                                                  .appPrimarylightBlackColor
                                                  .withOpacity(0.50)),
                                          color: ColorConstants
                                              .appPrimarylightGreyColor
                                              .withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              final pCont =
                                                  Get.find<ProfileController>();
                                              pCont.onInit1(controller
                                                  .userTagList[inx].userId);
                                              pCont.profileVisibilityVal.value =
                                                  false;
                                              pCont.mLikedlist.clear();
                                              pCont.userVideosList.clear();

                                              Get.to(UserProfileScreen(
                                                  userId: controller
                                                      .userTagList[inx]
                                                      .userId));
                                              // dashBoardController
                                              //     .updateBottomIndex(3);
                                              // Get.find<ProfileController>()
                                              //     .onInit1(controller
                                              //         .userTagList[inx].userId);
                                              // dashBoardController
                                              //     .isOpenTagScreen.value = true;
                                            },
                                            child: Column(
                                              children: [
                                                addPadding(0, 15),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: SizedBox(
                                                    width: 80,
                                                    height: 80,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(70),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: ColorConstants
                                                                .appPrimarylightBlackColor
                                                                .withOpacity(
                                                                    0.4)),
                                                      ),
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          controller
                                                              .userTagList[inx]
                                                              .userImage,
                                                          fit: BoxFit.cover,
                                                        ).paddingAll(2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                headingLongText(
                                                        title: controller
                                                            .userTagList[inx]
                                                            .userName,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                        align: TextAlign.center)
                                                    .paddingOnly(
                                                        left: 6,
                                                        top: 6,
                                                        bottom: 7,
                                                        right: 5)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),

                            /*const Divider(
                              color: ColorConstants.appPrimarylightGreyColor,
                            ).paddingOnly(left: 15,right: 15,top: 15,bottom: 5),

                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: headingLongText(
                                        title: "PEOPLE",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            ColorConstants.APPPRIMARYWHITECOLOR)
                                    .paddingOnly(left: 10),
                              ),
                            ),

                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.userTagList.length ?? 0,
                                  itemBuilder: (_, pos) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                border: Border.all(
                                                    width: 1,
                                                    color: ColorConstants
                                                        .appPrimarylightGreyColor)),
                                            child: ClipOval(
                                              child: NetworkImageView(
                                                imgUrl: controller
                                                    .userTagList[pos].userImage,
                                                fit: BoxFit.cover,
                                              ).paddingAll(2),
                                            ),
                                          ),
                                        ).paddingOnly(left: 8),
                                        headingText(
                                                title: controller
                                                    .userTagList[pos].userName,
                                                color: ColorConstants
                                                    .APPPRIMARYWHITECOLOR,
                                                fontSize: 10)
                                            .paddingOnly(top: 12),
                                      ],
                                    );
                                  }),
                            ).paddingOnly(left: 15, top: 16),*/

                            addPadding(10, 0),
                          ],
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  searchTextFieldWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          SABackButton(
              onPressed: () {
                controller.dController.updateBottomIndex(0);
              },
              color: ColorConstants.APPPRIMARYWHITECOLOR),
          Flexible(
            child: SizedBox(
              height: 50,
              child: TextField(
                cursorColor: ColorConstants.APPPRIMARYWHITECOLOR,
                controller: controller.editUserSeachController.value,
                style: GoogleFonts.openSans(
                    color: ColorConstants.APPPRIMARYWHITECOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.getSearchResult(controller
                        .editUserSeachController.value.text
                        .toString()
                        .trim());
                  } else {
                    controller.isSearchDataFound.value = false;
                  }

                  //  searchKeyWordAPIs(editSearchController.text);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: () {
                        controller.editUserSeachController.value.clear();
                        controller.isSearchDataFound.value = false;
                      },
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/2811/2811790.png",
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                      ).paddingAll(12),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.editUserSeachController.value.clear();
                          controller.isSearchDataFound.value = false;
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                        )),
                    contentPadding: const EdgeInsets.only(top: 4, left: 4),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Search Keyword",
                    hintStyle: GoogleFonts.urbanist(
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor:
                        ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15)),
              ),
            ).paddingOnly(right: 10, left: 8),
          ),
          /* Text(
            "Cancel",
            style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: ColorConstants.APPPRIMARYWHITECOLOR),
          ).paddingOnly(left: 10)*/
        ],
      ),
    );
  }

  searchUserUI() {
    return Obx(() => controller.searchUserList.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: 600,
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              itemCount: controller.searchUserList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      dashBoardController.updateBottomIndex(3);
                      Get.find<ProfileController>()
                          .onInit1(controller.searchUserList[index].userId);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1,
                      height: 100,
                      decoration: BoxDecoration(
                        color: ColorConstants.APPPRIMARYGREYCOLOR
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          addPadding(10, 0),
                          Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(65),
                                border: Border.all(
                                    width: 1,
                                    color: ColorConstants.APPPRIMARYGREYCOLOR
                                        .withOpacity(0.20))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              child: NetworkImageView(
                                imgUrl: controller
                                    .searchUserList.value[index].image,
                                fit: BoxFit.cover,
                              ),
                            ).paddingAll(1),
                          ),
                          addPadding(15, 0),
                          headingText(
                              title: controller.searchUserList.value[index]
                                  .username.capitalizeFirst,
                              fontSize: 14,
                              color: ColorConstants.APPPRIMARYWHITECOLOR),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ));
  }

  tagsVideoListWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 175,
        child: ListView.builder(
            itemCount: controller.tagVideosList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, inx) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xff9a9898),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff9a9898),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: ImageViewCovered(
                    photoUrl: controller.tagVideosList[inx].videoThumb,
                  ),
                ).paddingAll(0.90),
              ).paddingOnly(left: 10, bottom: 4, top: 4);
            }),
      ),
    );
  }

  lastTagsVideoListWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 175,
        child: ListView.builder(
            itemCount: controller.lastTagVideosList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, inx) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xff9a9898),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff9a9898),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: ImageViewCovered(
                    photoUrl: controller.lastTagVideosList[inx].videoThumb,
                  ),
                ).paddingAll(1),
              ).paddingOnly(left: 10, bottom: 4, top: 4);
            }),
      ),
    );
  }
}
