import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/Apis/api/base_api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/models/ReelVideoListModel.dart';
import 'package:champcash/shared/extras.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http_parser/http_parser.dart';

class AppController extends GetxController {
  final thumbnailList = RxMap<String, Uint8List>();
  final currentPageIndex = 0.obs,
      isForcePauseVal = false.obs,
      progressVIUploadingVal = false.obs,
      tokenVal = "".obs;

  ListResult? result;

  final fileDef = Rxn<File>();
  @override
  void onInit() {
    super.onInit();
    firebaseToken();
    //permissionHandler();
    //listAllFiles();
  }

  // permissionHandler() async {
  //   var status = await Permission.manageExternalStorage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.manageExternalStorage.request();
  //     if (!status.isGranted) {
  //       openAppSettings();
  //     }
  //   }
  // }

  listAllFiles() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child("ARFile");
    final Reference ref1 = storage.ref().child(ref.fullPath);
    try {
      result = await ref.listAll();
      //  result!.items.forEach((Reference r) async {
      final Reference ref1 = storage.ref().child(result!.items.first.fullPath);
      final Uint8List? data = await ref1.getData();
      saveFileLocally(data!, result!.items.first.name);
      //  });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveFileLocally(Uint8List data, String fileName) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final File localFile = File('${appDocDir.path}/$fileName');
      await localFile.writeAsBytes(data);

      final directory = await getExternalStorageDirectory();
      String filePath = '${directory!.path}/$fileName';

      fileDef.value = File(filePath);
      await fileDef.value?.create(recursive: true);
      Uint8List bytes = await localFile.readAsBytes();
      await fileDef.value?.writeAsBytes(bytes);
      print('File saved locally at ${fileDef.value?.path}');
    } catch (e) {
      print('Error saving file locally: $e');
    }
  }

  firebaseToken() async {
    await Get.putAsync<MyRestFulService>(() async => MyRestFulService());
    await FirebaseMessaging.instance.getToken().then((token) {
      tokenVal.value = token!;
      print("Tokennn${token}");
    });
  }

  createVideoThumbnails(List<VideoDatum> videoList) {
    for (var element in videoList) {
      getVideoThumbnail(element.video);
    }
  }

  Future<Uint8List> getVideoThumbnail(String url) async {
    if (thumbnailList.containsKey(url)) return thumbnailList[url]!;
    String? fileName = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    final file = File(fileName!);
    Uint8List u = file.readAsBytesSync();
    thumbnailList[url] = u;
    return u;
  }
}

class MyRestFulService extends GetxService {
  var url = '$apiHost/upload_vedio_api.php';
  fUploadingReelAPI(String filePath, String tagVal, String languageVal) async {
    Get.find<AppController>().progressVIUploadingVal.value = true;
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false, // It's false by default
    );
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: filePath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 60);

    File videoPath;
    if (mediaInfo != null) {
      videoPath = File(mediaInfo.file!.path);
    } else {
      videoPath = File(filePath);
    }
    final thumbFile = File(thumbnail!);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = userLoginModel!.data.userId; //'980';
    request.fields['tag'] = tagVal;
    request.fields['hash_tag'] = tagVal;
    request.fields['tbl_sound_id'] =
        Get.find<ArGearController>().tblVideoSoundId.value == ""
            ? 'self'
            : Get.find<ArGearController>().tblVideoSoundId.value;
    request.fields["orignal_video_id"] = request.fields['tbl_sound_id'] =
        Get.find<ArGearController>().tblVideoSoundId.value == ""
            ? ''
            : Get.find<ArGearController>().tblVideoSoundId.value;
    request.fields['type'] =
        Get.find<ArGearController>().tblVideoSoundId.value == ""
            ? 'self'
            : Get.find<ArGearController>().tblVideoSoundId.value;
    request.fields['channel_id'] = "0";
    request.fields['language_id'] = languageVal;

    print("RRRR${request.fields}");
    var fthumbnail = await http.MultipartFile.fromPath(
        "video_thumb", thumbFile.path,
        contentType: MediaType("image", "jpg"));
    request.files.add(fthumbnail);

    request.files
        .add(await http.MultipartFile.fromPath("video", videoPath.path));
    var response = await request.send();
    var response2 = await response.stream.toBytes();
    var responseString = String.fromCharCodes(response2);
    Map resJson = jsonDecode(responseString);
    if (resJson["status"] == "1") {
      await File(filePath).delete();
      EasyLoading.showToast('Video uploaded successfully');
      Get.find<AppController>().progressVIUploadingVal.value = false;
      Get.delete<ArGearController>(force: true);
    } else {
      Get.find<AppController>().progressVIUploadingVal.value = false;
      await File(filePath).delete();
      showErrorBottomSheet(resJson["message"]);
      Get.delete<ArGearController>(force: true);
    }
  }
}
