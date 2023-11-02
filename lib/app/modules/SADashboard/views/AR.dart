import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/ARGear/views/upload_view.dart';
import 'package:champcash/ARGear/views/use_songs.dart';
import 'package:champcash/ARGear/views/video_preview.dart';
import 'package:champcash/Data/Effects.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/app/modules/SADashboard/views/reelCreateScreen.dart';
import 'package:champcash/app_controller.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/extras.dart';

import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_info/media_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

const AndroidapiKey =
    "9510b712aff5eba5a22ea87c4edc5bf4e1ce88f690d33dc08672801eb333043ef819d69d23201d66";

class PlaybackVideoModel {
  late String value;
  late bool selected;
  late double time;
  PlaybackVideoModel(
      {required this.value, required this.selected, required this.time});
}

class VideoTimerModel {
  late String value;
  late bool selected;
  late String time;
  VideoTimerModel(
      {required this.value, required this.selected, required this.time});
}

class ARCameraRecordingScreen extends StatefulWidget {
  final String videoLink, tblVideoSoundId;
  const ARCameraRecordingScreen(
      {Key? key, required this.videoLink, required this.tblVideoSoundId})
      : super(key: key);

  @override
  State<ARCameraRecordingScreen> createState() =>
      ARCameraRecordingScreenState();
}

class ARCameraRecordingScreenState extends State<ARCameraRecordingScreen>
    with SingleTickerProviderStateMixin {
  DeepArController deepArController = DeepArController();
  String version = '';
  bool _isFaceMask = false;
  bool _isFilter = false,
      visibilityFasterVideoUI = false,
      visibilityTimerViewUI = false;

  final List<String> _effectsList = [];
  final List<String> _maskList = [];
  final List<String> _filterList = [];
  int _effectIndex = 0;
  int _maskIndex = 0;
  int _filterIndex = 0;

  final String _assetEffectsPath = 'assets/filters/';

  //final arController = Get.find<ArGearController>();
  final arController =
      Get.put<ArGearController>(ArGearController(), permanent: true);
  Timer? timer;

  List<String> filePPathsList = [];
  List<String> filterFilPathList = [];

  int selected = 0;
  List<PlaybackVideoModel> playbackList = [
    PlaybackVideoModel(value: ".3x", selected: false, time: 0.5),
    PlaybackVideoModel(value: ".5x", selected: false, time: 0.8),
    PlaybackVideoModel(value: "1x", selected: true, time: 1.0),
    PlaybackVideoModel(value: "2x", selected: false, time: 1.2),
    PlaybackVideoModel(value: "3x", selected: false, time: 1.5),
  ];
  List<VideoTimerModel> videoTimerList = [
    VideoTimerModel(value: "15s", selected: false, time: "15"),
    VideoTimerModel(value: "30s", selected: false, time: "30"),
    VideoTimerModel(value: "45s", selected: true, time: "45"),
  ];
  int _focusedIndex = 0;

  VideoPlayerController? controller;

  String viSpeedVal = "1x", videoTimerVal = "15s", videoTimeVal1 = "15";
  double viSpeedTimeVal = 1.0;
  int index = 2, index1 = 0;
  List<File> selectedImages = []; // List of selected image
  final picker = ImagePicker();
  //GlobalKey<ScrollSnapListState> sslKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() {
    deepArController
        .initialize(
          androidLicenseKey: AndroidapiKey,
          iosLicenseKey: "---iOS key---",
          resolution: Resolution.high,
        )
        .then((value) => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    _initEffects();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    deepArController.destroy();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return WillPopScope(
      onWillPop: () {
        deepArController.destroy();
        Get.delete<ArGearController>(force: true);
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
          body: Stack(
        children: [
          Transform.scale(
            scale: (1 / deepArController.aspectRatio) / deviceRatio,
            child: DeepArPreview(
              deepArController,
              onViewCreated: () {
                // set any initial effect, filter etc
                // _controller.switchEffect(
                //     _assetEffectsPath + 'Emotion_Meter.deepar');
              },
            ),
          ),
          Obx(
            () => Visibility(
                visible: arController.isVisibilityCameraButtons.value,
                child: rightMediaActionBotton()),
          ),
          //    _centerWidget(),
          //_bottomMediaOptions(),
          Obx(
            () => Visibility(
                visible: arController.isVisibilityCameraButtons.value,
                child: bottomActionButtonView()),
          ),

          //playbackSpeedManageUI(),
          Visibility(
            visible: visibilityFasterVideoUI,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.1, left: 15),
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstants.APPPRIMARYBLACKCOLOR.withOpacity(0.6),
                ),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: playbackList.length ?? 0,
                    itemBuilder: (_, pos) {
                      PlaybackVideoModel e = playbackList.elementAt(pos);
                      if (index == pos) {
                        e.selected = true;
                      } else {
                        e.selected = false;
                      }
                      return GestureDetector(
                        onTap: () {
                          index = pos;
                          viSpeedVal = e.value;
                          viSpeedTimeVal = e.time;
                          setState(() {});
                          delay(
                              duration: 400,
                              onTap: () {
                                visibilityFasterVideoUI = false;
                                setState(() {});
                              });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: e.selected
                                  ? ColorConstants.APPPRIMARYWHITECOLOR
                                  : Colors.transparent),
                          child: Center(
                            child: Text(
                              e.value,
                              style: textStyleW600(
                                  fontSize: 15,
                                  color: ColorConstants.appPrimaryColor),
                            ).paddingAll(5),
                          ),
                        ).paddingAll(5),
                      );
                    })
                /*Wrap(
                  children: vFasterList.map((e) {
                    if (e.selected) {
                      e.selected = false;
                    } else {
                      e.selected = true;
                    }
                    return GestureDetector(
                      onTap: () {
                        selectedVal = e.value;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: e.selected
                                ? ColorConstants.APPPRIMARYWHITECOLOR
                                : Colors.transparent),
                        child: Text(
                          e.value,
                          style: textStyleW600(
                              fontSize: 15,
                              color: ColorConstants.appPrimaryColor),
                        ).paddingAll(5),
                      ).paddingAll(5),
                    );
                  }).toList(),
                ).paddingOnly(top: 5)*/
                ,
              ),
            ),
          ),
          Visibility(
            visible: visibilityTimerViewUI,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 1.8, left: 15),
              child: Container(
                height: 40,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstants.APPPRIMARYBLACKCOLOR.withOpacity(0.6),
                ),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videoTimerList.length ?? 0,
                    itemBuilder: (_, pos) {
                      VideoTimerModel e = videoTimerList.elementAt(pos);
                      if (index1 == pos) {
                        e.selected = true;
                      } else {
                        e.selected = false;
                      }
                      return GestureDetector(
                        onTap: () {
                          index1 = pos;
                          videoTimerVal = e.value;
                          videoTimeVal1 = e.time;
                          setState(() {});
                          delay(
                              duration: 400,
                              onTap: () {
                                visibilityTimerViewUI = false;
                                setState(() {});
                              });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: e.selected
                                  ? ColorConstants.APPPRIMARYWHITECOLOR
                                  : Colors.transparent),
                          child: Center(
                            child: Text(
                              e.value,
                              style: textStyleW600(
                                  fontSize: 15,
                                  color: ColorConstants.appPrimaryColor),
                            ).paddingAll(5),
                          ),
                        ).paddingAll(5),
                      );
                    })
                /*Wrap(
                  children: vFasterList.map((e) {
                    if (e.selected) {
                      e.selected = false;
                    } else {
                      e.selected = true;
                    }
                    return GestureDetector(
                      onTap: () {
                        selectedVal = e.value;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: e.selected
                                ? ColorConstants.APPPRIMARYWHITECOLOR
                                : Colors.transparent),
                        child: Text(
                          e.value,
                          style: textStyleW600(
                              fontSize: 15,
                              color: ColorConstants.appPrimaryColor),
                        ).paddingAll(5),
                      ).paddingAll(5),
                    );
                  }).toList(),
                ).paddingOnly(top: 5)*/
                ,
              ),
            ),
          ),
        ],
      )),
    );
  }

  // flip, face mask, filter, flash
  Widget rightMediaActionBotton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4.1),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // flash icon
            IconButton(
              onPressed: () async {
                await deepArController.toggleFlash();
                setState(() {});
              },
              color: Colors.white70,
              iconSize: 30,
              icon: Icon(deepArController.flashState
                  ? Icons.flash_on
                  : Icons.flash_off),
            ),

            /*  IconButton(
              onPressed: () async {
                */ /*  FilePickerResult? fileResult = await FilePicker.platform
                    .pickFiles(allowMultiple: true, type: FileType.image);
                if (fileResult != null) {
                  List<File> fPathList =
                      fileResult.paths.map((e) => File(e!)).toList();*/ /*
                final picker1 = await picker.pickMultiImage();
                List<String> imgList = [];
                List<XFile> xfilePick = picker1;
                xfilePick.forEach((element) {
                  imgList.add(element.path);
                });
                arController.isPlayingVal.value = true;
                deepArController.destroy();
                final directory = await getExternalStorageDirectory();
                final outputPath =
                    '${directory!.path}/rangmanch${Random().nextInt(1000)}.mp4';
                createVideoFromImages(imgList, outputPath);
              },
              color: Colors.white70,
              iconSize: 30,
              icon: const Icon(Icons.video_camera_back_outlined),
            ),*/
            IconButton(
              onPressed: () async {
                Get.to(UseSongs())!.then((value) {
                  print("DDDDDD${value}");
                  if (value != null) {
                    arController.isVisibilityCameraButtons.value = false;
                    arController.audioTrimmerBottomSheetUI();
                  } else {
                    arController.isVisibilityCameraButtons.value = true;
                  }
                });
              },
              color: Colors.white70,
              iconSize: 30,
              icon: const Icon(Icons.music_note_sharp),
            ),

            IconButton(
              onPressed: () async {
                visibilityFasterVideoUI = true;
                setState(() {});
              },
              color: Colors.white70,
              iconSize: 30,
              icon: SizedBox(
                child: Text(
                  viSpeedVal,
                  style: TextStyle(
                      fontSize: 17,
                      color: ColorConstants.APPPRIMARYWHITECOLOR,
                      fontWeight: FontWeight.w700),
                ).paddingOnly(left: 1),
              ),
            ),

            IconButton(
              onPressed: () {
                visibilityTimerViewUI = true;
                setState(() {});
              },
              iconSize: 30,
              color: Colors.white70,
              icon: SACellRoundContainer1(
                color: ColorConstants.appPrimaryColor,
                height: 35,
                width: 35,
                child: Center(
                  child: Text(
                    videoTimerVal,
                    style: TextStyle(
                        fontSize: 13,
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                        fontWeight: FontWeight.w700),
                  ).paddingOnly(left: 1),
                ),
                radius: 60,
                borderWidth: 2,
                borderWidthColor:
                    ColorConstants.appPrimaryColor.withOpacity(0.5),
              ),
            ),
            IconButton(
                onPressed: () {
                  deepArController.flipCamera();
                },
                iconSize: 30,
                color: Colors.white70,
                icon: const Icon(Icons.cameraswitch)),

            // IconButton(
            //     iconSize: 30,
            //     onPressed: () {
            //       if (_isFaceMask) {
            //         String nextMask = _getNextMask();
            //         deepArController.switchFaceMask(nextMask);
            //       } else if (_isFilter) {
            //         String nextFilter = _getNextFilter();
            //         deepArController.switchFilter(nextFilter);
            //       } else {
            //         String nextEffect = _getNextEffect();
            //         deepArController.switchEffect(nextEffect);
            //       }
            //     },
            //     icon: RotatedBox(
            //       quarterTurns: 1,
            //       child: const Icon(
            //         Icons.arrow_forward_ios,
            //         color: Colors.white70,
            //       ),
            //     )),
          ],
        ).paddingOnly(left: 8, right: 8),
      ),
    );
  }

  Positioned _bottomMediaOptions() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /* IconButton(
                iconSize: 60,
                onPressed: () {
                  if (_isFaceMask) {
                    String prevMask = _getPrevMask();
                    deepArController.switchFaceMask(prevMask);
                  } else if (_isFilter) {
                    String prevFilter = _getPrevFilter();
                    deepArController.switchFilter(prevFilter);
                  } else {
                    String prevEffect = _getPrevEffect();
                    deepArController.switchEffect(prevEffect);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white70,
                )),*/
            /*IconButton(
                onPressed: () async {
                  if (deepArController.isRecording) {
                    File? file = await deepArController.stopVideoRecording();
                    arController.player.pause();
                    arController.filePath.value = await arController.mergeAudio(
                        File(file.path),
                        File(arController.downloadedPath.value));
                    Get.to(UploadView());
                    //OpenFile.open(arController.filePath.value);
                  } else {
                    if (arController.selectedSong != null) {
                      arController.player
                          .setUrl(arController.selectedSong.value?.sound ?? '')
                          .then((value) {
                        arController.player.play();
                      });
                    }
                    await deepArController.startVideoRecording();
                  }

                  setState(() {});
                },
                iconSize: 50,
                color: Colors.white70,
                icon: Icon(deepArController.isRecording
                    ? Icons.videocam_sharp
                    : Icons.videocam_outlined)),*/
            const SizedBox(width: 20),
            /*  IconButton(
                onPressed: () {
                  try {
                    deepArController.takeScreenshot().then((file) {
                      OpenFile.open(file.path);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Photo Capture Failed',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                color: Colors.white70,
                iconSize: 40,
                icon: const Icon(Icons.photo_camera)),*/
            IconButton(
                iconSize: 60,
                onPressed: () {
                  if (_isFaceMask) {
                    String nextMask = _getNextMask();
                    deepArController.switchFaceMask(nextMask);
                  } else if (_isFilter) {
                    String nextFilter = _getNextFilter();
                    deepArController.switchFilter(nextFilter);
                  } else {
                    String nextEffect = _getNextEffect();
                    deepArController.switchEffect(nextEffect);
                  }
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                )),
          ],
        ),
      ),
    );
  }

  /// Add effects which are rendered via DeepAR sdk
  void _initEffects() {
    // Either get all effects
    _getEffectsFromAssets(context).then((values) {
      filePPathsList.clear();
      filePPathsList.addAll(values);
    });
    _getEffectsFFromAssets(context).then((fValue) {
      filterFilPathList.clear();
      filterFilPathList.addAll(fValue);
    });
  }

  /// Get all deepar effects from assets
  ///
  Future<List<String>> _getEffectsFromAssets(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final filePPaths = manifestMap.keys
        .where((path) => path.startsWith("assets/fPreview/"))
        .toList();
    // print("FIULLLTTEHH$filePPaths");
    return filePPaths;
  }

  Future<List<String>> _getEffectsFFromAssets(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final filePaths = manifestMap.keys
        .where((path) => path.startsWith("assets/filters/"))
        .toList();
    print("FIULLLTTEHH$filePaths");
    return filePaths;
  }

  /// Get next effect
  String _getNextEffect() {
    _effectIndex < _effectsList.length ? _effectIndex++ : _effectIndex = 0;
    return _effectsList[_effectIndex];
  }

  /// Get previous effect
  String _getPrevEffect() {
    _effectIndex > 0 ? _effectIndex-- : _effectIndex = _effectsList.length;
    return _effectsList[_effectIndex];
  }

  /// Get next mask
  String _getNextMask() {
    _maskIndex < _maskList.length ? _maskIndex++ : _maskIndex = 0;
    return _maskList[_maskIndex];
  }

  /// Get previous mask
  String _getPrevMask() {
    _maskIndex > 0 ? _maskIndex-- : _maskIndex = _maskList.length;
    return _maskList[_maskIndex];
  }

  /// Get next filter
  String _getNextFilter() {
    _filterIndex < _filterList.length ? _filterIndex++ : _filterIndex = 0;
    return _filterList[_filterIndex];
  }

  /// Get previous filter
  String _getPrevFilter() {
    _filterIndex > 0 ? _filterIndex-- : _filterIndex = _filterList.length;
    return _filterList[_filterIndex];
  }

  bottomActionButtonView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          arController.downloadedPath.value == "" ? SizedBox() : SizedBox(),
          const Expanded(child: SizedBox()),
          SizedBox(
            height: 80,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: 60,
                useMagnifier: true,
                diameterRatio: 4.0,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (x) async {
                  selected = x;

                  var split = filePPathsList.elementAt(selected).split("/");
                  var split1 = split[2];
                  var split2 = split1.split(".");
                  //  print("FILLLTEHEG${split2[0]}");
                  deepArController
                      .switchEffect("assets/filters/${split2[0]}.deepar");
                  setState(() {});
                },
                children: List.generate(filterFilPathList.length, _buildItem),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        deepArController.flipCamera();
                      },
                      icon: SizedBox()),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (deepArController.isRecording)
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: SnapChatProgressButton(
                          size: 100,
                          time: videoTimeVal1,
                          color: Colors.deepOrangeAccent,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    GestureDetector(
                      onLongPress: () async {
                        onLongPressStart();
                      },
                      onLongPressEnd: (val) {
                        EasyLoading.show(status: "Loading");
                        setState(() {
                          animationController.dispose();
                          timer?.cancel();
                          if (widget.videoLink != "") controller!.dispose();
                        });
                        setState(() {});
                        onLongPressEnded();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: deepArController.isRecording
                                ? Colors.white60
                                : null,
                            border: Border.all(
                                color: Colors.white,
                                width: deepArController.isRecording ? 0 : 5),
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: IconButton(
                        onPressed: () async {
                          FilePickerResult? fileResult =
                              await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ["mp4"]);
                          if (fileResult != null) {
                            List<File> fPathList =
                                fileResult.paths.map((e) => File(e!)).toList();
                            arController.filePath.value = fPathList.first.path;
                            arController.isPlayingVal.value = true;
                            deepArController.destroy();
                            setPlaybackSpeed("Gallery", viSpeedTimeVal);
                          }
                        },
                        icon: AssetImageView(
                          img: "assets/gallery1.png",
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                        )))
              ],
            ),
          ),
          /* Container(
            height: 89,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filePPathsList
                    .map((e) => GestureDetector(
                          onTap: () {
                            var split = e.split("/");
                            var split1 = split[2];
                            var split2 = split1.split(".");
                            print("FILLLTEHEG${split2[0]}");
                            deepArController.switchEffect(
                                "assets/filters/${split2[0]}.deepar");
                          },
                          child: SACellRoundContainer(
                              width: 70,
                              height: 70,
                              child: ClipOval(
                                  child: AssetImageView(
                                img: e,
                                fit: BoxFit.fill,
                              )),
                              radius: 50,
                              borderWidth: 0,
                              borderWidthColor:
                                  ColorConstants.APPPRIMARYBLACKCOLOR),
                        ))
                    .toList(),
              ).paddingOnly(),
            ),
          )*/
        ],
      ),
    );
  }

  Future<void> setPlaybackSpeed(String type, double speed) async {
    final directory = await getExternalStorageDirectory();
    final outputPath =
        '${directory!.path}/playbackVI${Random().nextInt(1000)}.mp4';
    String command =
        '-i ${arController.filePath.value} -vf "setpts=${1 / speed}*PTS" -af "atempo=$speed" $outputPath';
    await FFmpegKit.execute(command).then((value) {
      EasyLoading.dismiss();
      arController.filePath.value = outputPath;
      Get.off(VideoPreview(
        type: type,
        fTimer: viSpeedTimeVal,
      ));
    });
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  ///storage/emulated/0/Android/data/com.app.rangmanch/files/audio221.mp3
  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  void onLongPressEnded() async {
    try {
      File? file = await deepArController.stopVideoRecording();
      final directory = await getExternalStorageDirectory();
      String filePath =
          '${directory!.path}/deepAR${Random().nextInt(1000)}.mp4';

      File fileDef = File(filePath);
      await fileDef.create(recursive: true);
      Uint8List bytes = await file.readAsBytes();
      await fileDef.writeAsBytes(bytes);

      if (arController.selectedSong.value != null ||
          arController.selectAudioFile.value) {
        print("OPkkkkAYY");
        arController.player.pause();
        final MediaInfo mediaInfo = MediaInfo();
        final Map<String, dynamic> h =
            await mediaInfo.getMediaInfo(fileDef.path);
        String durationVal = Duration(milliseconds: h["durationMs"]).toString();
        arController.filePath.value = await arController.mergeAudio(
            File(fileDef.path),
            File(arController.downloadedPath.value),
            durationVal,
            "");
      } else if (widget.videoLink != "") {
        arController.downloadedPath.value = widget.videoLink;
        final MediaInfo mediaInfo = MediaInfo();
        final Map<String, dynamic> h =
            await mediaInfo.getMediaInfo(fileDef.path);
        String durationVal = Duration(milliseconds: h["durationMs"]).toString();
        arController.filePath.value = await arController.mergeAudio(
            File(fileDef.path),
            File(arController.downloadedPath.value),
            durationVal,
            "mp4");
        //arController.selfVal.value = true;
        arController.tblVideoSoundId.value = widget.tblVideoSoundId;
      } else {
        arController.filePath.value = fileDef.path;
      }

      arController.isPlayingVal.value = true;
      deepArController.destroy();
      // await File(arController.downloadedPath.value).delete();
      // await File(fileDef.path).delete();
      setPlaybackSpeed("C", viSpeedTimeVal);
      // Get.off(VideoPreview(type: "C", fTimer: viSpeedTimeVal));
      /*
        await File(file.path).delete();
          await File(widget.videoLink).delete();
          await File(arController.downloadedPath.value).delete();
          await File(fileDef.path).delete();
      final latPath =
          '${directory!.path}/fRangManch${Random().nextInt(1000)}.mp4';
      //String speedCommand =
      //   '-i ${arController.filePath.value} -filter:v "setpts=0.125*PTS" $latPath';
      String speedCommand =
          '-i ${arController.filePath.value} -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" $latPath';
      FFmpegKit.execute(speedCommand).then((value) async {
        final returnCode = await value.getReturnCode();
        if (returnCode!.isValueSuccess()) {
          arController.filePath.value = latPath;
          Get.off(VideoPreview(type: "C", fTimer: viSpeedTimeVal));
        }
      });*/
    } catch (e) {
      debugPrint("FILEEE${e.toString()}");
    }
  }

  void onLongPressStart() async {
    if (arController.selectedSong.value != null ||
        arController.selectAudioFile.value) {
      if (arController.selectAudioFile.value) {
        arController.player
            .setFilePath(arController.downloadedPath.value ?? '')
            .then((value) {
          arController.player.play();
        });
      } else {
        // arController.downloadedPath.value =
        //   arController.selectedSong.value!.sound;
        arController.player
            .setFilePath(arController.downloadedPath.value ?? '')
            .then((value) {
          arController.player.play();
        });
      }
    } else if (widget.videoLink != "") {
      controller = VideoPlayerController.file(File(widget.videoLink))
        ..initialize()
        ..play();
    }
    await deepArController.startVideoRecording();
    setState(() {});
    timer =
        Timer.periodic(Duration(seconds: int.parse(videoTimeVal1)), (timer) {
      onLongPressEnded();
    });
  }

  Widget _buildItem(int x) {
    return RotatedBox(
      quarterTurns: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: x == selected
                ? ColorConstants.appPrimaryColor
                : Colors.transparent,
            shape: BoxShape.circle),
        child: x == 0
            ? Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ).paddingAll(2)
            : ClipOval(
                child: AssetImageView(
                  fit: BoxFit.fill,
                  img: filePPathsList.elementAt(x),
                ),
              ).paddingOnly(left: 5, top: 2, bottom: 2, right: 5),
      ),
    );
  }

  Future<void> createVideoFromImages(
      List<String> list, String outputPath) async {
    if (list.isEmpty) {
      // Handle error, no images selected
      return;
    }

    // Replace with desired output path

    List<String> imagePaths = list.map((image) => image).toList();

    String imageList =
        imagePaths.map((image) => 'image \'${image}\'').join(' ');
    String command =
        '-framerate 1 -i $imageList -c:v libx264 -r 30 -pix_fmt yuv420p $outputPath';

    FFmpegKit.execute(command);

    // Video created successfully
    print('Video created at: $outputPath');
  }
}

class utils {
  static String bgIMG =
      "https://st2.depositphotos.com/4829791/12462/i/950/depositphotos_124624066-stock-photo-google-icon-sign.jpg";
  static String bgIMG2 =
      "https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  static String emozi =
      "https://gifdb.com/images/high/angry-thumbs-down-emoji-g42dro74syhak6bd.gif";
  static Color mCL = Color(0xff2d3c99);

  static String bird = "images/bird.gif";

  static List normalImg = [bgIMG, bgIMG2, emozi, bird];
}
