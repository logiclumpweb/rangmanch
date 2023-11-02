import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/models/PackageTransListModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageTransactionScreen extends StatefulWidget {
  const PackageTransactionScreen({super.key});

  @override
  State<PackageTransactionScreen> createState() =>
      _PackageTransactionScreenState();
}

class _PackageTransactionScreenState extends State<PackageTransactionScreen> {
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
        title: Text(
          "Transaction",
          style: textStyleW600(
              fontSize: 16, color: ColorConstants.APPPRIMARYWHITECOLOR),
        ),
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      ),
      body: FutureBuilder(
        future:
            getPackageTransactionAPIs({"user_id": userLoginModel!.data.userId}),
        builder: (BuildContext context, AsyncSnapshot<APIResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const GIFLaaderPage();
          }
          if (!snapshot.hasData || snapshot.data!.data == null) {
            return NoRecordFoundView();
          }
          PackageTrasListModel m = snapshot.data!.data;
          return ListView.builder(
              itemCount: m.data.length,
              itemBuilder: (c, pos) {
                PKGTRDatum pk = m.data.elementAt(pos);
                return SizedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Recharge",
                                    style: textStyleW600(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  SACellNSRoundContainer(
                                          color: pk.status == "Confirm"
                                              ? Colors.green
                                              : pk.status == "Rejected"
                                                  ? Colors.red
                                                  : Colors.grey
                                                      .withOpacity(0.80),
                                          width: 78,
                                          height: 22,
                                          child: Center(
                                            child: Text(
                                              "${pk.status}",
                                              style: textStyleW600(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          radius: 6,
                                          borderWidth: 0,
                                          borderWidthColor: Colors.black12)
                                      .paddingOnly(left: 8)
                                ],
                              ).paddingOnly(top: 7),
                              Text(
                                pk.createdDate.toString(),
                                style: textStyleW600(
                                    fontSize: 13,
                                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                              ).paddingOnly(top: 7),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.diamond,
                            color: Colors.amber,
                            size: 19,
                          ),
                          addPadding(2, 0),
                          Text(
                            pk.amount,
                            style: textStyleW500(
                                fontSize: 18,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                          ),
                        ],
                      ).paddingOnly(left: 15, right: 12, top: 8),
                      Divider(
                        color: ColorConstants.appPrimaryColor,
                      ).paddingAll(12)
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
