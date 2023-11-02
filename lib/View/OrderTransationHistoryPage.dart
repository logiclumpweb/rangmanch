import 'package:champcash/Apis/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Apis/api.dart';
import '../Data/UserData.dart';
import '../shared/extras.dart';
import '../models/INRWalletHistoryListModel.dart';
import '../models/OUDWalletHistoryListModel.dart';
import '../models/WalletDetailsViewModel.dart';

class OrderTransationHistoryPage extends StatefulWidget {
  const OrderTransationHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderTransationHistoryPage> createState() =>
      _OrderTransationHistoryPageState();
}

class _OrderTransationHistoryPageState
    extends State<OrderTransationHistoryPage> {
  dynamic walletAmount = "0", inr_WalletAmount = "0";
  var ratingValue = 5.0, pageIndex = 0, OTPCode = "";

  PageController _controller = PageController();
  var editWithdrawalAmountController = TextEditingController();
  List<OUDHistoryDatum> mOUDlist = <OUDHistoryDatum>[];
  List<INRWaletDatum> mINRlist = <INRWaletDatum>[];
  List<WalletDetailsViewModel> mlist = <WalletDetailsViewModel>[];

  @override
  void initState() {
    super.initState();
    getOUDHistoryData();
    getWalletData();
    getINRHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarUI(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorConstants.APPPRIMARYCOLOR,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 3,
                          color: Colors.grey.withOpacity(0.5))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText(
                                title: "BALANCE INR",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                            headingText(
                                title: inr_WalletAmount.toString(),
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                            addPadding(40, 0),
                            Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                                  borderRadius: BorderRadius.circular(4)),
                              height: 25,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => openWithdrawalDilough(context),
                                  child: headingText(
                                      title: "Withdrawal".toUpperCase(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: ColorConstants.APPPRIMARYCOLOR),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText(
                                title: "BALANCE OUD",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                            headingText(
                                title: walletAmount.toString(),
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                            addPadding(40, 0),
                            GestureDetector(
                              onTap: () {
                                withdrawalRequestOUD(context);
                              },
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    color: ColorConstants.APPPRIMARYWHITECOLOR,
                                    borderRadius: BorderRadius.circular(4)),
                                height: 25,
                                child: Center(
                                  child: headingText(
                                      title: "Withdrawal".toUpperCase(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: ColorConstants.APPPRIMARYCOLOR),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            addPadding(15, 0),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: GestureDetector(
                    child: _createItem(pageIndex == 0, 'OUD'),
                    onTap: () {
                      pageIndex = 0;
                      _controller.jumpToPage(pageIndex);
                    },
                  )),
                  Expanded(
                      child: GestureDetector(
                    child: _createItem(pageIndex == 1, 'INR'),
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

  appBarUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "My Wallet", fontSize: 16),
    );
  }

  INRHistoryPage() {
    return mINRlist.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: mINRlist.length,
            itemBuilder: (ctx, i) {
              return Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18.0, top: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingText(
                              title: mINRlist[i].amountType,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.APPPRIMARYBLACKCOLOR),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              headingText(
                                  title: mINRlist[i].trasectionType == "credit"
                                      ? "+"
                                      : "-",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: mINRlist[i].trasectionType == "credit"
                                      ? Colors.green
                                      : Colors.red),
                              headingText(
                                  title: mINRlist[i].amount.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            ],
                          ),
                          headingText(
                              title: mINRlist[i].trasectionDate,
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.APPPRIMARYGREYCOLOR)
                        ],
                      ),
                    ],
                  ));
            })
        : Center(child: CircularProgressIndicator());
  }

  OUDHistoryPage(BuildContext context) {
    return mOUDlist.isNotEmpty
        ? Column(
            children: [
              addPadding(10, 0),
              Container(
                height: 410,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: mOUDlist.length,
                    itemBuilder: (ctx, y) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 15),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headingText(
                                      title: mOUDlist[y].amountType,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          ColorConstants.APPPRIMARYBLACKCOLOR),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      headingText(
                                          title: mOUDlist[y].trasectionType ==
                                                  "credit"
                                              ? "+"
                                              : "-",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: mOUDlist[y].trasectionType ==
                                                  "credit"
                                              ? Colors.green
                                              : Colors.red),
                                      headingText(
                                          title: mOUDlist[y].amount.toString(),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green),
                                    ],
                                  ),
                                  headingText(
                                      title:
                                          mOUDlist[y].trasectionDate.toString(),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.APPPRIMARYGREYCOLOR)
                                ],
                              ),
                            ],
                          ));
                    }),
              )
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  void getOUDHistoryData() {
    var hashMap = {
      "user_id": userLoginModel?.data.userId,
    };
    print(hashMap);
    OUDWalletHistory(hashMap).then((value) {
      setState(() {
        if (value.status) {
          OudWalletHistoryListModel model = value.data;
          List<OUDHistoryDatum> list = model.data;
          mOUDlist = list;
        }
      });
    });
  }

  void getINRHistoryData() {
    var hashMap = {
      "user_id": userLoginModel?.data.userId,
    };
    print(hashMap);
    INRWalletHistory(hashMap).then((value) {
      setState(() {
        if (value.status) {
          InrWalletHistoryListModel model = value.data;
          List<INRWaletDatum> list = model.data;
          mINRlist = list;
        }
      });
    });
  }

  void getWalletData() {
    var hashMap = {
      "user_id": userLoginModel?.data.userId,
    };
    print(hashMap);
    WalletDetails(hashMap).then((value) {
      setState(() {
        if (value.status) {
          walletAmount = value.data["wallet_amt"];
          inr_WalletAmount = value.data["inr_wallet"];

          print(walletAmount);
        }
      });
    });
  }

  withdrawalRequestOUD(BuildContext context) {
    showGeneralDialog(
        barrierDismissible: false,
        context: context,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SACellRoundContainer(
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Image.asset(
                                cancelIconUrl,
                                height: 18,
                                width: 18,
                                color: ColorConstants.APPPRIMARYWHITECOLOR,
                              )),
                          radius: 30,
                          borderWidth: 0,
                          borderWidthColor: Colors.transparent,
                          color: ColorConstants.APPPRIMARYBLACKCOLOR),
                    ),
                    Container(
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      height: 220.0,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          children: [
                            addPadding(15, 0),
                            headingFullText(
                                title:
                                    "Thank you for showing interest in \n “Akhand-Ramayan-Paath”.",
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                align: TextAlign.center,
                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                            addPadding(25, 0),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, right: 25),
                              child: headingLongText(
                                  title:
                                      "We recommend you to speak to the Pandit before booking a Puja.",
                                  fontWeight: FontWeight.w500,
                                  align: TextAlign.center,
                                  fontSize: 15,
                                  color: ColorConstants.APPPRIMARYGREYCOLOR),
                            ),
                            addPadding(15, 0),
                            SizedBox(
                              height: 80,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 0,
                                          bottom: 20),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFA513),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(26.0),
                                            splashColor: Colors.black26,
                                            onTap: () {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "CALL PANDIT",
                                                    style: GoogleFonts.openSans(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 0,
                                          bottom: 20),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: ColorConstants.APPPRIMARYCOLOR,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(26.0),
                                            splashColor: Colors.black26,
                                            onTap: () {
                                              Get.back();
                                              //  bookPanditAnywaysUi();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "BOOK ANYWAYS",
                                                    style: GoogleFonts.openSans(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openWithdrawalDilough(BuildContext context) {
    showGeneralDialog(
        barrierDismissible: false,
        context: context,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SACellRoundContainer(
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: ColorConstants.APPPRIMARYCOLOR,
                              )),
                          radius: 30,
                          borderWidth: 0,
                          borderWidthColor: Colors.transparent,
                          color: ColorConstants.APPPRIMARYBLACKCOLOR),
                    ),
                    Container(
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      height: 220.0,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          children: [
                            addPadding(15, 15),
                            headingFullText(
                                title: "Enter Withdrawal Amount",
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                align: TextAlign.center,
                                color: ColorConstants.APPPRIMARYBLACKCOLOR),
                            addPadding(25, 15),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, right: 25),
                              child: headingLongText(
                                  title: "Minimum Withdrawal Amount 100/-",
                                  fontWeight: FontWeight.w500,
                                  align: TextAlign.center,
                                  fontSize: 15,
                                  color: ColorConstants.APPPRIMARYGREYCOLOR),
                            ),
                            addPadding(15, 0),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10, bottom: 20),
                              child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: ColorConstants.APPPRIMARYCOLOR),
                                    color: Color(0xffFFffff),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller:
                                          editWithdrawalAmountController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter amount",
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 0, bottom: 20),
                              child: Container(
                                width: 160,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFA513),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(26.0),
                                    splashColor: Colors.black26,
                                    onTap: () {},
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: GoogleFonts.openSans(
                                            color: Color(0xffffffff),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
