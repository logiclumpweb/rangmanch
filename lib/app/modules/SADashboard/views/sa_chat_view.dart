import 'package:champcash/Data/FireStoreConstants.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_chat_controller.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/app/modules/SADashboard/views/sa_conversion_iew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../Data/fr_constants.dart';
import '../../../../models/UserChatModel.dart';
import '../../../../shared/extras.dart';

class SAChatView extends GetView<SADashboardController> {
  const SAChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            addPadding(12, 50),
            searchChatsWidget(),
            addPadding(12, 0),
            Expanded(
                flex: 80,
                child: StreamBuilder<QuerySnapshot>(
                  stream: controller.getChatForFireStore(
                    FireBaseConstants.pathUserCollection,
                    20,
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.builder(
                          itemBuilder: (ctx, i) {
                            var data = snapshot.data!.docs[i].data()
                                as Map<String, dynamic>;
                            // print(data);
                            if (controller.textSearch.value.trim() == "") {
                              return chatUserListUI(context, data);
                            }
                            return Center(child: Container());
                          },
                          itemCount: snapshot.data!.size,
                        );
                      } else {
                        return noMessageConversionUI();
                      }
                    } else {
                      return noMessageConversionUI();
                    }
                  },
                )),
          ],
        ));
  }

  searchChatsWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 34.0),
      child: Row(
        children: [
          SABackButton(
              onPressed: () {
                controller.updateBottomIndex(0);
              },
              color: const Color(0xffc4c4c4)),
          addPadding(10, 0),
          Flexible(
            child: TextField(
              controller: Get.find<SADashboardController>()
                  .ediTextSeachController
                  .value,
              style: GoogleFonts.inter(
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
              cursorColor: ColorConstants.APPPRIMARYWHITECOLOR,
              onChanged: (v) {
                Get.find<SAChatController>().textSearch.value = v;
              },
              decoration: InputDecoration(
                  focusColor: ColorConstants.APPPRIMARYWHITECOLOR,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 1.0,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 20, left: 15),
                  hintText: "Search",
                  hintStyle: GoogleFonts.urbanist(
                      color: ColorConstants.APPPRIMARYWHITECOLOR,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                  filled: true,
                  fillColor:
                      ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15)),
            ),
          ),
        ],
      ),
    );
  }

  chatUserListUI(
    BuildContext context,
    Map<String, dynamic> doc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: GestureDetector(
        onTap: () {
          Get.to(ConversionView(
            peerId: doc[FireBaseConstants.peerId],
            nickName: doc[FireBaseConstants.userName],
            photoUrl: doc[FireBaseConstants.userImage],
          ));
        },
        child: SizedBox(
          child: Column(
            children: [
              addPadding(10, 0),
              Row(
                children: [
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(105),
                          child: ImageViewCovered(
                              photoUrl: doc[FireBaseConstants.userImage])),
                    ),
                  ),
                  addPadding(10, 0),
                  Expanded(
                    flex: 70,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: headingFullText(
                                  title:
                                      doc[FireBaseConstants.userName] == "null"
                                          ? ""
                                          : doc[FireBaseConstants.userName],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: ColorConstants.APPPRIMARYWHITECOLOR),
                            ),
                            doc[FireBaseConstants.timeStamp] == ""
                                ? const SizedBox()
                                : SizedBox(),
                          ],
                        ),
                        addPadding(5, 3),
                        Row(
                          children: [
                            addPadding(0, 1),
                            Expanded(
                              flex: 1,
                              child: Text(
                                /* doc[FireBaseConstants.message] == ""
                                    ? */
                                doc[FireBaseConstants.message],
                                style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xff8A8A8A)),
                              ),
                            ),
                            /* model.noOfUnRead == 0
                                ? const SizedBox()
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: SACellRoundContainer(
                                        height: 17,
                                        width: 17,
                                        color: ColorConstants.appPrimaryColor,
                                        child: Center(
                                          child: headingText(
                                              title:
                                                  model.noOfUnRead.toString(),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: ColorConstants
                                                  .appPrimaryWhiteColor),
                                        ),
                                        radius: 20,
                                        borderWidth: 0,
                                        borderWidthColor: Colors.transparent),
                                  ),*/
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      addPadding(0, 5),
                      headingText(
                          title: getChatTime(DateFormat("yyyy-MM-dd HH:mm")
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(
                                      doc[FireStoreConstants.timestamp])))),
                          fontSize: 12,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                          fontWeight: FontWeight.w500),
                      doc[FireStoreConstants.noOfUnRead] == 0 ||
                              doc[FireStoreConstants.noOfUnRead] == null
                          ? const SizedBox()
                          : SACellRoundContainer1(
                              color: const Color(0xff3672B7),
                              width: 20,
                              height: 20,
                              child: Center(
                                  child: headingText(
                                      title: doc[FireStoreConstants.noOfUnRead]
                                          .toString(),
                                      color:
                                          ColorConstants.APPPRIMARYWHITECOLOR,
                                      fontSize: 10)),
                              radius: 30,
                              borderWidth: 0,
                              borderWidthColor: Colors.transparent)
                      /* SACellRoundContainer1(
                              color: Color(0xff4A4849),
                              height: 20,
                              width: 20,
                              child: Center(
                                child: Text(
                                  "4",
                                  style: GoogleFonts.urbanist(
                                      fontSize: 11,
                                      color:
                                          ColorConstants.APPPRIMARYWHITECOLOR,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              radius: 40,
                              borderWidth: 0,
                              borderWidthColor: Colors.transparent)
                          .paddingAll(2)*/
                    ],
                  )
                ],
              ),
              addPadding(10, 0),
              addPadding(0, 35),
              addPadding(8, 0)
            ],
          ),
        ),
      ),
    );
  }

  static String getChatTime(String? date) {
    if (date == null || date.isEmpty) {
      return "";
    }
    String msg = "";
    var dt = DateTime.parse(date).toLocal();
    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }
    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 365) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 30) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 0) {
      msg = "${dur.inDays}d ago";
      return dur.inDays == 1 ? "1d" : DateFormat.MMMd().format(dt);
    } else if (dur.inHours > 0) {
      msg = "${dur.inHours}h ago";
    } else if (dur.inMinutes > 0) {
      msg = "${dur.inMinutes}m ago";
    } else if (dur.inSeconds > 0) {
      msg = "${dur.inSeconds}s ago";
    } else {
      msg = "now";
    }
    return msg;
  }

  noMessageConversionUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.message_rounded,
          size: 50,
          color: ColorConstants.appPrimarylightGreyColor,
        ),
        addPadding(10, 0),
        headingText(
            title: "No chat messages",
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: ColorConstants.APPPRIMARYWHITECOLOR),
        addPadding(10, 0),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35, top: 10),
          child: headingLongText(
              align: TextAlign.center,
              title: "Start conversing to see your messages here.",
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: ColorConstants.appPrimaryBlackColor),
        ),
      ],
    );
  }
}
