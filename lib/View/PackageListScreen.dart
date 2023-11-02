import 'dart:io';

import 'package:champcash/Apis/api.dart';
import 'package:champcash/Apis/api/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/models/PackageListModel.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/cell_container.dart';
import 'package:champcash/shared/extras.dart';
import 'package:champcash/shared/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PackageListScreen extends StatelessWidget {
  const PackageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      appBar: AppBar(
        leading: SABackButton(
          onPressed: () {
            Get.back();
          },
          color: ColorConstants.APPPRIMARYWHITECOLOR,
        ),
        title: Text(
          "Package",
          style: textStyleW500(
              fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR),
        ),
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      ),
      body: Column(
        children: [
          totalTokensUI(),
          Expanded(
            child: FutureBuilder(
              future: packageListAPIs(),
              builder:
                  (BuildContext context, AsyncSnapshot<APIResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const GIFLaaderPage();
                }
                if (!snapshot.hasData) {
                  return NoRecordFoundView();
                }

                PackageListModel m = snapshot.data!.data;
                List<PKGDatum> packageModelList = m.data;
                return GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: packageModelList.length ?? 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisExtent: 130,
                            crossAxisCount: 3),
                    itemBuilder: (c, pos) {
                      PKGDatum m = packageModelList.elementAt(pos);
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              purchasePackageBottomSheet(
                                m,
                              );
                            },
                            child: Container(
                              height: 85,
                              width: 85,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff57b590),
                                        Color(0xff57b590).withOpacity(0.5),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.diamond,
                                    color: Colors.amber,
                                    size: 19,
                                  ),
                                  addPadding(0, 4),
                                  Text(
                                    m.tokens,
                                    style: textStyleW500(
                                        fontSize: 14,
                                        color: ColorConstants
                                            .APPPRIMARYWHITECOLOR),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "\u20B9${m.amount}.00",
                            style: textStyleW500(
                                fontSize: 17,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                          ).paddingOnly(top: 5)
                        ],
                      );
                    }).paddingOnly(left: 20, right: 20, top: 15);
              },
            ),
          ),
        ],
      ),
    );
  }

  totalTokensUI() => SizedBox(
        height: 70,
        width: double.infinity,
        child: Card(
          color: Colors.deepOrangeAccent,
          child: Row(
            children: [
              addPadding(10, 0),
              Text(
                "Total Tokens : ",
                style:
                    textStyleW500(color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
              Text(
                "${userProfileModel!.data.tokenWallet}.00",
                style: textStyleW500(
                    fontSize: 18, color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
              addPadding(2, 0),
              const Icon(
                Icons.diamond,
                color: Colors.amber,
                size: 19,
              ),
            ],
          ),
        ).paddingOnly(
          top: 10,
          bottom: 10,
          left: 22,
          right: 22,
        ),
      );

  void purchasePackageBottomSheet(PKGDatum m) {
    Get.bottomSheet(
        PurchasePackageScreen(
          model: m,
        ),
        isScrollControlled: true,
        isDismissible: true);
  }
}

class PurchasePackageScreen extends StatefulWidget {
  final PKGDatum model;
  const PurchasePackageScreen({super.key, required this.model});

  @override
  State<PurchasePackageScreen> createState() => _PurchasePackageScreenState();
}

class _PurchasePackageScreenState extends State<PurchasePackageScreen> {
  var editUserNameController = TextEditingController();
  File? file;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants.APPPRIMARYBLACKCOLOR,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12)),
          border: Border.all(
              width: 1,
              color: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15))),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Package Amount ${widget.model.amount}.00 INR",
              style:
                  textStyleW500(fontSize: 15, color: const Color(0xff57b590)),
            ).paddingAll(10),
            Text(
              "Scan or Copy the below UPI ID to Pay",
              style: textStyleW500(fontSize: 15, color: Colors.white),
            ).paddingAll(10),
            FutureBuilder(
              future: getQrCodeAPIAPI(),
              builder:
                  (BuildContext context, AsyncSnapshot<APIResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const GIFLaaderPage();
                }
                if (!snapshot.hasData) {
                  return NoRecordFoundView();
                }
                return Card(
                  color: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.08),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.APPPRIMARYWHITECOLOR,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        height: 200,
                        child: NetworkImageView(
                                fit: BoxFit.fitHeight,
                                imgUrl: snapshot.data!.data["qr_sacnner_image"])
                            .paddingAll(5),
                      ).paddingAll(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!.data["upid"],
                            style: textStyleW500(
                                fontSize: 15, color: Color(0xff57b590)),
                          ),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: snapshot.data!.data["upid"]));
                                toastMessage("UPI ID Copied");
                              },
                              icon: const Icon(
                                Icons.copy,
                                color: ColorConstants.appPrimaryWhiteColor,
                              ))
                        ],
                      ),
                    ],
                  ),
                ).paddingOnly(left: 20, right: 20);
              },
            ),
            TextButton(
              onPressed: () {
                ImagePicker.platform
                    .pickImage(source: ImageSource.gallery)
                    .then((value) {
                  setState(() {
                    file = File(value!.path);
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 3),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.red,
                  width: 1.0, // Underline thickness
                ))),
                child: Text(
                  "Upload your payment screenshot",
                  style: TextStyle(
                      color: ColorConstants.APPPRIMARYWHITECOLOR,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            file == null
                ? SizedBox()
                : SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.file(
                      File(file!.path),
                      fit: BoxFit.cover,
                    )),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: SATextField(
                hintText: "Enter Transaction ID",
                controller: editUserNameController,
                enabled: true,
              ),
            ),
            GradientButton1(
                text: "Submit",
                onPressed: () {
                  if (editUserNameController.text.isEmpty) {
                    return toastMessage("Please enter transaction Id");
                  }
                  if (file == null) {
                    return toastMessage("Please upload transaction screenshot");
                  }
                  paymentScreenShotAPI(widget.model, file).then((value) {
                    if (value.status) {
                      toastMessage(value.message);
                      file = null;
                      Get.back();
                    } else {
                      toastMessage(value.message);
                    }
                  });
                }).paddingAll(18)
          ],
        ),
      ),
    );
  }
}
