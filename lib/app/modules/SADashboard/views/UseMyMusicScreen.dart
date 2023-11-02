import 'dart:io';
import 'dart:math';
import 'package:champcash/Data/UserData.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/View/myVideoPlayer.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/app/modules/SADashboard/views/AR.dart';
import 'package:champcash/models/UseMySoundModel.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'UserProfileScreen.dart';

class UseMyMusicScreen extends StatefulWidget {
  final String soundImage, soundUserName, tblVideoSoundId, videoLink;
  const UseMyMusicScreen(
      {super.key,
      required this.soundImage,
      required this.soundUserName,
      required this.tblVideoSoundId,
      required this.videoLink});

  @override
  State<UseMyMusicScreen> createState() => _UseMyMusicScreenState();
}

class _UseMyMusicScreenState extends State<UseMyMusicScreen> {
  List<USMSDatum> useMySoundList = [];

  @override
  void initState() {
    super.initState();
    callingUseMySoundAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      appBar: AppBar(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        title: Text(
          "Audio",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: ColorConstants.APPPRIMARYWHITECOLOR),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorConstants.APPPRIMARYWHITECOLOR,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            soundDetailUI(),
            CommonButton(
                height: 40,
                backgroundColor: ColorConstants.appPrimaryColor,
                text: "Use Audio",
                onPressed: () {
                  EasyLoading.show(status: "Loading");
                  callingVideoConvertIntoAudio();
                }).paddingOnly(left: 25, right: 40, top: 15, bottom: 8),
            GridView.builder(
                shrinkWrap: true,
                itemCount: useMySoundList.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisExtent: 160),
                itemBuilder: (c, inddx) {
                  USMSDatum d = useMySoundList.elementAt(inddx);
                  return GestureDetector(
                    onTap: () {
                      Get.to(UseMusicVideosDetails(
                          index: inddx, list: useMySoundList));
                    },
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        elevation: 4,
                        shadowColor: ColorConstants.APPPRIMARYWHITECOLOR,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: NetworkImageView(
                            imgUrl: d.videoThumb,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }).paddingOnly(left: 25, top: 10)
          ],
        ),
      ),
    );
  }

  soundDetailUI() {
    return Row(
      children: [
        Card(
          shadowColor: ColorConstants.APPPRIMARYWHITECOLOR,
          elevation: 4,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                  height: 80,
                  width: 80,
                  child: NetworkImageView(
                    imgUrl: widget.soundImage,
                    fit: BoxFit.cover,
                  ))).paddingAll(0.10),
        ),
        addPadding(20, 0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Original audio",
              style: textStyleW500(
                  fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR),
            ),
            addPadding(0, 5),
            Text(
              widget.soundUserName,
              style: textStyleW500(
                  fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR),
            ),
          ],
        )
      ],
    ).paddingOnly(left: 25, top: 20);
  }

  void callingUseMySoundAPI() {
    useMySoundAPI({"tbl_video_sound_id": widget.tblVideoSoundId}).then((value) {
      if (value.status) {
        UseMySoundModel m = value.data;
        useMySoundList = m.data;
        setState(() {});
      } else {
        showErrorBottomSheet(value.message);
      }
    });
  }

  void callingVideoConvertIntoAudio() async {
    var conAudiofile =
        "videoConv${DateTime.now().microsecondsSinceEpoch}.mp3"; //Uri.parse(url).pathSegments.last;
    final directory1 = await getExternalStorageDirectory();
    // print("DOWNLOADEDPATH${directory!.path}");
    File outAudioPath = File('${directory1!.path}/$conAudiofile');
    print("HGDHJGDHGD$outAudioPath");
    var request1 = await http.get(Uri.parse(widget.videoLink));
    var bytes1 = request1.bodyBytes;
    await outAudioPath.writeAsBytes(bytes1);
    //String command = '-i $videoPath $outAudioPath';
    //  String command = '-i $videoPath -ab 128k -ac 2 -ar 44100 -vn $outAudioPath';

    // FFmpegKit.execute(command).then((value) async {
    //   final returnCode = await value.getReturnCode();
    //   if (returnCode!.isValueSuccess()) {
    //     print("HGDHJGDHGD$outAudioPath");
    //   }
    // });
    EasyLoading.dismiss();
    Get.to(ARCameraRecordingScreen(
      videoLink: outAudioPath.path,
      tblVideoSoundId: widget.tblVideoSoundId,
    ))!
        .then((value) async {
      await File(outAudioPath.path).delete(recursive: true);
    });
  }
}

class UseMusicVideosDetails extends StatefulWidget {
  final int index;
  final List<USMSDatum> list;
  const UseMusicVideosDetails(
      {super.key, required this.index, required this.list});

  @override
  State<UseMusicVideosDetails> createState() => _UseMusicVideosDetailsState();
}

class _UseMusicVideosDetailsState extends State<UseMusicVideosDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      controller: PageController(
          initialPage: widget.index, keepPage: true, viewportFraction: 1),
      allowImplicitScrolling: true,
      onPageChanged: (page) {
        videoStatusUpdate.add(page);
      },
      itemBuilder: (context, index) {
        USMSDatum model = widget.list.elementAt(index);
        bool val = model.videoLikes == "no" ? false : true;
        return Stack(
          children: [
            SizedBox(
                height: double.infinity,
                child: myVideoPlayer(
                  url: model.video,
                  index: index,
                  videoThumb: model.videoThumb,
                )),
            Positioned(
                left: 8,
                right: 8,
                bottom: 60,
                child: GestureDetector(
                  onTap: () {
                    if (userLoginModel!.data.userId.toString() !=
                        model.userId.toString()) {
                      final pCont = Get.find<ProfileController>();
                      pCont.onInit1(model.userId);
                      pCont.profileVisibilityVal.value = false;
                      pCont.mLikedlist.clear();
                      pCont.userVideosList.clear();

                      Get.to(UserProfileScreen(
                        userId: model.userId,
                      ));
                    }
                  } /* => controller.bottomIndex.value=2*/,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              model.userImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 5),
                                child: Text(
                                  model.username,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
      itemCount: widget.list.length,
      scrollDirection: Axis.vertical,
    ));
  }
}
