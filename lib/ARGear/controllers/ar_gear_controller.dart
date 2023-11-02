import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:champcash/ARGear/views/audio_trimmer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:champcash/ARGear/config.dart';
import 'package:champcash/ARGear/views/upload_view.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/controller/DashBoardController.dart';
import 'package:champcash/models/SongCategories.dart';
import 'package:champcash/shared/extras.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

import 'package:flutter/services.dart';
//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'package:just_audio/just_audio.dart';
import 'package:cached_video_player/cached_video_player.dart';

import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/models/Categories.dart';
import 'package:champcash/models/Languages.dart';
import 'package:champcash/models/TrendingSong.dart';
import 'package:champcash/models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
//import 'package:video_trimmer/video_trimmer.dart';

import '../../Apis/api/api_imp.dart';
import '../../Apis/api/base_api.dart';
import '../../Routes/AppRoutes.dart';
import '../../main.dart';
import '../../models/sticker_response.dart';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ArGearController extends GetxController {
  // final arGearController = ARGearController(id: 0).obs;
  SADashboardController dController = Get.find<SADashboardController>();
  late MethodChannel arGearChannel;
  // Rx<Trimmer> trimmer = Trimmer().obs;
  final startVal = 0.0.obs,
      endVal = 0.0.obs,
      isPlayingTrimmerVideo = false.obs,
      progressVisibility = false.obs,
      trimPathVal = "".obs;

  final decorList = [
    DecorItem(icon: 'sticker', title: 'Sticker'),
    DecorItem(icon: 'bulge', title: 'Bulge'),
    DecorItem(icon: 'effect', title: 'Beauty'),
    DecorItem(icon: 'filter_btn', title: 'Filter'),
    DecorItem(icon: 'timer', title: 'Timer'),
    DecorItem(icon: 'ratio', title: 'Size'),
  ];

  final tags = [
    'dialogues',
    'funny',
    'motivation',
    'health',
    'gymlovers',
    'bollywood',
    'romantic',
    'swag',
    'cricket',
    'sports',
    'dance'
  ];

  // final beautyList = [
  //   BeautyItemInfo(
  //       type: ARGBeauty.VLINE,
  //       icon: 'beauty_vline_btn_default',
  //       defaultVal: 10,
  //       value: 10),
  //   BeautyItemInfo(
  //       type: ARGBeauty.FACE_SLIM,
  //       icon: 'beauty_face_slim_btn_default',
  //       defaultVal: 90,
  //       value: 90),
  //   BeautyItemInfo(
  //       type: ARGBeauty.JAW,
  //       icon: 'beauty_jaw_btn_default',
  //       defaultVal: 55,
  //       value: 55),
  //   BeautyItemInfo(
  //       type: ARGBeauty.CHIN,
  //       icon: 'beauty_chin_btn_default',
  //       defaultVal: -55,
  //       value: -55),
  //   BeautyItemInfo(
  //       type: ARGBeauty.EYE,
  //       icon: 'beauty_eye_btn_default',
  //       defaultVal: 5,
  //       value: 5),
  //   BeautyItemInfo(
  //       type: ARGBeauty.EYE_GAP,
  //       icon: 'beauty_eyegap_btn_default',
  //       defaultVal: -10,
  //       value: -10),
  //   BeautyItemInfo(
  //       type: ARGBeauty.NOSE_LINE,
  //       icon: 'beauty_nose_line_btn_default',
  //       defaultVal: 0,
  //       value: 0),
  //   BeautyItemInfo(
  //       type: ARGBeauty.NOSE_SIDE,
  //       icon: 'beauty_nose_side_btn_default',
  //       defaultVal: 35,
  //       value: 35),
  //   BeautyItemInfo(
  //       type: ARGBeauty.NOSE_LENGTH,
  //       icon: 'beauty_nose_length_btn_default',
  //       defaultVal: 30,
  //       value: 30),
  //   BeautyItemInfo(
  //       type: ARGBeauty.MOUTH_SIZE,
  //       icon: 'beauty_mouth_size_btn_default',
  //       defaultVal: -35,
  //       value: -35),
  //   BeautyItemInfo(
  //       type: ARGBeauty.EYE_BACK,
  //       icon: 'beauty_eyeback_btn_default',
  //       defaultVal: 0,
  //       value: 0),
  //   BeautyItemInfo(
  //       type: ARGBeauty.EYE_CORNER,
  //       icon: 'beauty_eyecorner_btn_default',
  //       defaultVal: 0,
  //       value: 0),
  //   BeautyItemInfo(
  //       type: ARGBeauty.LIP_SIZE,
  //       icon: 'beauty_lip_size_btn_default',
  //       defaultVal: 0,
  //       value: 0),
  //   BeautyItemInfo(
  //       type: ARGBeauty.SKIN_FACE,
  //       icon: 'beauty_skin_btn_default',
  //       defaultVal: 50,
  //       value: 50),
  //   BeautyItemInfo(
  //       type: ARGBeauty.SKIN_DARK_CIRCLE,
  //       icon: 'beauty_dark_circle_btn_default',
  //       defaultVal: 0,
  //       value: 0),
  //   BeautyItemInfo(
  //       type: ARGBeauty.SKIN_MOUTH_WRINKLE,
  //       icon: 'beauty_mouth_wrinkle_btn_default',
  //       defaultVal: 0,
  //       value: 0),
  // ];
  List<String> bulgeList = [
    'none_filter',
    'pear',
    'grinch',
    'hamster',
    'square',
    'short_face',
    'long_face'
  ];

  // final selectedBeautyItem = BeautyItemInfo(
  //         type: ARGBeauty.VLINE,
  //         icon: 'beauty_vline_btn_default',
  //         defaultVal: 10,
  //         value: 10)
  //.obs;
  // final selectedFilter = Rxn<ItemModel>();
  List<String> motionList = ['Slower', 'Slow', 'Normal', 'Fast', 'Faster'];

  final selectedBulgeIndex = 0.obs;
  final selectedMotionIndex = 2.obs;

  // final cameraRatio = ARGCameraRatio.RATIO_FULL;

  final filePath = ''.obs;
  final compressedFile = ''.obs;
  final percentage = 0.0.obs;

  CachedVideoPlayerController? cachedVideoPlayerController;
  //final LightCompressor lightCompressor = LightCompressor();
  final isVideoCompressing = false.obs;

  final filter = 'filter';
  final effect = 'sticker/effects';
  final segmentation = 'segmentation';

  // List<ItemModel> itemsFilter = [];
  // List<ItemModel> itemsEffect = [];
  // List<ItemModel> itemsSegmentation = [];
  // final selectedEffects = RxList<ItemModel>();

  final itemSelectedIndex = 0.obs;
  final uploadProgress = 0.0.obs;

  //late videoCompress.Subscription _subscription;
  final beautyValue = 10.0.obs;
  final decorWidget = Rxn<Widget>();
  final isRecording = false.obs;

  final selectedTimer = 3.obs;
  final countTimer = 3.obs;
  final recordingTime = 30.obs;
  Timer? recordingTimer;

  final tagController = TextEditingController();
  List<Language> languages = [];
  List<Catg> categories = [];

  final selectedLanguage = Rxn<Language>();
  final selectedCategory = RxList<Catg>();
  final trendingSongs = RxList<Song>();
  final categorySongs = RxList<Song>();
  final songCategory = RxList<SongCategory>();

  final playIndex = 1000.obs;
  final player = AudioPlayer();
  final isPlaying = false.obs;
  final downloadedPath = ''.obs,
      selectAudioFile = false.obs,
      isSelectByGallery = false.obs;
  final selectedSong = Rxn<Song>();

  final playerProgress = 0.0.obs;
  final playerDuration = 0.obs, tblVideoSoundId = "".obs;
  final isUploading = false.obs;
  final isPlayingVal = false.obs, isVisibilityCameraButtons = true.obs;

  @override
  void onInit() {
    super.onInit();

    //downloadStickers();
    //downloadLanguages();
    //  filePath.value = Get.arguments["FilePath"];
    //  print("UUMMMMM${filePath.value}");
    loadTrimmerVideo();
    downloadCategories();
    downloadLanguages();

    downloadTrendingSongs();
    downloadSongCategory();
    //addPlayerListener();
  }

  saveTrimmingVideo() async {
    /* progressVisibility.value = true;
    await trimmer.value.saveTrimmedVideo(
        startValue: startVal.value,
        endValue: endVal.value,
        onSave: (String? outputPath) {
          progressVisibility.value = false;
          trimPathVal.value = outputPath!;
          print("PATHHHHHH${trimPathVal.value}");
          Get.to(UploadView());
        });*/
  }

  loadTrimmerVideo() {
    //trimmer.value.loadVideo(videoFile: File(filePath.value));
  }

  Future<Uint8List> getVideoThumbnail() async {
    try {
      String? fileName = await VideoThumbnail.thumbnailFile(
        video: filePath.value,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight:
            350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      print("Hii2222");
      final file = File(fileName!);
      Uint8List u = file.readAsBytesSync();
      return u;
    } catch (e) {
      final file = File('fileName'!);
      Uint8List u = file.readAsBytesSync();
      return u;
    }
  }

  void addPlayerListener() {
    player.playerStateStream.listen((event) {
      if (event.playing) {
        isPlaying.value = true;
      } else {
        switch (event.processingState) {
          case ProcessingState.idle:
            isPlaying.value = false;
            break;
          case ProcessingState.loading:
            isPlaying.value = false;
            break;
          case ProcessingState.buffering:
            isPlaying.value = false;
            break;
          case ProcessingState.ready:
            isPlaying.value = false;
            break;
          case ProcessingState.completed:
            isPlaying.value = false;
            break;
        }
      }

      if (event.processingState == ProcessingState.completed) {
        if (isRecording.value) {
          stopRecording();
        }
      }
    });

    player.positionStream.listen((event) {
      print('${player.duration?.inSeconds},  ${event.inSeconds}');
      playerDuration.value = event.inSeconds;
      playerProgress.value =
          event.inMilliseconds / (player.duration?.inMilliseconds ?? 1);
    });
  }

  void initVideoPlayer(String filePathVal) async {
    isPlayingVal.value = true;
    if (cachedVideoPlayerController != null) {
      cachedVideoPlayerController?.dispose();
    }
    cachedVideoPlayerController =
        CachedVideoPlayerController.file(File(filePathVal))
          ..addListener(() {})
          ..setLooping(false);

    await cachedVideoPlayerController?.initialize();
    cachedVideoPlayerController?.play();
  }

  //void onArGearViewCreated(ARGearController controller) {
//    arGearController.value = controller;
//  }

  void onCallback(method, arguments) {
    var arg = arguments;
    debugPrint('ONMethodIICALLLBACKKK$method / $arguments');
  }

  void onPre(method, arguments) {
    var arg = arguments;
    debugPrint('ONMethodIIPREEEE$method / $arguments');
    EasyLoading.dismiss();
  }

  void onComplete(method, arguments) async {
    // var arg = arguments;
    // debugPrint('ONMethodIICOMPLETEE$method / $arguments');

    // arguments = await mergeAudio(File(arguments), File(downloadedPath.value));

    filePath.value = arguments;
    EasyLoading.dismiss();

    if (isRecording.value) {
      isRecording.value = false;
      // initVideoPlayer();
      // Get.to(VideoPreview())?.then((value) {
      //   if (cachedVideoPlayerController != null)
      //     cachedVideoPlayerController?.dispose();
      // });
    }
  }

  void startRecording() async {
    try {
      // arGearController.value.startRecording();
      isRecording.value = true;
      if (selectedSong.value == null) {
        recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordingTime.value -= 1;
          if (recordingTime.value <= 0) {
            recordingTime.value = 30;
            stopRecording();
            timer.cancel();
          }
        });
      }
    } catch (error) {
      print("ARGEAR$error");
    }
  }

  void stopRecording() async {
    if (isPlaying.value) player.pause();
    recordingTimer?.cancel();
    // arGearController.value.stopRecording().then((value) {
    //    EasyLoading.show();
    //});

    // arGearController.changeCameraRatio(ratio)
  }

  void onSelectDecor(index) {
    var context = NavigationService.navigatorKey.currentContext;

    switch (index) {
      case 0:
        decorWidget.value = stickerEffects(context);
        break;
      case 1:
        decorWidget.value = bulges();
        break;

      case 2:
        decorWidget.value = beautyEffect(context);
        break;

      case 3:
        decorWidget.value = filterEffect(context);
        break;

      case 4:
        decorWidget.value = timerWidget(context);
        break;

      case 5:
        // arGearController.
        showDialog(
            context: context!,
            builder: (context) => AlertDialog(
                  title: const Text('Change Camera Ratio'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Full Screen'),
                        onTap: () {
                          //   arGearController.value
                          //     .changeCameraRatio(ARGCameraRatio.RATIO_FULL);
                          Get.back();
                        },
                      ),
                      ListTile(
                        title: const Text('Ratio 4:3'),
                        onTap: () {
                          //  arGearController.value
                          //    .changeCameraRatio(ARGCameraRatio.RATIO_4_3);
                          Get.back();
                        },
                      ),
                      ListTile(
                          title: const Text('Ratio 1:1'),
                          onTap: () {
                            //   arGearController.value
                            //    .changeCameraRatio(ARGCameraRatio.RATIO_1_1);
                            Get.back();
                          })
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel'))
                  ],
                ));
        break;

      // case 2:
      //   arGearController?.setBulge(ARGBulge.FUN2);
      //   break;
      // case 3:
      //   arGearController?.setBulge(ARGBulge.FUN3);
      //   break;
      // case 4:
      //   arGearController?.setBulge(ARGBulge.FUN4);
      //   break;
      // case 5:
      //   arGearController?.setBulge(ARGBulge.FUN5);
      //   break;
      // case 6:
      //   arGearController?.setBulge(ARGBulge.FUN6);
      //   break;
    }
  }

  // void onSelectBulge(index) {
  //   selectedBulgeIndex.value = index;
  //   switch (index) {
  //     case 0:
  //       arGearController.value.clearBulge();
  //       break;
  //     case 1:
  //       arGearController.value.setBulge(ARGBulge.FUN1);
  //       break;
  //     case 2:
  //       arGearController.value.setBulge(ARGBulge.FUN2);
  //       break;
  //     case 3:
  //       arGearController.value.setBulge(ARGBulge.FUN3);
  //       break;
  //     case 4:
  //       arGearController.value.setBulge(ARGBulge.FUN4);
  //       break;
  //     case 5:
  //       arGearController.value.setBulge(ARGBulge.FUN5);
  //       break;
  //     case 6:
  //       arGearController.value.setBulge(ARGBulge.FUN6);
  //       break;
  //   }
  // }

  void downloadStickers() async {
    EasyLoading.show();
    ApiResponse apiResponse = await ApiImpl().getStickersAPI({});
    EasyLoading.dismiss();
    if (apiResponse.status) {
      StickerResponse response = apiResponse.data;
      final List<Category> categories = response.categories;

      if (categories.isNotEmpty) {
        // List<ItemModel> items = categories.first.items;
        //
        // itemsFilter = items.where((element) => element.type == filter).toList();
        // itemsEffect = items.where((element) => element.type == effect).toList();
        // itemsSegmentation =
        //     items.where((element) => element.type == segmentation).toList();
        // selectedEffects.value = itemsEffect;
      }
    }
  }

  void downloadLanguages() async {
    APIResponse apiResponse = await getLanguage();
    if (apiResponse.status) {
      Languages langs = apiResponse.data;
      languages = langs.data;
      selectedLanguage.value = languages.first;
    }
  }

  void downloadCategories() async {
    APIResponse apiResponse = await getCategory();
    if (apiResponse.status) {
      Categories catg = apiResponse.data;
      categories = catg.data;
    }
  }

  void downloadTrendingSongs() async {
    APIResponse apiResponse = await getTrendingSongs();
    if (apiResponse.status) {
      TrendingSongs catg = apiResponse.data;
      trendingSongs.value = catg.data;
      print(trendingSongs.length);
    }
  }

  void downloadCategorySong(String categoryId) async {
    APIResponse apiResponse =
        await getSongCategoryByID({"tbl_sound_category_id": categoryId});
    if (apiResponse.status) {
      TrendingSongs catg = apiResponse.data;
      categorySongs.value = catg.data;
    }
  }

  void downloadSongCategory() async {
    APIResponse apiResponse = await getSongCategory();
    if (apiResponse.status) {
      SongCategoris catg = apiResponse.data;
      songCategory.value = catg.data;
    }
  }

  Future<String> downloadFile(String url) async {
    var filename =
        "audio${Random().nextInt(1000)}.mp3"; //Uri.parse(url).pathSegments.last;
    final directory = await getExternalStorageDirectory();
    // print("DOWNLOADEDPATH${directory!.path}");
    File file = File('${directory!.path}/$filename');
    var request = await http.get(Uri.parse(url));
    var bytes = request.bodyBytes;
    await file.writeAsBytes(bytes);
    print(file.path);
    //downloadedPath.value = file.path;
    return file.path;
  }

  void uploadFromLocal() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickVideo(source: ImageSource.gallery);
    Logger().d(image?.path);
    isRecording.value = false;
    filePath.value = image?.path ?? '';
    print("PPPAAATTHHHH${filePath.value}");
    // initVideoPlayer();
  }

  Future<void> getMP3File() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        onFileLoading: (FilePickerStatus status) => print(status),
        // allowedExtensions: ['mp3'],
      );
      List<PlatformFile> files = result?.files ?? [];
      if (files.isNotEmpty) {
        downloadedPath.value = files.first.path ?? '';
        player.setFilePath(downloadedPath.value);
        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> compressVideo() async {
    print("FILLLLLE${filePath.value}");
    isUploading.value = true;
    player.pause();
    isVideoCompressing.value = true;

    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      filePath.value,

      quality: VideoQuality.MediumQuality,
      deleteOrigin: false, // It's false by default
    );

    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: filePath.value,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 60);

    isVideoCompressing.value = false;

    isUploading.value = false;

    final videoPath = mediaInfo?.file ?? File(filePath.value);
    final thumbFile = File(thumbnail!);
    uploadVideo(videoPath, thumbFile);
  }

  Future<void> uploadVideo(File file, File thumbFile) async {
    print("FILLLLLE${file.path}    ${thumbFile.path}");
    var url = '$apiHost/upload_vedio_api.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = userLoginModel!.data.userId; //'980';
    request.fields['tag'] = '';
    request.fields['hash_tag'] = tagController.text;
    request.fields['tbl_sound_id'] = 'self';
    request.fields['type'] = 'self';
    request.fields['channel_id'] = getChannelId();
    request.fields['language_id'] = selectedLanguage.value!.tblLanguageId;

    var fthumbnail = await http.MultipartFile.fromPath(
        "video_thumb", thumbFile.path,
        contentType: MediaType("image", "jpg"));
    request.files.add(fthumbnail);

    request.files.add(await http.MultipartFile.fromPath("video", file.path));

    var response = await request.send();
    var response2 = await response.stream.toBytes();
    var responseString = String.fromCharCodes(response2);
    Map resJson = jsonDecode(responseString);

    if (resJson["status"] == "1") {
      await File(file.path).delete();

      EasyLoading.showToast('Video uploaded successfully');
      selectedSong.value = null;
      selectedCategory.clear();
      selectedCategory.clear();
      isUploading.value = false;
      Get.delete<ArGearController>(force: true);
      Get.back();
      Get.offAndToNamed(Routes.S_A_DASHBOARD);
      Get.find<SADashboardController>().bottomIndex.value = 0;
    } else {
      showErrorBottomSheet(resJson["message"]);
    }
    return;
  }

  Future<String> mergeAudio(
      File videoPath, File audioPath, String durationVal, String ext) async {
    String ext1 = ext == "mp4" ? "mp4" : "mp3";
    String videoPathVal = videoPath.path;
    String audioPathVal = audioPath.path;
    print("AAUUUUUU$audioPathVal}");
    final directory = await getExternalStorageDirectory();
    final outputPath =
        '${directory!.path}/rangmanch${Random().nextInt(1000)}.mp4';

    String commandToExecute =
        '-r 15 -f mp4 -i $videoPathVal -f $ext1 -i $audioPathVal'
        ' -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $durationVal -y $outputPath';
    await FFmpegKit.execute(commandToExecute).whenComplete(() async {
      print('FFmpeg process exited with rc:');
    });

    return outputPath;
  }

  String getChannelId() {
    String categ = '';
    for (var element in selectedCategory) {
      categ += '${element.name} ';
    }
    return categ;
  }

  Future<void> readAllLocalMP3Files() async {
    Directory dir = await getApplicationDocumentsDirectory();
    //  search(dir).listen((event) {
    //  print(event.path);
    // });
  }

  // Stream<File> search(Directory dir) {
  //   return Glob("**.mp3")
  //       .list(root: dir.path)
  //       .where((entity) => entity is File)
  //       .cast<File>();
  // }

  Widget bulges() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 36,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  decorWidget.value = null;
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => Image.asset(
                          'assets/${bulgeList.elementAt(index)}.png',
                          width: 40,
                          color: selectedBulgeIndex.value == index
                              ? Colors.white
                              : Colors.grey,
                        )),
                  ),
                  onTap: () {
                    //onSelectBulge(index);
                  },
                );
              },
              itemCount: bulgeList.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Widget stickerEffects(context) => Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              const Expanded(
                  child: Text(
                'Set Sticker',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 60,
                child: GestureDetector(
                    onTap: () {
                      decorWidget.value = null;
                    },
                    child: Image.asset(
                        'assets/drawable/close_button_default.png')),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/${bulgeList.elementAt(0)}.png',
                          width: 40),
                    ),
                    onTap: () {},
                  ),
                ),
                onTap: () {},
              ),
              Expanded(
                  child: Obx(() => Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              itemSelectedIndex.value = 0;
                              //selectedEffects.value = itemsEffect;
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Obx(() => Text(
                                  'Stickers',
                                  style: TextStyle(
                                      color: itemSelectedIndex.value == 0
                                          ? Colors.white
                                          : Colors.white),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: 2,
                            color: itemSelectedIndex.value == 0
                                ? Colors.orangeAccent
                                : Colors.transparent,
                          )
                        ],
                      ))),
              Expanded(
                  child: Obx(() => Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              itemSelectedIndex.value = 1;
                              //  selectedEffects.value = itemsSegmentation;
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            child: Obx(() => Text(
                                  'Backgrounds',
                                  style: TextStyle(
                                      color: itemSelectedIndex.value == 1
                                          ? Colors.white
                                          : Colors.white),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: 2,
                            color: itemSelectedIndex.value == 1
                                ? Colors.orangeAccent
                                : Colors.transparent,
                          )
                        ],
                      ))),
            ],
          ),
          // SizedBox(
          //   height: 100,
          //   width: double.infinity,
          //   child: Obx(() => ListView.builder(
          //         itemBuilder: (context, index) {
          //         //  ItemModel model = selectedEffects.elementAt(index);
          //
          //           return GestureDetector(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: SizedBox(),
          //               // child: Image.network(model.thumbnail),
          //             ),
          //             onTap: () {
          //          //     arGearController.value.setSticker(model);
          //             },
          //           );
          //         },
          //         itemCount: selectedEffects.length,
          //         scrollDirection: Axis.horizontal,
          //       )),
          // )
        ],
      ));

  Widget beautyEffect(context) => Positioned(
      left: 8,
      right: 8,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              const Expanded(
                  child: Text(
                'Beauty Setup',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 60,
                child: GestureDetector(
                    onTap: () {
                      decorWidget.value = null;
                    },
                    child: Image.asset(
                        'assets/drawable/close_button_default.png')),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Obx(() => Slider(
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white60,
                      value: beautyValue.value,
                      onChanged: (double newValue) {
                        beautyValue.value = newValue;
                        //  arGearController.value
                        //    .setBeauty(selectedBeautyItem.value.type, newValue);
                      },
                      onChangeEnd: (val) {
                        //  selectedBeautyItem.value.value = val;
                      },
                    )),
              ),
              GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/drawable/comparison_btn_default.png',
                    width: 52,
                  )),
              GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/drawable/init_btn_default.png',
                    width: 52,
                  )),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // SizedBox(
          //   height: 50,
          //   child: ListView.builder(
          //     itemBuilder: (context, index) {
          //     //  BeautyItemInfo info = beautyList.elementAt(index);
          //       return GestureDetector(
          //         onTap: () {
          //       //    selectedBeautyItem.value = info;
          //           beautyValue.value = info.value;
          //         },
          //         child: Obx(() => Image.asset(
          //               'assets/drawable/${info.icon}.png',
          //               color: info.type == selectedBeautyItem.value.type
          //                   ? Colors.white
          //                   : null,
          //             )),
          //       );
          //     },
          //     itemCount: beautyList.length,
          //     scrollDirection: Axis.horizontal,
          //   ),
          // )
        ],
      ));

  Widget filterEffect(context) => Positioned(
      left: 8,
      right: 8,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              const Expanded(
                  child: Text(
                'Beauty Setup',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 60,
                child: GestureDetector(
                    onTap: () {
                      decorWidget.value = null;
                    },
                    child: Image.asset(
                        'assets/drawable/close_button_default.png')),
              ),
            ],
          ),
          // const SizedBox(height: 16,),
          const Divider(
            color: Colors.white38,
          ),
          // SizedBox(
          //   height: 100,
          //   child: ListView.builder(
          //     itemBuilder: (context, index) {
          //       ItemModel model = itemsFilter.elementAt(index);
          //       return GestureDetector(
          //         onTap: () {
          //           selectedFilter.value = model;
          //           arGearController.value.setFilter(model);
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.all(4.0),
          //           child: Column(
          //             children: [
          //               Obx(() => Container(
          //                     width: 60, height: 60,
          //                     decoration: BoxDecoration(
          //                         border:
          //                             selectedFilter.value?.uuid == model.uuid
          //                                 ? Border.all(
          //                                     color: Colors.orange, width: 2)
          //                                 : null,
          //                         shape: BoxShape.circle,
          //                         image: DecorationImage(
          //                             image: NetworkImage(model.thumbnail))),
          //                     // child: Image.network(model.thumbnail),
          //                   )),
          //               const SizedBox(
          //                 height: 8,
          //               ),
          //               Obx(() => Text(
          //                     model.title,
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                         color:
          //                             selectedFilter.value?.uuid == model.uuid
          //                                 ? Colors.white
          //                                 : Colors.white60),
          //                   ))
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //     itemCount: itemsFilter.length,
          //     scrollDirection: Axis.horizontal,
          //   ),
          // )
        ],
      ));

  Widget timerWidget(context) => Stack(
        children: [
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black26,
            ),
            onTap: () {
              decorWidget.value = null;
            },
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                            child: Text(
                          'Set Recording Timer',
                          style: TextStyle(color: Colors.white),
                        )),
                        GestureDetector(
                          child: Obx(() => Container(
                                height: 30,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: selectedTimer.value == 3
                                        ? Colors.orange
                                        : null,
                                    border: Border.all(
                                        color: Colors.white, width: 0.5),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                                child: Text(
                                  '3S',
                                  style: TextStyle(
                                      color: selectedTimer.value == 3
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              )),
                          onTap: () {
                            selectedTimer.value = 3;
                          },
                        ),
                        GestureDetector(
                          child: Obx(() => Container(
                                height: 30,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: selectedTimer.value == 10
                                        ? Colors.orange
                                        : null,
                                    border: Border.all(
                                        color: Colors.white, width: 0.5),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Text('10S',
                                    style: TextStyle(
                                        color: selectedTimer.value == 10
                                            ? Colors.black
                                            : Colors.white)),
                              )),
                          onTap: () {
                            selectedTimer.value = 10;
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text('Start Shooting'),
                      ),
                      onTap: () {
                        decorWidget.value = startTimer(
                            NavigationService.navigatorKey.currentContext);

                        Timer.periodic(const Duration(seconds: 1), (timer) {
                          countTimer.value -= 1;
                          if (countTimer <= 0) {
                            decorWidget.value = null;
                            startRecording();
                            countTimer.value = selectedTimer.value;
                            timer.cancel();
                          }
                        });

                        // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * selectedTimer.value;

                        // CountdownTimer(
                        //   endTime: endTime,
                        //
                        //   onEnd: (){
                        //     startRecording();
                        //   },
                        // );
                      },
                    ),
                  ],
                ),
              )),
        ],
      );

  Widget startTimer(context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black45,
        alignment: Alignment.center,
        child: Obx(() => Text(
              '${countTimer.value}',
              style: const TextStyle(color: Colors.white, fontSize: 70),
            )),
      );

  void onInit1() {
    isPlayingVal.value = false;
  }

  void audioTrimmerBottomSheetUI() {
    Get.bottomSheet(AudioTrimmerView(File(downloadedPath.value)),
            enableDrag: true, isScrollControlled: true, isDismissible: false)
        .then((value) {
      if (value != null) {
        isVisibilityCameraButtons.value = true;
        downloadedPath.value = value;
      } else {
        isVisibilityCameraButtons.value = true;
      }
    });
  }
}
