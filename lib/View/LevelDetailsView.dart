import 'package:flutter/material.dart';

import '../Apis/api.dart';
import '../Data/UserData.dart';
import '../shared/extras.dart';
import '../models/LevelDetailsViewListModel.dart';
class LevelDeatilsView extends StatefulWidget {
  String? levelValue;
   LevelDeatilsView({Key? key, required this.levelValue}) : super(key: key);

  @override
  State<LevelDeatilsView> createState() => _LevelDeatilsViewState();
}

class _LevelDeatilsViewState extends State<LevelDeatilsView> {

  List<LDetailsDatum>mlist=<LDetailsDatum>[];

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: appBarUI(),
          body: mlist.isNotEmpty?Column(
            children: [
              SizedBox(height: 45,width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(scrollDirection: Axis.horizontal,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(width: 100,
                            child: headingText(
                                title: "Referral", color: ColorConstants.APPPRIMARYCOLOR,fontSize: 14,),
                          ),
                        ),
                        SizedBox(width: 100,
                          child: headingText(
                              title: "Name", color: ColorConstants.APPPRIMARYCOLOR,fontSize: 14),
                        ),
                        SizedBox(width: 100,
                          child: headingText(
                              title: "Mobile",
                              color: ColorConstants.APPPRIMARYCOLOR,fontSize: 14),
                        ),
                        SizedBox(width: 100,
                          child: headingText(
                              title: "Sponsor",
                              color: ColorConstants.APPPRIMARYCOLOR,fontSize: 14),
                        ),
                        SizedBox(width: 100,
                          child: headingText(
                              title: "Income",
                              color: ColorConstants.APPPRIMARYCOLOR,fontSize: 14),
                        ),
                        SizedBox(width: 50,
                          child: headingText(
                              title: "Status",
                              color: ColorConstants.APPPRIMARYCOLOR,fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(

                    itemCount: mlist.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GestureDetector(onTap: (){

                        },
                          child: Container(height: 50,width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Color(0xffc9c7c7)),
                                borderRadius: BorderRadius.circular(15)),
                            child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: SizedBox(width: 100,child: headingText(title: mlist[i].referalCode)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SizedBox(width: 100,child: headingText(title: mlist[i].name)),
                                  ),
                                  SizedBox(width: 100,child: headingText(title: mlist[i].mobile)),
                                  SizedBox(width: 100,child: headingText(title: mlist[i].usedReferalCode)),
                                  SizedBox(width: 60,child: headingText(title: mlist[i].income)),
                                  SizedBox(width: 80,child: mlist.first.income=="0"? headingText(title: "Active",color: Colors.greenAccent):headingText(title: "deactive",color: Colors.red)),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ):Center(child: CircularProgressIndicator(color: ColorConstants.APPPRIMARYCOLOR,)),
        ));
  }

  @override
  void initState() {
    var hashMap = {
      "referal_code": userLoginModel!.data.referalCode,
      "level_value": widget.levelValue,
    };
    levelDetailsViewAPI(hashMap).then((value){
      setState(() {

        if(value.status){
          LevelDetailsViewListModel model=value.data;
          List<LDetailsDatum>list=model.data;
          mlist=list;

        }else{
          showErrorBottomSheet(value.message);
        }
      });


    });
  }

  appBarUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "Level Details", fontSize: 16),
    );
  }
}
