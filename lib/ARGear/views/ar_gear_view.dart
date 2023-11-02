
import 'package:champcash/ARGear/views/use_songs.dart';
import 'package:champcash/models/common_models.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../Routes/AppRoutes.dart';
import '../../app/modules/SADashboard/views/s_a_dashboard_view.dart';
import '../config.dart';
import '../controllers/ar_gear_controller.dart';

class ArGearView1 extends GetView<ArGearController> {
  const ArGearView1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.clearValues();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
            ),

            // ARGearView(
            //     onArGearViewCreated: controller.onArGearViewCreated,
            //     apiUrl: Config.apiUrl,
            //     apiKey: Config.apiKey,
            //     secretKey: Config.secretKey,
            //     authKey: Config.authKey,
            //     onCallback: controller.onCallback,
            //     onPre: controller.onPre,
            //     onComplete: controller.onComplete),

            //  useMusicView(context),

            Obx(() => controller.isRecording.value
                ? const SizedBox()
                : camFilterOptionListWidget()),
            Obx(() => controller.decorWidget.value == null
                ? controller.isRecording.value
                    ? runningRecordingWidget()
                    : actionCameraWidget()
                : (controller.decorWidget.value ?? const SizedBox())),

            // bulges()

            Obx(() => LinearProgressIndicator(
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  value: controller.playerProgress.value,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
                )),
            ClipOval(
              child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.S_A_DASHBOARD);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    size: 35,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                  )).paddingOnly(top: 20),
            ),
          ],
        ),
      ),
    );
  }

  useMusicView(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 24,
          ),
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 30,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/ic_music.png',
                    width: 24,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Obx(() => Text(
                      (controller.selectedSong.value?.soundName ?? 'Use Music')
                          .characters
                          .take(15)
                          .toString()))
                ],
              ),
            ),
            onTap: () {
              Get.to(() => UseSongs());
            },
          ),
          IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.cancel,
                size: 40,
                color: Colors.white,
              ))
        ],
      );

  camFilterOptionListWidget() => Positioned(
      top: 90,
      right: 8,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(controller.decorList.length, (index) {
          DecorItem item = controller.decorList.elementAt(index);
          return GestureDetector(
            child: Column(
              children: [
                Image.asset(
                  'assets/${item.icon}.png',
                  width: 30,
                ).paddingAll(4),
                Text(
                  item.title,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 12,
                )
              ],
            ),
            onTap: () {
              controller.onSelectDecor(index);
            },
          );
        }),
      ));

  actionCameraWidget() => Positioned(
        bottom: 16,
        left: 8,
        right: 0,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    controller.motionList.length,
                    (index) => Obx(() => ElevatedButton(
                          onPressed: () {
                            controller.selectedMotionIndex.value = index;
                            // controller.arGearController?.setVideoBitrate(ARGVideoBitrate.)
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  controller.selectedMotionIndex.value == index
                                      ? Colors.white
                                      : Colors.transparent),
                              elevation: MaterialStateProperty.all(0)),
                          child: Text(
                            controller.motionList.elementAt(index),
                            style: TextStyle(
                                color: controller.selectedMotionIndex.value ==
                                        index
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ))),
              ),
            ),
            addPadding(0, 16),
            // const Chip(label: Text('0.00')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                IconButton(
                    onPressed: () {
                      controller.uploadFromLocal();
                    },
                    icon: Image.asset(
                      'assets/gallery.png',
                    )),
                GestureDetector(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                            color: Colors.white70, shape: BoxShape.circle),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (controller.selectedSong != null) {
                      controller.player
                          .setUrl(controller.selectedSong.value?.sound ?? '')
                          .then((value) {
                        controller.player.play();
                      });
                    }
                    controller.startRecording();
                  },
                ),
                IconButton(
                    onPressed: () {
                     // controller.arGearController.value.changeCameraFacing();
                    },
                    icon: Image.asset(
                      'assets/flip.png',
                    )),
                const SizedBox(),
              ],
            )
          ],
        ),
      );

  runningRecordingWidget() => Positioned(
        bottom: 16,
        left: 8,
        right: 8,
        child: Column(
          children: [
            if (controller.selectedSong.value == null)
              Chip(
                  label: Obx(() => Text(controller.recordingTime.value > 9
                      ? '0:${controller.recordingTime.value}'
                      : '0:0${controller.recordingTime.value}')))
            else
              Chip(
                  label: Obx(() => Text(controller.playerDuration.value > 9
                      ? '0:${controller.playerDuration.value}'
                      : '0:0${controller.playerDuration.value}'))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                GestureDetector(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                            color: Colors.white70, shape: BoxShape.circle),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  onTap: () {
                    controller.stopRecording();
                  },
                ),
                const SizedBox(),
              ],
            )
          ],
        ),
      );
}
