
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../Apis/api.dart';
import '../Data/UserData.dart';
import '../shared/extras.dart';
import '../models/INRWalletHistoryListModel.dart';
import '../models/OUDWalletHistoryListModel.dart';
import '../models/WithdrawalHistoryModel.dart';

class WithdrawalHistoryView extends StatefulWidget {
  const WithdrawalHistoryView({Key? key}) : super(key: key);

  @override
  State<WithdrawalHistoryView> createState() => _WithdrawalHistoryViewState();
}

class _WithdrawalHistoryViewState extends State<WithdrawalHistoryView> {

  var ratingValue = 5.0,pageIndex = 0,OTPCode="";
  String person="https://s3-alpha-sig.figma.com/img/d706/ff26/f78a6d662198309daf7150e7e869d726?Expires=1672012800&Signature=SJUbK3O6XHmMUjYgsRrSeEUhJoaGQOeDUPFH3NxLaCA~zBjzpc3EQC4DqyOxx3tXw7FGKsdfzWWKlVBmtwNtAbWNjxBX9lVaIdu4-S3w8OX7L3LhKUT8lxt904Drd8yTa6phhiNlNp~jJteYRvwi8EYUL8tHuS3FOUddrrU0K~0uCONdt4nxpi0b7r5clqzivWvAK7W~V3bzorxw26W2aJr~P0hjcWGH~fYP3eIGbM~YkMBEzqBklufD9VlRGpXzvbKchKkSI~MyLX~VI262Xh7ijyJCbYQrTUwxxOd6nInUueAOSa~5t~FLMR5yoiTtOWdK14Ucr93DphDJKr~LcQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4";
  String person1="https://s3-alpha-sig.figma.com/img/1ef8/5e51/324a1557b9fa02894db7915e47954499?Expires=1672012800&Signature=Hi2AiKp625FNYZlpV-PPBh82BP8yR6cR7n0Rvzo-y~KQW1Xo-CQXgdc0WSYr~vCbvbbiaYFg~UxFYo8AueQJCP0ukcrGCCUEhGo8QTnRbOktHN22wd8WjVtMzm6~CGd1gy8BPrwWwB~rthXfBfp0o~YSIt5zSEFwENDPqhKhhrauriQDIgvRUv2ImgOpgv2DZMWcARaRd0YWfHNXKsrpmlpDUKCNdqdPedWFO-y3UzAtsh1RqEIQTwpLYt~XWj4DAvQPM5ASS3pqQTKpaxbbUxvTiJKP5EGpbugZmh3NJYTE4Fve9XzK33Dp6EerW8rIh5-hsC8MagjlQs5JEUE1Fw__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4";

  PageController _controller = PageController();
  List<WHDatum>mlist=<WHDatum>[];


  @override
  void initState() {
    getOUDHistoryData();
    getINRHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: appBarUI(),
      body: SafeArea(
        child:Column(
          children: [

            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: GestureDetector(
                        child: _createItem(
                            pageIndex == 0, 'OUD'),
                        onTap: () {
                          pageIndex = 0;
                          _controller.jumpToPage(pageIndex);
                        },
                      )),
                  Expanded(
                      child: GestureDetector(
                        child: _createItem(
                            pageIndex == 1, 'INR'),
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

                        ? OUDHistoryPage(context)
                        : INRHistoryPage();
                  },
                  itemCount: 2,
                ))
          ],
        ),
      ),
    );
  }
  appBarUI() {
    return AppBar(backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "My Wallet", fontSize: 16),

    );
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
  INRHistoryPage() {
    return mlist.isNotEmpty? Column(
      children: [
        addPadding(10, 0),
        Padding(
          padding: const EdgeInsets.only(left:18.0,right: 18.0,top: 15),
          child: Column(
            children: [
              Container(height: 410,
                child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: mlist.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                          padding: const EdgeInsets.only(left:18.0,right: 18.0,top: 15),
                          child: Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingText(
                                    title: mlist[i].payoutStatus,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.APPPRIMARYBLACKCOLOR),

                              ],),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    headingText(
                                        title: mlist[i].remark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    headingText(
                                        title: mlist[i].amount.toString(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),

                                  ],
                                ),
                                headingText(
                                    title: mlist[i].createdDate.toString(),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.APPPRIMARYGREYCOLOR)
                              ],),
                          ],));

                    }), )

            ],
          ),
          ),
      ],
    ):Center(child: CircularProgressIndicator());
  }
  OUDHistoryPage(BuildContext context) {
    return mlist.isNotEmpty? Column(
      children: [
        addPadding(10, 0),
        Container(height: 410,
          child:ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: mlist.length,
              itemBuilder: (ctx, y) {
                return Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 18.0,top: 15),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingText(
                              title: mlist[y].payoutStatus,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.APPPRIMARYBLACKCOLOR),

                        ],),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              headingText(
                                  title: mlist[y].remark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                              headingText(
                                  title: mlist[y].amount,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),

                            ],
                          ),
                          headingText(
                              title: mlist[y].createdDate.toString(),
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.APPPRIMARYGREYCOLOR)
                        ],),
                    ],));

              }), )




      ],
    ):Center(child: CircularProgressIndicator());
  }

  void getOUDHistoryData() {
    var hashMap={
      "user_id":userLoginModel?.data.userId,
      "payout_type":"OUD wallet",

    };
    print(hashMap);
    withdrawal_history_list(hashMap).then((value) {
      setState(() {
        if(value.status){
          WithdrawalHistoryModel model=value.data;
          List<WHDatum>list=model.data;
          mlist=list;
        }
      });

    });
  }
  void getINRHistoryData() {
    var hashMap={
      "user_id":userLoginModel?.data.userId,
      "payout_type":"INR wallet",

    };
    print(hashMap);
    withdrawal_history_list(hashMap).then((value) {
      setState(() {
        if(value.status){
          WithdrawalHistoryModel model=value.data;
          List<WHDatum>list=model.data;
          mlist=list;
        }
      });

    });
  }
}
