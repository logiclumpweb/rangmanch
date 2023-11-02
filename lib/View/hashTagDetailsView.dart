import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../app/modules/SADashboard/controllers/SAHashTagDetailController.dart';
import '../app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import '../app/modules/SADashboard/controllers/s_a_hash_controller.dart';
import '../app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import '../app/modules/SADashboard/views/SAHashTagVideoPlayer.dart';

class hasgtagView extends GetView<SAhashtagDetailController> {
  hasgtagView({
    Key? key,
  }) : super(key: key);
  SADashboardController dashBoardController = Get.find<SADashboardController>();
  SAhashtagController dbController = Get.find<SAhashtagController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        /* appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, size: 25),
              Container(
                width: 45,
              ),
              Expanded(
                child: Text(
                  "Manish Negi S/O Pratap Singh Rajput",maxLines: 1,
                  style: TextStyle(fontSize: 20,overflow: TextOverflow.ellipsis),
                ),
              ),
              Icon(
                Icons.cabin_rounded,
                size: 24,
              ),
              Icon(
                Icons.cabin_rounded,
                size: 24,
              ),
              Icon(
                Icons.cabin_rounded,
                size: 24,
              )
            ],
          ),
        ),*/
        body: SafeArea(
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 45,
                      child: headingText(
                          title: "#${controller.args[0]["hashTagName"]}"
                              .toUpperCase(),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.APPPRIMARYWHITECOLOR),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 15),
                        itemCount: controller.tagVideosList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 185),
                        itemBuilder: (_, inx) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 8.0,
                                        offset: Offset(2, 2),
                                        spreadRadius: 1)
                                  ]),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(SAHashTagVideoPlayerView(
                                        index: inx,
                                        hashTagList:
                                            controller.tagVideosList.value));
                                    // print("KKKKKK");
                                    // dashBoardController.updateBottomIndex(3);
                                    // Get.find<ProfileController>().onInit1(
                                    //     controller.tagVideosList.value[inx].userId);
                                  },
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: ImageViewCovered(
                                            photoUrl: controller.tagVideosList
                                                .value[inx].videoThumb,
                                          ),
                                        ),
                                      ),
                                      /* Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  color: Color(0xd3f2f2f2),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(5.0),
                                    child: headingLongText(
                                        title: controller.tagVideosList.value[inx]
                                            .videoName,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w600,
                                        color: Colors.black,
                                        align: TextAlign.center),
                                  ),
                                ))*/
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
