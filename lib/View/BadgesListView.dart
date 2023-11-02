import 'package:champcash/Apis/api.dart';
import 'package:champcash/models/BadgesModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ionicons/ionicons.dart';

import '../Data/UserData.dart';
import '../shared/extras.dart';
import '../Apis/urls.dart';

class BadgesListView extends StatefulWidget {
  const BadgesListView({Key? key}) : super(key: key);

  @override
  State<BadgesListView> createState() => _BadgesListViewState();
}

class _BadgesListViewState extends State<BadgesListView> {

 List<BadgesDatum>mbadgesList=<BadgesDatum>[];


  @override
  Widget build(BuildContext context) {
    return SACellGradientContainer(
        width: double.infinity,
        child: SafeArea(
            child:Column(children: [

              addPadding(0, 10),
              iAPPBARUI(),
              addPadding(0, 15),

              Expanded(
                  child: SACellUperRoundContainer(width:double.infinity,child:
                  mbadgesList.isEmpty?notFavoritesFound():SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [

                      addPadding(0, 30),
                      Row(
                        children: [
                          addPadding(15, 0),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 174,
                                        child: Image.asset(mbadgesList.first.batchesImage),
                                      ),
                                      addPadding(0, 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: headingText(title: mbadgesList.first.batchesName,fontSize: 12,fontWeight: FontWeight.w500,
                                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                          ),
                                          headingText(title: "${mbadgesList.first.noOfLike}/-",fontSize: 12,fontWeight: FontWeight.w700,
                                              color: Color(0xff3E57B4)),
                                          addPadding(5, 0),

                                        ],),
                                      headingLongText(title: mbadgesList.first.noOfFollower,fontSize: 9,fontWeight: FontWeight.w300,
                                          color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                      addPadding(0, 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: headingLongText(title: mbadgesList.first.noOfOud,fontSize: 8,fontWeight: FontWeight.w400,
                                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              width: 60,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  gradient: const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Color(0xff5AB439),
                                                        Color(0xff67BB40),
                                                        Color(0xff8BCF52),
                                                        Color(0xffB5E668),
                                                      ]
                                                  )
                                              ),
                                              child: Center(
                                                child: headingText(title: "Bid",fontSize: 8,fontWeight: FontWeight.w500,
                                                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: 25,width: 25,
                                        child: CircleAvatar(
                                            radius: 60,backgroundColor: ColorConstants.APPPRIMARYWHITECOLOR,foregroundColor: ColorConstants.APPPRIMARYWHITECOLOR,
                                            child: const Icon(Ionicons.arrow_redo_outline,size: 16,color: ColorConstants.APPPRIMARYBLACKCOLOR,)),
                                      ),
                                    )),
                                Positioned(
                                    right: 70,
                                    top: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: 25,width: 25,
                                        child:  Icon(Icons.play_circle_outline,size: 24,color:ColorConstants.APPPRIMARYWHITECOLOR,),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          addPadding(5, 0),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 174,
                                        child: Image.asset(mbadgesList.first.batchesImage),
                                      ),
                                      addPadding(0, 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: headingText(title: Image.asset(mbadgesList.first.batchesName),fontSize: 12,fontWeight: FontWeight.w500,
                                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                          ),
                                          headingText(title: "${mbadgesList.first.noOfLike}/-",fontSize: 12,fontWeight: FontWeight.w700,
                                              color: Color(0xff3E57B4)),
                                          addPadding(5, 0),

                                        ],),
                                      headingLongText(title: mbadgesList.first.noOfFollower,fontSize: 9,fontWeight: FontWeight.w300,
                                          color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                      addPadding(0, 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: headingLongText(title: mbadgesList.first.noOfOud,fontSize: 8,fontWeight: FontWeight.w400,
                                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              width: 60,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  gradient: const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Color(0xff5AB439),
                                                        Color(0xff67BB40),
                                                        Color(0xff8BCF52),
                                                        Color(0xffB5E668),
                                                      ]
                                                  )
                                              ),
                                              child: Center(
                                                child: headingText(title: "Bid",fontSize: 8,fontWeight: FontWeight.w500,
                                                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: 25,width: 25,
                                        child: CircleAvatar(
                                            radius: 60,backgroundColor: ColorConstants.APPPRIMARYWHITECOLOR,foregroundColor: ColorConstants.APPPRIMARYWHITECOLOR,
                                            child: const Icon(Ionicons.arrow_redo_outline,size: 16,color: ColorConstants.APPPRIMARYBLACKCOLOR,)),
                                      ),
                                    )),
                                Positioned(
                                    right: 70,
                                    top: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: 25,width: 25,
                                        child:  Icon(Icons.play_circle_outline,size: 24,color:ColorConstants.APPPRIMARYWHITECOLOR,),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          addPadding(15, 0),
                        ],
                      ),
                      addPadding(0, 20),


                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: GridView.builder(itemCount: mbadgesList.first.noOfLike.length,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,mainAxisExtent: 200
                        ), itemBuilder: (_,index){
                          BadgesDatum mDatum=mbadgesList.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 125,
                                        child: Image.asset(mbadgesList.first.batchesImage),
                                      ),
                                      addPadding(0, 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: headingLongText(title: mbadgesList.first.batchesName,fontSize: 8,fontWeight: FontWeight.w500,
                                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                          ),

                                          headingText(title: "${mbadgesList.first.noOfOud}/-",fontSize: 8,fontWeight: FontWeight.w700,
                                              color: Color(0xff3E57B4)),
                                          addPadding(5, 0),

                                        ],),
                                      headingLongText(title:mbadgesList.first.noOfFollower,fontSize: 7,fontWeight: FontWeight.w300,
                                          color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                      addPadding(0, 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: headingLongText(title: mbadgesList.first.noOfLike,fontSize: 6,fontWeight: FontWeight.w400,
                                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              width: 35,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  gradient: const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Color(0xff5AB439),
                                                        Color(0xff67BB40),
                                                        Color(0xff8BCF52),
                                                        Color(0xffB5E668),
                                                      ]
                                                  )
                                              ),
                                              child: Center(
                                                child: headingText(title: "Bid",fontSize: 8,fontWeight: FontWeight.w500,
                                                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: 25,width: 25,
                                        child: CircleAvatar(
                                            radius: 60,backgroundColor: ColorConstants.APPPRIMARYWHITECOLOR,foregroundColor: ColorConstants.APPPRIMARYWHITECOLOR,
                                            child: const Icon(Ionicons.arrow_redo_outline,size: 16,color: ColorConstants.APPPRIMARYBLACKCOLOR,)),
                                      ),
                                    )),
                                Positioned(
                                    right: 40,
                                    top: 45,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: 25,width: 25,
                                        child:  Icon(Icons.play_circle_outline,size: 24,color:ColorConstants.APPPRIMARYWHITECOLOR,),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        }),)





                    ]),
                  )))

            ])));
  }

  iAPPBARUI() {
    return Row(
      children: [
        SABackButton(onPressed: (){}, color: ColorConstants.APPPRIMARYWHITECOLOR),
        addPadding(105, 0),
        headingText(
            title: "My Favorites",
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            fontWeight: FontWeight.w500,
            fontSize: 20),
        const Spacer(),
      ],
    );
  }
  notFavoritesFound(){
    return Column(children: [
      addPadding(0, 40),
      Image.asset(noFavoritesItemImg,
        height: 250,width: 150,
      ),
      addPadding(0, 20),
      headingText(title: "You haven’t liked anything yet",fontWeight: FontWeight.w600,fontSize: 16,color: Color(0xff3E57B4)),
      addPadding(0, 20),
      headingText(title: "Collect all the things you like in one place",fontWeight: FontWeight.w300,fontSize: 12,
          color: ColorConstants.APPPRIMARYBLACKCOLOR),
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: GradientButton1(text: "DISCOVER", onPressed: (){}),
      )
    ],);
  }


  void myFavoritesAPIs() {


    getBadgesListApi().then((value){
      if(value.status){
        BadgesListModel model=value.data;
        List<BadgesDatum>list=model.data;
        mbadgesList=list;
        print(mbadgesList.length);

      }else{

      }
    });
  }
}