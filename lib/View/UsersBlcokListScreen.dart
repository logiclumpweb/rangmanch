import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/models/UsersBlockListModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersBlockListScreen extends StatefulWidget {
  const UsersBlockListScreen({super.key});

  @override
  State<UsersBlockListScreen> createState() => _UsersBlockListScreenState();
}

class _UsersBlockListScreenState extends State<UsersBlockListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorConstants.APPPRIMARYWHITECOLOR,
          ),
        ),
        title: Text("Block List",
            style: textStyleW600(
                fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR)),
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getBlockUserListAPIs(
                    {"user_id": userLoginModel!.data.userId}),
                builder: (BuildContext context,
                    AsyncSnapshot<APIResponse> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const GIFLaaderPage();
                  }
                  if (!snapshot.hasData || snapshot.data!.data == null) {
                    return NoRecordFoundView();
                  }

                  UserBlockListModel m = snapshot.data!.data;

                  return ListView.builder(
                      itemCount: m.data.length,
                      itemBuilder: (c, pos) {
                        BLKDatum b = m.data.elementAt(pos);
                        return SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              addPadding(10, 0),
                              SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipOval(
                                      child: NetworkImageView(
                                          imgUrl: b.blockedUserimage))),
                              addPadding(15, 0),
                              Text(
                                b.blockedUsername,
                                style: textStyleW600(
                                    fontSize: 16,
                                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                              ),
                              const Spacer(),
                              SizedBox(
                                  width: 110,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap: () {
                                      unBlockUserAPIs({
                                        "user_id": userLoginModel!.data.userId,
                                        "tbl_block_user_id": b.tblBlockUserId
                                      }).then((value) {
                                        if (value.status) {
                                          toastMessage(value.message);
                                          Get.find<SADashboardController>()
                                              .callingUserBlocked(
                                                  b.blockedUserId,
                                                  unblock: true);
                                          setState(() {});
                                        } else {
                                          toastMessage(value.message);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                              colors: [
                                                ColorConstants.appPrimaryColor,
                                                ColorConstants.appPrimaryColor,
                                                // Color(0xffFE9B0E),
                                                // Color(0xffEF840C),
                                              ])),
                                      child: Center(
                                        child: headingText(
                                            title: "Unblock",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xffffffff)),
                                      ),
                                    ),
                                  )).paddingOnly(right: 8)
                            ],
                          ),
                        ).paddingOnly(top: 8);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
