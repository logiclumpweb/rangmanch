import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/NotificationService.dart';
import 'package:champcash/models/NotificationModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/extras.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String lastId = "0";

  List<NFFDatum> notificationModelList = [];
  NotificationServices notificationServices = NotificationServices();
  bool myMoreNotificationVal = false;

  @override
  void initState() {
    super.initState();
    notificationServices.initialiseNotification();
    getNotificationCountAPI({
      "user_id": userLoginModel!.data.userId.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      appBar: appBarWidget(),
      body: SizedBox.expand(
        child: FutureBuilder(
          future: getNotificationListAPI(""),
          builder:
              (BuildContext context, AsyncSnapshot<List<NFFDatum>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GIFLaaderPage();
            }
            if (!snapshot.hasData) {
              return NoRecordFoundView();
            } else if (!snapshot.data!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: NoRecordFoundView(),
              );
            }

            return NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!myMoreNotificationVal &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  print("PIIIUUUUUU");
                  myMoreNotificationVal = true;
                  getNotificationListAPI(notificationModelList.last.lastId);
                }
                return false;
              },
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    NFFDatum m = snapshot.data!.elementAt(index);
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: ColorConstants.APPPRIMARYGREYCOLOR
                                          .withOpacity(0.60)),
                                  borderRadius: BorderRadius.circular(40)),
                              height: 46,
                              width: 46,
                              child: ClipOval(
                                  child: NetworkImageView(
                                imgUrl: m.userImage,
                                fit: BoxFit.cover,
                              )).paddingAll(1)),
                          title: headingText(
                              title: m.msg.capitalizeFirst,
                              fontSize: 15,
                              color: ColorConstants.APPPRIMARYGREYCOLOR
                                  .withOpacity(0.98)),
                          subtitle: headingText(
                              title: m.time,
                              fontSize: 12,
                              color: ColorConstants.APPPRIMARYGREYCOLOR
                                  .withOpacity(0.70)),
                        ).paddingAll(8),
                        Divider(
                          height: 0.05,
                          color: ColorConstants.APPPRIMARYGREYCOLOR
                              .withOpacity(0.25),
                        ).paddingOnly(left: 90, right: 20, top: 5)
                      ],
                    );
                  }),
            );
          },
        ),
      ),
    );
  }

  appBarWidget() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      title: headingText(
          title: "Notification",
          fontSize: 17,
          color: ColorConstants.APPPRIMARYWHITECOLOR),
    );
  }

  Future<List<NFFDatum>> getNotificationListAPI(String lastId) async {
    var hashMap;
    if (lastId == "") {
      hashMap = {"user_id": userLoginModel!.data.userId.toString()};
    } else {
      hashMap = {
        "user_id": userLoginModel!.data.userId.toString(),
        "last_id": lastId
      };
    }
    APIResponse apiResponse = await getNotificationListAPIs(hashMap);
    NotificationModel m = apiResponse.data;
    notificationModelList.addAll(m.data);
    if (lastId.isNotEmpty) {
      setState(() {});
    }
    return notificationModelList;
  }
}
