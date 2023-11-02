import 'dart:async';
import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class MakeReelScreenController extends GetxController {
  var cachedVideoPlayerController;

  final filePath = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  void initVideoPlayer() async {
    if (cachedVideoPlayerController != null) {
      cachedVideoPlayerController?.dispose();
    }
    cachedVideoPlayerController =
        CachedVideoPlayerController.file(File(filePath.value))
          ..addListener(() {})
          ..setLooping(false);

    await cachedVideoPlayerController?.initialize();
    cachedVideoPlayerController?.play();
  }
}
