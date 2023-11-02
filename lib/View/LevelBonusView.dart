import 'package:champcash/Apis/api.dart';
import 'package:champcash/View/LevelDetailsView.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Data/UserData.dart';
import '../models/LevelBonusViewListModel.dart';

class LevelBonusView extends StatefulWidget {
  const LevelBonusView({Key? key}) : super(key: key);

  @override
  State<LevelBonusView> createState() => _LevelBonusViewState();
}

class _LevelBonusViewState extends State<LevelBonusView> {

  List<levelDatum>mlist=<levelDatum>[];

  String totalIncome="0";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarUI(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  headingText(title: "Sponsor"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: headingText(
                        title: userLoginModel!.data.usedReferalCode,
                        color: ColorConstants.APPPRIMARYCOLOR),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      height: 35,
                      width: 2,
                      color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    ),
                  ),
                  headingText(title: "Total Level Income"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: headingText(
                        title: totalIncome, color: ColorConstants.APPPRIMARYCOLOR),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 12.0),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: headingText(
                          title: "Level",
                          color: ColorConstants.APPPRIMARYCOLOR),
                    ),
                  ),
                  Expanded(
                    child: headingText(
                        title: "Income", color: ColorConstants.APPPRIMARYCOLOR),
                  ),
                  Expanded(
                    child: headingText(
                        title: "Active IDs",
                        color: ColorConstants.APPPRIMARYCOLOR),
                  ),
                  Expanded(
                    child: headingText(
                        title: "Total User",
                        color: ColorConstants.APPPRIMARYCOLOR),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: mlist.isNotEmpty? ListView.builder(
                itemCount: mlist.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(LevelDeatilsView(levelValue: mlist[i].levelValue,));
                      },
                      child: Container(
                        height: 50,
                        width: 400,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xffc9c7c7)),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: headingText(title: mlist[i].level),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: headingText(title: mlist[i].totalLevelIncom),
                            )),
                            Expanded(child: headingText(title: mlist[i].totalActivecount)),
                            Expanded(child: headingText(title: mlist[i].totalcount)),
                          ],
                        ),
                      ),
                    ),
                  );
                }):Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    ));
  }

  appBarUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "Level Bonus", fontSize: 16),
    );
  }

  @override
  void initState() {
    var hashMap = {
      "referal_code": userLoginModel!.data.referalCode,
      "user_id": userLoginModel!.data.userId,
    };
    levelListViewAPI(hashMap).then((value){
      setState(() {

        if(value.status){
          totalIncome=value.message;
          LevelBonusViewListModel model=value.data;
          List<levelDatum>list=model.data;
          mlist=list;
        }else{
          showErrorBottomSheet(value.message);
        }
      });


    });
  }
}
