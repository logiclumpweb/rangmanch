import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/models/GiftModel.dart';
import 'package:champcash/models/GiftReceiveModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GiftTransactionScreen extends StatelessWidget {
  const GiftTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: GiftTransactionController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: headingText(
                  title: "Gift", color: ColorConstants.APPPRIMARYWHITECOLOR),
              backgroundColor: ColorConstants.appPrimaryBlackColor,
            ),
            backgroundColor: ColorConstants.appPrimaryBlackColor,
            body: Column(
              children: [
                SizedBox(
                  // color: ColorConstants.APPPRIMARYWHITECOLOR,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: GestureDetector(
                        child: createTabItem(
                            controller.pageIndex.value == 0, 'Receive'),
                        onTap: () {
                          controller.pageIndex.value = 0;
                          controller.pageController
                              .jumpToPage(controller.pageIndex.value);
                        },
                      )),
                      Expanded(
                          child: GestureDetector(
                        child: createTabItem(
                            controller.pageIndex.value == 1, 'Send'),
                        onTap: () {
                          controller.pageIndex.value = 1;
                          controller.pageController
                              .jumpToPage(controller.pageIndex.value);
                        },
                      )),
                    ],
                  ),
                ),
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
                        ? giftReceiveScreen(controller)
                        : giftSendScreen(context, controller);
                  },
                  itemCount: 2,
                ))
              ],
            ),
          );
        });
  }

  createTabItem(bool selected, String title) {
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

  giftReceiveScreen(GiftTransactionController cont) {
    return FutureBuilder(
      future: cont.giftReceivedAPIs(),
      builder: (BuildContext context, AsyncSnapshot<List<GFTRDatum>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GIFLaaderPage();
        } else if (!snapshot.hasData) {
          return NoRecordFoundView().paddingAll(40);
        }
        return ListView.builder(
            itemCount: snapshot.data!.length ?? 0,
            itemBuilder: (_, pos) {
              GFTRDatum m = snapshot.data!.elementAt(pos);
              return Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                        height: 55,
                        width: 55,
                        child: ClipOval(
                            child: NetworkImageView(
                          imgUrl: m.image,
                        ))),
                    title: headingText(
                        fontWeight: FontWeight.w600,
                        title: m.name,
                        color: ColorConstants.APPPRIMARYWHITECOLOR),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        headingText(
                            fontWeight: FontWeight.w400,
                            title: "Received By ${m.username}",
                            fontSize: 12,
                            color: ColorConstants.APPPRIMARYWHITECOLOR
                                .withOpacity(0.80)),
                        addPadding(0, 4),
                        headingText(
                            fontWeight: FontWeight.w400,
                            title: m.sendTime,
                            fontSize: 11,
                            color: ColorConstants.APPPRIMARYWHITECOLOR
                                .withOpacity(0.60)),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.diamond,
                          color: Colors.amber,
                          size: 16,
                        ),
                        addPadding(5, 0),
                        headingText(
                            fontWeight: FontWeight.w400,
                            title: m.tokens,
                            fontSize: 12,
                            color: ColorConstants.APPPRIMARYWHITECOLOR
                                .withOpacity(0.60)),
                      ],
                    ),
                  ),
                  Divider(
                    color:
                        ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.30),
                  ).paddingOnly(left: 75)
                ],
              ).paddingOnly(top: 7);
            });
      },
    );
  }

  giftSendScreen(BuildContext context, GiftTransactionController cont) {
    return FutureBuilder(
      future: cont.giftSendAPIs(),
      builder:
          (BuildContext context, AsyncSnapshot<List<GFTSDDatum>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GIFLaaderPage();
        } else if (!snapshot.hasData) {
          return NoRecordFoundView().paddingAll(40);
        }
        return ListView.builder(
            itemCount: snapshot.data!.length ?? 0,
            itemBuilder: (_, pos) {
              GFTSDDatum m = snapshot.data!.elementAt(pos);
              return Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                        height: 55,
                        width: 55,
                        child: ClipOval(
                            child: NetworkImageView(
                          imgUrl: m.image,
                        ))),
                    title: headingText(
                        fontWeight: FontWeight.w600,
                        title: m.name,
                        color: ColorConstants.APPPRIMARYWHITECOLOR),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        headingText(
                            fontWeight: FontWeight.w400,
                            title: "Sent to ${m.username}",
                            fontSize: 12,
                            color: ColorConstants.APPPRIMARYWHITECOLOR
                                .withOpacity(0.80)),
                        addPadding(0, 4),
                        headingText(
                            fontWeight: FontWeight.w400,
                            title: m.sendTime,
                            fontSize: 11,
                            color: ColorConstants.APPPRIMARYWHITECOLOR
                                .withOpacity(0.60)),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.diamond,
                          color: Colors.amber,
                          size: 16,
                        ),
                        addPadding(5, 0),
                        headingText(
                            fontWeight: FontWeight.w400,
                            title: m.tokens,
                            fontSize: 12,
                            color: ColorConstants.APPPRIMARYWHITECOLOR
                                .withOpacity(0.60)),
                      ],
                    ),
                  ),
                  Divider(
                    color:
                        ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.30),
                  ).paddingOnly(left: 75)
                ],
              ).paddingOnly(top: 7);
            });
      },
    );
  }
}

class GiftTransactionController extends GetxController {
  final pageIndex = 0.obs;
  PageController pageController = PageController();

  RxList<GFTRDatum> giftReceiveList = <GFTRDatum>[].obs;
  RxList<GFTSDDatum> giftSendList = <GFTSDDatum>[].obs;

  Future<List<GFTRDatum>> giftReceivedAPIs() async {
    APIResponse apiResponse = await giftReceivedListAPI(
        {"user_id": userLoginModel!.data.userId.toString()});
    GiftReceiveModel m = apiResponse.data;
    return m.data;
  }

  Future<List<GFTSDDatum>> giftSendAPIs() async {
    APIResponse apiResponse = await giftSendListAPI(
        {"user_id": userLoginModel!.data.userId.toString()});
    GiftSendModel m = apiResponse.data;
    return m.data;
  }
}
