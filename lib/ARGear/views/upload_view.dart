import 'package:cached_video_player/cached_video_player.dart';
import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'select_language.dart';

class UploadView extends StatelessWidget {
  final CachedVideoPlayerController? cacheController;
  UploadView({Key? key, this.cacheController}) : super(key: key);
  final controller = Get.find<ArGearController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double h = size.height / 3;
    double w = size.width / 2.5;

    return Obx(() => Scaffold(
          backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
          appBar: AppBar(
            title: const Text('Create Your Video'),
            backgroundColor: ColorConstants.APPPRIMARYCOLOR,
            elevation: 0,
          ),
          body: Stack(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          controller.isPlaying.value ? SizedBox() : SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                              //   margin: const EdgeInsets.all(8),
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  color: ColorConstants.APPPRIMARYGREYCOLOR
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                style: textStyleW500(
                                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                                controller: controller.tagController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (val) {},
                                decoration: InputDecoration(
                                    fillColor: ColorConstants
                                        .APPPRIMARYGREYCOLOR
                                        .withOpacity(0.15),
                                    border: InputBorder.none,
                                    // enabled: false,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        controller.tagController.text = '';
                                      },
                                      child: const Icon(
                                        Icons.cancel_outlined,
                                        color:
                                            ColorConstants.appPrimaryWhiteColor,
                                      ),
                                    )
                                    // suffix: IconButton(onPressed: (){
                                    //   controller.tagController.text = '';
                                    // }, icon: const Icon(Icons.cancel_outlined)),
                                    ),
                              )),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Suggested Tags',
                              style: TextStyle(
                                  color: ColorConstants.appPrimaryWhiteColor),
                            ),
                          ),
                          Wrap(
                            children: controller.tags
                                .map<Widget>((e) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                          child: Chip(
                                            backgroundColor: ColorConstants
                                                .APPPRIMARYGREYCOLOR
                                                .withOpacity(0.15),
                                            label: Text(
                                              '#${e.capitalizeFirst}',
                                              style: GoogleFonts.urbanist(),
                                            ),

                                            // backgroundColor: controller.tagController.text.contains(e)?Colors.orange:null,
                                          ),
                                          onTap: () {
                                            String text =
                                                controller.tagController.text;
                                            if (!text.contains(e)) {
                                              text += ' #${e.capitalizeFirst}';
                                              controller.tagController.text =
                                                  text;
                                            }
                                          }),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    ),
                    GradientButton1(
                        text: "Create Post",
                        onPressed: () {
                          if (controller.tagController.text.isNotEmpty) {
                            Get.to(() => const SelectLanguageView());
                          } else {
                            showErrorBottomSheet(
                                "Please select at least one tag");
                          }
                        }).paddingAll(8)
                  ],
                ),
              ),
              controller.isVideoCompressing.value
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      color: Colors.black45,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            // mainAxisSize: MainAxisSize.min,
                            alignment: Alignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.width / 5,
                                child: CircularProgressIndicator(
                                  value: controller.uploadProgress.value / 100,
                                  color: Colors.orangeAccent,
                                  backgroundColor: Colors.black12,
                                  strokeWidth: 16,
                                ),
                              ),
                              // const SizedBox(height: 16),
                              Text(
                                '${controller.uploadProgress.toStringAsFixed(0)}%',
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),

                      /*  child: StreamBuilder(
                stream: controller.lightCompressor.onProgressUpdated,
                builder: (context, AsyncSnapshot<dynamic> snapshot){

              if(!snapshot.hasData)return const SizedBox();
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.width/3,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    // mainAxisSize: MainAxisSize.min,
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width/5,
                        height: MediaQuery.of(context).size.width/5,
                        child: CircularProgressIndicator(
                          value: snapshot.data / 100,
                          color: Colors.orangeAccent,
                          backgroundColor: Colors.black12,
                          strokeWidth: 16,
                        ),
                      ),
                      // const SizedBox(height: 16),
                      Text(
                        '${snapshot.data.toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              );
            }),*/
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }
}
