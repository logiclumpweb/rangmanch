import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/app_controller.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../controllers/ar_gear_controller.dart';
import 'package:collection/collection.dart';

class SelectCategoryView extends StatelessWidget {
  SelectCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: ArGearController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    controller.isPlaying.value ? SizedBox() : SizedBox(),
                    const Text(
                      'Choose the best category for your video',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'You can choose upto 3 categories as per the content of your video',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ),
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      children: controller.categories.mapIndexed((index, e) {
                        return GestureDetector(
                          onTap: () {
                            if (controller.selectedCategory.contains(e)) {
                              controller.selectedCategory.remove(e);
                            } else {
                              if (controller.selectedCategory.length < 3) {
                                controller.selectedCategory.add(e);
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            // padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      e.image,
                                    ),
                                    fit: BoxFit.cover)),
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.black54,
                                ),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    e.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                )),
                                Obx(() {
                                  var data = controller.selectedCategory
                                      .where((element) =>
                                          element.tblVideoCategoryId ==
                                          e.tblVideoCategoryId)
                                      .toList();
                                  bool isSelected = data.isNotEmpty;
                                  return isSelected
                                      ? const Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ))
                                      : const SizedBox();
                                })
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                    Obx(() => controller.isUploading.value
                            ? GradientButton1(
                                    text: "Uploading video", onPressed: () {})
                                .paddingAll(10)
                            : GradientButton1(
                                    text:
                                        "Done${controller.selectedCategory.isNotEmpty ? '(${controller.selectedCategory.length})' : ''}",
                                    onPressed: () {
                                      if (controller.selectedCategory.isEmpty) {
                                        EasyLoading.showToast(
                                            'Select Category');
                                        return;
                                      } else {
                                        // Get.dialog(
                                        //     const ProgressDialogManager(),
                                        //     barrierDismissible: false);
                                        //controller.compressVideo();
                                        Get.find<MyRestFulService>()
                                            .fUploadingReelAPI(
                                                controller.filePath.value,
                                                controller.tagController.text,
                                                controller.selectedLanguage
                                                    .value!.tblLanguageId);
                                        Get.offAndToNamed(Routes.S_A_DASHBOARD);
                                        Get.find<SADashboardController>()
                                            .bottomIndex
                                            .value = 0;
                                      }
                                    })
                                .paddingAll(
                                    10) /*GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Obx(() => Center(
                                  child: Text(
                                      ))),
                            ),
                          )*/
                        )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
