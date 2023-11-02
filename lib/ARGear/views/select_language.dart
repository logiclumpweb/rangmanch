import 'package:champcash/ARGear/views/select_category.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ar_gear_controller.dart';

class SelectLanguageView extends StatelessWidget {
  const SelectLanguageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      body: GetX(
          init: ArGearController(),
          builder: (controller) {
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    controller.isPlaying.value ? SizedBox() : SizedBox(),
                    addPadding(0, 15),
                    Image.asset(
                      'assets/logo.png',
                      width: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Choose the language of your video',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: 3,
                      children: controller.languages
                          .map((e) => Obx(() => GestureDetector(
                                onTap: () {
                                  controller.selectedLanguage.value = e;
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: e.tblLanguageId ==
                                              controller.selectedLanguage.value
                                                  ?.tblLanguageId
                                          ? ColorConstants.APPPRIMARYWHITECOLOR
                                          : null,
                                      border: Border.all(
                                          color: ColorConstants
                                              .APPPRIMARYWHITECOLOR),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                      child: Text(
                                    e.name,
                                    style: textStyleW500(
                                        color: e.tblLanguageId ==
                                                controller.selectedLanguage
                                                    .value?.tblLanguageId
                                            ? ColorConstants
                                                .APPPRIMARYBLACKCOLOR
                                            : ColorConstants
                                                .APPPRIMARYWHITECOLOR),
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              )))
                          .toList(),
                    )),
                    GradientButton1(
                        text: "Continue",
                        onPressed: () {
                          Get.to(() => SelectCategoryView());
                        }).paddingAll(5)
                  ],
                ),
              ),
            );
          }),
    );
  }
}
