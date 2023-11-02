import 'dart:io';

import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/ARGear/views/upload_view.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';
//import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimmerScreen extends GetView<ArGearController> {
  const VideoTrimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Expanded(child: VideoViewer(trimmer: controller.trimmer.value)),
              // TrimViewer(
              //   trimmer: controller.trimmer.value,
              //   viewerHeight: 50,
              //   viewerWidth: MediaQuery.of(context).size.width,
              //   maxVideoLength: const Duration(seconds: 15),
              //   onChangeStart: (val) => controller.startVal.value = val,
              //   onChangeEnd: (val1) => controller.endVal.value = val1,
              //   onChangePlaybackState: (value) {
              //     controller.isPlayingTrimmerVideo.value = value;
              //   },
              // ).paddingOnly(top: 15),
              Center(
                child: Container(
                  height: 150,
                  child: TextButton(
                    child: controller.isPlayingTrimmerVideo.value
                        ? const Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                    onPressed: () async {
                      // bool playbackState =
                      //     await controller.trimmer.value.videoPlaybackControl(
                      //   startValue: controller.startVal.value,
                      //   endValue: controller.endVal.value,
                      // );

                      // controller.isPlayingTrimmerVideo.value = playbackState;
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Container(
                    width: 72,
                    height: 72,
                    margin: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white54, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                  onTap: () {
                    videoStatusUpdate.add(PAUSE);
                    controller.saveTrimmingVideo();
                  },
                ),
              ),
              /* Container(
                height: 50,
                padding: EdgeInsets.all(20),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class VideoTrimmingView extends StatefulWidget {
  final File file;

  const VideoTrimmingView(this.file, {super.key});

  @override
  _VideoTrimmingViewState createState() => _VideoTrimmingViewState();
}

class _VideoTrimmingViewState extends State<VideoTrimmingView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  final controller = Get.find<ArGearController>();
  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });
    await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (String? outputPath) async {
          File f = File(outputPath!);
          var filename =
              "${DateTime.now().millisecondsSinceEpoch.toString()}.mp4"; //Uri.parse(url).pathSegments.last;
          final directory = await getExternalStorageDirectory();
          File fileDef = File('${directory!.path}/$filename');
          await fileDef.create(recursive: true);
          Uint8List bytes = await f.readAsBytes();
          await fileDef.writeAsBytes(bytes);

          _progressVisibility = false;
          setState(() {});
          Get.back(result: fileDef.path);
        });
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 22,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                        )),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        controller.isPlayingVal.value = false;
                        _saveVideo();
                      },
                      child: Text(
                        "Done",
                        style: textStyleW700(
                            fontSize: 20,
                            color: ColorConstants.APPPRIMARYWHITECOLOR),
                      ),
                    )
                  ],
                ).paddingOnly(left: 15, right: 15, top: 30),
                Visibility(
                  visible: _progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                /*  ElevatedButton(
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          _saveVideo().then((outputPath) {
                            print('OUTPUT PATH: $outputPath');
                            const snackBar = SnackBar(
                                content: Text('Video Saved successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );
                          });
                        },
                  child: Text("SAVE"),
                ),*/
                Expanded(
                  child: SizedBox(
                      width: double.infinity,
                      child: VideoViewer(trimmer: _trimmer)),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 36.0,
                          color: ColorConstants.APPPRIMARYWHITECOLOR
                              .withOpacity(0.80),
                        ),
                        onPressed: () async {
                          bool playbackState =
                              await _trimmer.videoPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                    ),
                    TrimViewer(
                      trimmer: _trimmer,
                      viewerHeight: 50.0,
                      viewerWidth: MediaQuery.of(context).size.width / 1.3,
                      maxVideoLength: const Duration(seconds: 10),
                      onChangeStart: (value) => _startValue = value,
                      onChangeEnd: (value) => _endValue = value,
                      onChangePlaybackState: (value) =>
                          setState(() => _isPlaying = value),
                    ).paddingOnly(bottom: 20, right: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
