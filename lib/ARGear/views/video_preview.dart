import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/ARGear/views/audio_trimmer.dart';
import 'package:champcash/ARGear/views/upload_view.dart';
import 'package:champcash/ARGear/views/use_songs.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/app/modules/SADashboard/views/VideoTrimmerScreen.dart';
import 'package:champcash/shared/extras.dart';
import 'package:champcash/shared/label_button.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:media_info/media_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatelessWidget {
  final String type;
  final double fTimer;
  VideoPreview({Key? key, required this.type, required this.fTimer})
      : super(key: key);

  final controller = Get.find<ArGearController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () {
            Get.delete<ArGearController>(force: true);
            Get.back();
            return Future.value(false);
          },
          child: Scaffold(
              body: SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                controller.isPlayingVal.value
                    ? SizedBox()
                    : FutureBuilder<Uint8List>(
                        future: controller.getVideoThumbnail(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Image.memory(snapshot.data!,
                                    fit: BoxFit.cover));
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                controller.isPlayingVal.value
                    ? CachedVideoPlayerScreen(
                        url: controller.filePath.value,
                        videoThumb: fTimer.toString(),
                      ) /*CachedVideoPlayer(cont.cachedVideoPlayerController!)*/
                    : SizedBox(),
                controller.isPlayingVal.value
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Container(
                            width: 72,
                            height: 72,
                            margin: const EdgeInsets.all(32),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.white54, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                          onTap: () {
                            controller.isPlayingVal.value = true;
                          },
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    onTap: () {
                      goToOtherPage();
                    },
                  ),
                ),
                if (type == "Gallery") useMusicButton() else SizedBox(),

                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                          onPressed: () {
                            videoStatusUpdate.add(PAUSE);
                            Get.bottomSheet(
                                    VideoTrimmingView(
                                        File(controller.filePath.value)),
                                    isDismissible: false,
                                    isScrollControlled: true,
                                    enableDrag: true)
                                .then((value) {
                              if (value != null) {
                                print("OUTPPUTT$value");
                                controller.isPlayingVal.value = true;
                                controller.filePath.value = value;
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.cut,
                            size: 30,
                            color: ColorConstants.appPrimaryWhiteColor,
                          ))
                      .paddingOnly(left: type != "Gallery" ? 10 : 135, top: 46),
                )

                //type == "Gallery" ? mergeFileButton() : SizedBox()
              ],
            ),
          )),
        ));
  }

  useMusicButton() => Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            videoStatusUpdate.add(PAUSE);
            controller.isPlayingVal.value = false;
            Get.to(UseSongs())!.then((value) async {
              Get.bottomSheet(
                      AudioTrimmerView(File(controller.downloadedPath.value)),
                      enableDrag: true,
                      isScrollControlled: true,
                      isDismissible: false)
                  .then((value) {
                if (value != null) {
                  galleryVideoMergeWithAudio();
                }
              });
            });
          },
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      ColorConstants.appPrimaryColor,
                      ColorConstants.appPrimaryColor,
                      ColorConstants.appPrimaryColor,

                      // Color(0xffFE9B0E),
                      // Color(0xffEF840C),
                    ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addPadding(10, 0),
                Icon(
                  Icons.queue_music_outlined,
                  size: 16,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                ),
                addPadding(10, 0),
                headingText(
                        title: "Use Music",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff))
                    .paddingOnly(right: 10),
              ],
            ),
          ).paddingOnly(top: 40),
        ),
      ).paddingOnly(top: 10, left: 10);

  mergeFileButton() => Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 105,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xffFE9B0E),
                      Color(0xffFE9B0E),
                      Color(0xffFE9B0E)
                      // Color(0xffFE9B0E),
                      // Color(0xffEF840C),
                    ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addPadding(10, 0),
                Icon(
                  Icons.merge_outlined,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                ),
                addPadding(10, 0),
                headingText(
                        title: "Merge",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff))
                    .paddingOnly(right: 10),
              ],
            ),
          ).paddingOnly(top: 40),
        ),
      );

  void goToOtherPage() async {
    videoStatusUpdate.add(PAUSE);
    if (controller.selectedSong.value != null ||
        controller.selectAudioFile.value) {
      await File(controller.downloadedPath.value).delete(recursive: true);
    }
    controller.selectAudioFile.value = false;
    controller.selectedSong.value = null;
    Get.to(UploadView());
  }

  void galleryVideoMergeWithAudio() async {
    EasyLoading.show();
    final MediaInfo mediaInfo = MediaInfo();
    final Map<String, dynamic> h =
        await mediaInfo.getMediaInfo(controller.filePath.value);
    String durationVal = Duration(milliseconds: h["durationMs"]).toString();
    controller
        .mergeAudio(File(controller.filePath.value),
            File(controller.downloadedPath.value), durationVal, "")
        .then((value) {
      controller.isPlayingVal.value = true;
      controller.filePath.value = value;
      EasyLoading.dismiss();
    });
  }
}

class CachedVideoPlayerScreen extends StatefulWidget {
  final int index;
  final String url;
  final String videoThumb;
  final Function(int)? actions;
  final bool showProgress;
  final bool isFill;
  const CachedVideoPlayerScreen(
      {super.key,
      required this.url,
      this.actions,
      this.index = 0,
      this.showProgress = false,
      required this.videoThumb,
      this.isFill = true});

  @override
  _CachedVideoPlayerScreenState createState() =>
      _CachedVideoPlayerScreenState();
}

class _CachedVideoPlayerScreenState extends State<CachedVideoPlayerScreen> {
  //final appController = Get.find<AppController>();
  VideoPlayerController? _controller;
  Uint8List? uint8List;
  bool isPlaying = false;
  Size? size;

  @override
  void initState() {
    super.initState();
    print("FFFILLLE${widget.url}");
    _controller = VideoPlayerController.file(File(widget.url))
      ..initialize().then((_) {
        setState(() {
          _controller?.setLooping(true);
          _controller?.play();
          Size mSize = MediaQuery.of(context).size;
          Size sizeTemp =
              _controller?.value.size ?? MediaQuery.of(context).size;
          double width = sizeTemp.width;
          // double height = sizeTemp.height;
          double height = MediaQuery.of(context).size.height;

          double ratio = mSize.width / sizeTemp.width;
          width = mSize.width;
          height = widget.isFill ? height : sizeTemp.height * ratio;
          size = Size(width, height);
        });
      });

    videoStatusUpdate.stream.listen((event) {
      if (event == PAUSE) {
        try {
          if (_controller?.value.isInitialized ?? false) {
            _controller?.pause();
            widget.actions != null ? widget.actions!(1) : null;
          }
        } catch (e) {
          print(e.toString());
        }
      } else if (widget.index == event) {
        if (_controller?.value.isInitialized ?? false) {
          print("PLLLLLAYYY");
          _controller?.play();
        }
        isPlaying = true;
      } else {
        if (_controller?.value.isInitialized ?? false) {
          _controller?.pause();
        }
      }

      if (event == PLAY) {
        if (_controller?.value.isInitialized ?? false) {
          print("PLLLLLAYYY");
          _controller?.play();
        }
        isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose().then((value) => _controller = null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;
    // size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // if (widget.videoThumb.isNotEmpty)
        Container(
          color: ColorConstants.APPPRIMARYBLACKCOLOR,
        ),
        // CachedNetworkImage(
        //   imageUrl: widget.videoThumb,
        //   // Image.network(widget.videoThumb,
        //   placeholder: (context, url) => Center(
        //     child: Container(
        //       color: Colors.black,
        //       width: double.infinity,
        //       height: double.infinity,
        //       child: Padding(
        //         padding: const EdgeInsets.all(80.0),
        //         child: Image.asset("assets/logo.png"),
        //       ),
        //     ),
        //   ),
        //   errorWidget: (context, url, error) => Image.asset(
        //     "assets/logo.png",
        //     width: 0,
        //   ),
        //   // width: double.infinity, height: double.infinity,
        //   width: size!.width, height: size!.height,
        //   fit: BoxFit.fill,
        // ),
        Center(
          child: _controller?.value.isInitialized ?? false
              ? GestureDetector(
                  onTap: () {
                    if (_controller?.value.isPlaying ?? false) {
                      _controller?.pause();
                      widget.actions != null ? widget.actions!(1) : null;
                    } else {
                      _controller?.play();
                      widget.actions != null ? widget.actions!(0) : null;
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(
                      _controller!,
                    ),
                  ),
                )
              : loadingVideo(widget.showProgress),
        ),
      ],
    );
  }

  Widget loadingVideo(showProgress) => Align(
        alignment: Alignment.bottomCenter,
        child: showProgress
            ? const Center(child: CircularProgressIndicator())
            : const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                color: Colors.white,
                backgroundColor: Colors.white,
              ),
      );
}
