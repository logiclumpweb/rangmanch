
import 'dart:async';
import 'dart:typed_data';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/shared/SHVideoPlayer.dart';
import 'package:champcash/shared/SHVideoPlayerNew.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Apis/api.dart';
import '../controller/DashBoardController.dart';
import '../shared/extras.dart';
import '../models/ReelVideoListModel.dart';
import '../shared/videoplayer_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<VideoDatum> reelVideoModelList = [];
  // List<CachedVideoPlayerController?> cachedVideoPlayerController = [];

  List<CachedVideoPlayerController?> cachedVideoPlayerList = [];
  List<StreamController<int>> cachedVideoPlayer = [];

  // final StreamController<int> selected = StreamController<int>.broadcast();

  // DashBoardController mController=Get.find<DashBoardController>();
  Uint8List? imgBytes;
  List<String> name = ["Ramesh", "Ankit"];
  bool isInitialized = false;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    onInit1();
    pageController.addListener(() {
      AxisDirection direction = pageController.position.axisDirection;
      print(direction);
    });
  }

  Future<void> onInit1() async {
    var hashMap = {"user_id": "231"};
    reelVideoListAPI(hashMap).then((value) {
      setState(() {
        if (value.status) {
          VideoListModel model = value.data;
          List<VideoDatum> list = model.data;
          reelVideoModelList = list;
          cachedVideoPlayer = List.generate(reelVideoModelList.length, (index) => StreamController<int>.broadcast());
        } else {
          showErrorBottomSheet(value.message.toString());
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    DashBoardController mController = Get.find<DashBoardController>();
    return Stack(children: [
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35)),
            child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reelVideoModelList.length,
                itemBuilder: (ctx, index) =>
                    VideoPlayerView(model: reelVideoModelList[index]))),
      ),

      Positioned(
          top: 40, right: 0,
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.AR_GEAR),
            child: Container(
            height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              ),
              child: const Icon(Icons.camera_alt, color: Colors.orange,),
      ),
          ))

    ],);
  }

  headingsUI(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SACellRoundContainer(
            color: const Color(0xff000000).withOpacity(0.5),
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
              child: headingText(
                  align: TextAlign.start,
                  title: title,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  fontWeight: FontWeight.w500),
            ),
            radius: 20,
            borderWidth: 0,
            borderWidthColor: Colors.transparent),
      ),
    );
  }
}

class InstaVideoViewPlayer extends StatefulWidget {
  final VideoDatum model;

  const InstaVideoViewPlayer({super.key, required this.model});

  @override
  State<InstaVideoViewPlayer> createState() => _InstaVideoViewPlayerState();
}

class _InstaVideoViewPlayerState extends State<InstaVideoViewPlayer> {
  late CachedVideoPlayerController cachedVideoPlayerController;
  VideoDatum? element;
 // DashBoardController mController = Get.find<DashBoardController>();

  @override
  void initState() {
    super.initState();
    setState(() {
      element = widget.model;
      loadVideoPlayer(element);
    });
  }

  loadVideoPlayer(VideoDatum? element) async {
    String url = element!.video;
    cachedVideoPlayerController = CachedVideoPlayerController.network(url)
      ..addListener(() {})
      ..setLooping(true)
      ..initialize().then((value) {
        cachedVideoPlayerController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addPadding(0, 10),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SACellRoundContainer1(
                    color: Colors.black12,
                    height: 50,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipOval(
                          child: Image.network(
                        element!.userImage,
                        fit: BoxFit.fitHeight,
                      )),
                    ),
                    radius: 60,
                    borderWidth: 1.5,
                    borderWidthColor: const Color(0xff3E57B4)),
              ),
            ),
            addPadding(15, 0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: headingText(
                        title: element!.username,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber),
                  ),
                  addPadding(0, 2),
                /*  Align(
                    alignment: Alignment.centerLeft,
                    child: headingText(
                        title: "${element!.},${element!.country}",
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                        align: TextAlign.start),
                  ),*/
                ],
              ),
            )
          ],
        ),
        addPadding(0, 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              /* Get.toNamed(Routes.AdDESCRIPE,arguments: {"tblUserId":element!.tblUserId.toString(),"tblAdsId":element!.tblAdsId})!.then((value){
              mController.reelVideoModelList.clear();
              mController.onInit1();
            });*/
            },
            child: Column(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    // SizedBox(height: 280,width: double.infinity,child: mController.loadingWidget(url),),
                    SizedBox(
                      child: CachedVideoPlayer(cachedVideoPlayerController),
                    ),
                    Center(
                        child: SACellRoundContainer1(
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            radius: 20,
                            borderWidth: 1,
                            borderWidthColor: Colors.white))
                  ],
                )),
                addPadding(0, 10),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          addPadding(15, 0),
                          GestureDetector(
                            onTap: () {
                          /*      String type=element!.youLIke=="no"?"like":"unlike";
                        var hashMap={"tbl_ads_video_id":element!.tblAdsId.toString(),"type":type,"tbl_user_id":
                        viewLoginDetail!.data.first.tblUserId.toString()};
                        print(hashMap);
                               favoriteUnFavoriteAPI(hashMap).then((value){
                          if(value.status){
                            setState(() {
                              if(value.type=="like"){
                                element!.youLIke="yes";
                                int likeCount=element!.totalLikes+1;
                                element!.totalLikes=likeCount;
                              }else{
                                element!.youLIke="no";
                                int likeCount=element!.totalLikes-1;
                                element!.totalLikes=likeCount;
                              }
                            });
                            toastMessage(value.message.toString());
                          }else{
                            showErrorBottomSheet(value.message.toString());
                          }
                        });*/
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(55),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(2, 3),
                                          blurRadius: 4,
                                          color: Colors.grey.withOpacity(0.8))
                                    ]),
                                child: Icon(
                                  element!.videoLikes == "yes"
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Colors.red.withOpacity(0.8),
                                  size: 26,
                                )),
                        ),
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55),
                                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(2, 3),
                                        blurRadius: 4,
                                        color: Colors.grey.withOpacity(0.8))
                                  ]),
                              child: const Icon(
                                Icons.share_outlined,
                                color: Color(0xff1D5990),
                                size: 25,
                              )),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: "Price -",
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: ColorConstants
                                              .APPPRIMARYBLACKCOLOR),
                                      children: [
                                    TextSpan(
                                        text: "${"element!.adsPrice"}/-",
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xffB5E668)))
                                  ])),
                              headingText(
                                  align: TextAlign.start,
                                  title: "Highest Bid - ₹85,000/-",
                                  color: ColorConstants.APPPRIMARYBLACKCOLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: headingText(
                              title: "${element!.likes} likes",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.APPPRIMARYBLACKCOLOR),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                text: "Manisha Negi ",
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstants.APPPRIMARYBLACKCOLOR),
                                children: [
                                  TextSpan(
                                      text: element!.tag,
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstants
                                              .APPPRIMARYBLACKCOLOR))
                                ]),
                            maxLines: 4,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: headingText(
                              title: element!.videoViewCount,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.APPPRIMARYBLACKCOLOR),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        addPadding(0, 10),
      ],
    );
  }
}

class LocationWiseProductView extends StatelessWidget {
  const LocationWiseProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SACellGradientContainer(
        width: double.infinity,
        child: SafeArea(
            child: Column(
          children: [
            addPadding(0, 10),
            iAPPBARUI(),
            addPadding(0, 10),
            Expanded(
                child: SACellUperRoundContainer(
                    width: double.infinity,
                    child: Column(
                      children: [
                        //  addPadding(0, 20),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(55),
                                        topRight: Radius.circular(55)),
                                    child: Image.network(
                                      "https://s3-alpha-sig.figma.com/img/c28b/45f3/3b61bcd9daba8fb2b24024553b6bdebf?Expires=1668384000&Signature=L1etsj4hzOCtyj5kotWIyzPBdtTTVKWMcuRX1qXOmuJkBwpcXjnH4rh6UdmZ0FkpNjd9Zjq6QiagJXPXrXYOTPOQsU45L3mXcGgkEkpn0gfpZGqnB757WJu9bHeXZo8oeKcrlhPg6~xJcKwS5rvKPoXvWQ1z1TEzH0r8ZbxGQZteaG1V81ucd9ETeZjsVwrB8rEYvFK-b~-2oPtIyEsin3xIuwuhfv3ogWN8iAo7VHCNBH2etYgdn6fBHV0c70mK7tQhHapfvFcEswD5ngdiu6kSWZEorV4uFI644qsHTSxCtkEA8T-GoR4jFeZv~rYRYVboqlwnXF5tUizt4Wedzg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA",
                                      fit: BoxFit.fitHeight,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20.0, left: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Expanded(child: SizedBox()),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 110,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Color(0xff5AB439),
                                                      Color(0xff67BB40),
                                                      Color(0xff8BCF52),
                                                      Color(0xffB5E668),
                                                    ])),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/listview.png",
                                                    height: 20,
                                                    width: 20,
                                                    color: ColorConstants
                                                        .APPPRIMARYWHITECOLOR,
                                                  ),
                                                  headingText(
                                                      title: "List View",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorConstants
                                                          .APPPRIMARYWHITECOLOR),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        addPadding(0, 12),
                                        Row(
                                          children: [
                                            SACellRoundContainer(
                                                height: 115,
                                                width: 105,
                                                color: const Color(0xff3E57B4),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.network(
                                                        "https://s3-alpha-sig.figma.com/img/e745/060c/f4413139bcac72b7f8f37ae944df0937?Expires=1668384000&Signature=bGlP3kc7m4HeB9-tcZ2jyzkA6q99RwW7wqE8VnOo5A7AQR2cjVAFQvvxILc~gg1tKDW2RUU~d~pxqwuhTLXJvdMHlrw4vl9Sfj05ef6MNuPCtquET7xD0-G3wCcY5Wjs5T7Is68W9iWzWg9rY8LbIW9vcve5YyDzpz6ch6kbE97qgxLE56-2pB-wYe507pUeg8Eb76UpDjJauv~TZ9qU70d0UwRg0Ogk0Gnzb5aoJIQ5lOHRKMM0s2PN4NY5OWCg~bhP5k5WhXiw0UILV-NVVoXmpPY2kW~dpja6n11QdobuGfevYf5U3ppt6~Xm6sPLgR3k3Q6eXeCro9IVo1Wldg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA",
                                                        height: 95,
                                                        fit: BoxFit.fill,
                                                        width: 115,
                                                      ),
                                                    ),
                                                    addPadding(0, 5),
                                                    headingFullText(
                                                        title:
                                                            "Price - ₹90000/-",
                                                        fontSize: 8,
                                                        color: ColorConstants
                                                            .APPPRIMARYWHITECOLOR),
                                                    addPadding(0, 5),
                                                  ],
                                                ),
                                                radius: 6,
                                                borderWidth: 0,
                                                borderWidthColor:
                                                    Colors.transparent),
                                            addPadding(5, 0),
                                            SACellRoundContainer(
                                                height: 115,
                                                width: 105,
                                                color: const Color(0xff3E57B4),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.network(
                                                        "https://s3-alpha-sig.figma.com/img/e745/060c/f4413139bcac72b7f8f37ae944df0937?Expires=1668384000&Signature=bGlP3kc7m4HeB9-tcZ2jyzkA6q99RwW7wqE8VnOo5A7AQR2cjVAFQvvxILc~gg1tKDW2RUU~d~pxqwuhTLXJvdMHlrw4vl9Sfj05ef6MNuPCtquET7xD0-G3wCcY5Wjs5T7Is68W9iWzWg9rY8LbIW9vcve5YyDzpz6ch6kbE97qgxLE56-2pB-wYe507pUeg8Eb76UpDjJauv~TZ9qU70d0UwRg0Ogk0Gnzb5aoJIQ5lOHRKMM0s2PN4NY5OWCg~bhP5k5WhXiw0UILV-NVVoXmpPY2kW~dpja6n11QdobuGfevYf5U3ppt6~Xm6sPLgR3k3Q6eXeCro9IVo1Wldg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA",
                                                        height: 95,
                                                        fit: BoxFit.fill,
                                                        width: 115,
                                                      ),
                                                    ),
                                                    addPadding(0, 5),
                                                    headingFullText(
                                                        title:
                                                            "Price - ₹90000/-",
                                                        fontSize: 8,
                                                        color: ColorConstants
                                                            .APPPRIMARYWHITECOLOR),
                                                    addPadding(0, 5),
                                                  ],
                                                ),
                                                radius: 6,
                                                borderWidth: 0,
                                                borderWidthColor:
                                                    Colors.transparent),
                                            addPadding(5, 0),
                                            SACellRoundContainer(
                                                height: 115,
                                                width: 105,
                                                color: const Color(0xff3E57B4),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.network(
                                                        "https://s3-alpha-sig.figma.com/img/e745/060c/f4413139bcac72b7f8f37ae944df0937?Expires=1668384000&Signature=bGlP3kc7m4HeB9-tcZ2jyzkA6q99RwW7wqE8VnOo5A7AQR2cjVAFQvvxILc~gg1tKDW2RUU~d~pxqwuhTLXJvdMHlrw4vl9Sfj05ef6MNuPCtquET7xD0-G3wCcY5Wjs5T7Is68W9iWzWg9rY8LbIW9vcve5YyDzpz6ch6kbE97qgxLE56-2pB-wYe507pUeg8Eb76UpDjJauv~TZ9qU70d0UwRg0Ogk0Gnzb5aoJIQ5lOHRKMM0s2PN4NY5OWCg~bhP5k5WhXiw0UILV-NVVoXmpPY2kW~dpja6n11QdobuGfevYf5U3ppt6~Xm6sPLgR3k3Q6eXeCro9IVo1Wldg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA",
                                                        height: 95,
                                                        fit: BoxFit.fill,
                                                        width: 115,
                                                      ),
                                                    ),
                                                    addPadding(0, 5),
                                                    headingFullText(
                                                        title:
                                                            "Price - ₹90000/-",
                                                        fontSize: 8,
                                                        color: ColorConstants
                                                            .APPPRIMARYWHITECOLOR),
                                                    addPadding(0, 5),
                                                  ],
                                                ),
                                                radius: 6,
                                                borderWidth: 0,
                                                borderWidthColor:
                                                    Colors.transparent),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    )))
          ],
        )));
  }

  iAPPBARUI() {
    return Row(
      children: [
        SABackButton(
            onPressed: () {}, color: ColorConstants.APPPRIMARYWHITECOLOR),
        addPadding(19, 0),
        headingText(
            title: "Preet Vihar, East Delhi",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: ColorConstants.APPPRIMARYWHITECOLOR),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.location_searching,
              color: Color(0xffF3A455),
            )),
      ],
    );
  }
}

/*class VideoPlayerView extends StatefulWidget {
  final VideoDatum model;

  const VideoPlayerView({Key? key, required this.model}) : super(key: key);

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late CachedVideoPlayerController cachedVideoPlayerController;
  VideoDatum? element;


  int? index1;

  @override
  void initState() {
    setState(() {
      element = widget.model;
      loadVideoPlayer();
    });
    super.initState();
  }

  loadVideoPlayer() async {
    String url = element!.video;
    cachedVideoPlayerController = CachedVideoPlayerController.network(url)
      ..addListener(() {})
      ..setLooping(true)
      ..initialize().then((value) {
        cachedVideoPlayerController.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    cachedVideoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: cachedVideoPlayerController.value.aspectRatio,
              child: CachedVideoPlayer(cachedVideoPlayerController),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 3, bottom: 80),
          child: Align(
              alignment: Alignment.bottomRight,
              child: headingText(
                  title: 'Make a Bid',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.APPPRIMARYWHITECOLOR)),
        ),
        *//*   makeBidButtonUI(),
        undefineButtonUI(),
        shareButtonUI(),
        videoReportButtonUI(),
        favoriteButtonUI(),*//*
    *//*    Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 25, bottom: 320),
          child: Align(
              alignment: Alignment.bottomRight,
              child: headingText(
                  title: "${element!.likes}",
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  fontSize: 11)),
        ),*//*
        *//* Column(
          children: [
           // allCategoriesUI(),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: GestureDetector(
                      onTap: (){
                        Get.to(const LocationWiseProductView());
                      },
                      child: Container(
                          height: 45,
                          width: 45,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Image.asset(
                              locationScreenImg,
                              height: 45,
                              width: 45,
                            ),
                          )),
                    )),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SACellRoundContainer1(
                        color: ColorConstants.APPPRIMARYWHITECOLOR,
                        height: 70,
                        width: 70,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipOval(
                              child: Image.network(
                                element!.userImage,
                                fit: BoxFit.fitHeight,
                              )),
                        ),
                        radius: 60,
                        borderWidth: 0,
                        borderWidthColor: Colors.transparent),
                  ),
                ),
                addPadding(15, 0),
                headingText(title: element!.fullName,fontSize: 22,fontWeight: FontWeight.w600,
                    color: ColorConstants.APPPRIMARYWHITECOLOR)
              ],
            ),
          //  headingsUI(element!.adsTitle),

            Padding(
              padding: const EdgeInsets.only(left:18.0,top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SACellRoundContainer(
                    color: const Color(0xff000000).withOpacity(0.5),
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 9,right: 8),
                      child: RichText(text:  TextSpan(text: "Price -",style: GoogleFonts.inter(
                          fontSize: 13,fontWeight: FontWeight.w700,color: ColorConstants.APPPRIMARYWHITECOLOR
                      ),children: [
                        TextSpan(text: "${element!.adsPrice}/-",style: GoogleFonts.inter(
                            fontSize: 13,fontWeight: FontWeight.w700,color: Color(0xffB5E668)
                        ))
                      ])),
                    ),
                    radius: 20,
                    borderWidth: 0,
                    borderWidthColor: Colors.transparent),
              ),
            ),
         //   headingsUI("Highest Bid -85,000"),
            Padding(
              padding: const EdgeInsets.only(left:18.0,top: 5,bottom: 80),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,top: 4,right: 8),
                  child: headingText(
                      align: TextAlign.start,
                      title: element!.createdDate,
                      color: ColorConstants.APPPRIMARYWHITECOLOR,fontWeight: FontWeight.w600,fontSize: 10),
                ),
              ),
            ),

          ],
        )*//*
      ],
    );
  }

*//*makeBidButtonUI() {
    return   Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 10,bottom: 95),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: GestureDetector(
              onTap: ()async{
                print(viewLoginDetail!.data.first.email);
                final QuerySnapshot result=await firebaseFirestore.collection(FireStoreConstants.pathUserCollection).where(FireStoreConstants.id,
                    isEqualTo: FireStoreConstants.id).get();
                final List<DocumentSnapshot>documents=result.docs;
                if(documents.isEmpty) {

                  DataBase.addUser(viewLoginDetail!.data.first.email,
                      viewProfileDetail!.data.first.fullName,viewProfileDetail!.data.first.userImage).then((value) {
                    DataBase.addUser(element!.email, element!.fullName,element!.userImage).then((value){
                      Get.toNamed(Routes.CONVERSION,arguments: [{FireStoreConstants.nickname:element!.fullName.toString()},
                        {FireStoreConstants.id:element!.email.toString()},
                        {FireStoreConstants.photoUrl:element!.userImage.toString()}]);
                    });
                  });
                }else{
                 *//* *//*
                 Get.toNamed(Routes.CONVERSION,arguments: [{FireStoreConstants.nickname:element!.fullName.toString()},
                    {FireStoreConstants.id:element!.email.toString()},
                    {FireStoreConstants.photoUrl:element!.userImage.toString()}]);*//* *//*
                }

              },
              child: Container(
                  height: 40,
                  width: 40,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(makeBidIcon,height: 30,width: 30,
                      color: Color(0xff3E57B4),),
                  )),
            )),
      ),
    );
  }*//*
 *//*undefineButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 10,bottom: 150),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: Container(
                height: 40,
                width: 40,
                color: ColorConstants.APPPRIMARYWHITECOLOR,
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(changeUiIcon,height: 30,width: 30,
                    color: Color(0xff3E57B4),),
                ))),
      ),
    );
  }*//*
  shareButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 10,bottom: 210),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: Container(
                height: 40,
                width: 40,
                color: ColorConstants.APPPRIMARYWHITECOLOR,
                child:  Image.asset("https://img.icons8.com/ios-glyphs/30/null/delete-sign.png",color: const Color(0xff3E57B4)))),
      ),
    );
  }


  videoReportButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 10,bottom: 270),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: GestureDetector(
              onTap: (){
                videoReportBottomSheetUI(element?.tblVedioId.toString());
              },
              child: Container(
                  height: 40,
                  width: 40,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  child: Image.network("https://cdn-icons-png.flaticon.com/128/745/745419.png")),
            )),
      ),
    );
  }


*//*  favoriteButtonUI() {
    return  Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 10,bottom: 340),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: GestureDetector(
              onTap: (){
                String type=element!.youLIke=="no"?"like":"unlike";
                var hashMap={"tbl_ads_video_id":element!.tblAdsId.toString(),"type":type,"tbl_user_id":
                viewLoginDetail!.data.first.tblUserId.toString()};
                print(hashMap);
                favoriteUnFavoriteAPI(hashMap).then((value){
                  if(value.status){
                    setState(() {
                      if(value.type=="like"){
                        element!.youLIke="yes";
                        int likeCount=element!.totalLikes+1;
                       element!.totalLikes=likeCount;
                      }else{
                        element!.likes="no";
                        int likeCount=element!.totalLikes-1;
                        element!.videoLikes=likeCount as String;
                      }
                    });
                    toastMessage(value.message.toString());
                  }else{
                    showErrorBottomSheet(value.message.toString());
                  }
                });
              },
              child: Container(
                  height: 40,
                  width: 40,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  child: element!.likes=="no"?Icon(Icons.favorite_border_outlined,color: Colors.red.withOpacity(0.8),size: 26,):
                  Icon(Icons.favorite,color: Colors.red.withOpacity(0.8),size: 26,)),
            )),
      ),
    );
  }*//*
*//*allCategoriesUI() {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 25),
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                Get.to(const AddFilterView());
              },
              child: SizedBox(
                child: Image.asset(
                  categoryMenuIcon,
                  height: 24,
                  width: 24,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                ),
              ),
            ),
            addPadding(20, 0),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mController.adsCategoriesModelList.length??0,itemBuilder: (_,index){
                ACDatum element=mController.adsCategoriesModelList.elementAt(index);
                if(index1==index){
                  element.isSelected=true;
                }else{
                  element.isSelected=false;
                }
                return Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: GestureDetector(
                    onTap: (){
                   setState(() {
                     index1=index;
                   });
                    },
                    child: SACellRoundContainer1(
                        height: 40,
                        width: 90,
                        color: element.isSelected?ColorConstants.APPPRIMARYWHITECOLOR:Colors.transparent,
                        child: Center(
                            child: headingText(
                                title: element.categoryName,
                                color: element.isSelected?ColorConstants.APPPRIMARYBLACKCOLOR:ColorConstants.APPPRIMARYWHITECOLOR,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        radius: 20,
                        borderWidth: 1,
                        borderWidthColor: ColorConstants.APPPRIMARYWHITECOLOR),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }*//*
  headingsUI(String title) {
    return Padding(
      padding: const EdgeInsets.only(left:18.0,top: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SACellRoundContainer(
            color: const Color(0xff000000).withOpacity(0.5),
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(left:8.0,top: 8,right: 8),
              child: headingText(
                  align: TextAlign.start,
                  title: title,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,fontWeight: FontWeight.w500),
            ),
            radius: 20,
            borderWidth: 0,
            borderWidthColor: Colors.transparent),
      ),
    );
  }

*//* Future<Uint8List>getVideoThumbnail(String url) async{
    String? fileName = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
      350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
     print("Hii2222");
    final file = File(fileName);
    Uint8List u= file.readAsBytesSync();
    return u;
  }*//*

*//*Widget thumbnailWidget(String url) {
    return FutureBuilder<Uint8List>(
      future: getVideoThumbnail(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!,fit: BoxFit.cover);
        } else if (snapshot.hasError) {
          print('${snapshot.error}');
          return const Center(
              child: Text('❌', style: TextStyle(fontSize: 72.0)));
        } else {
          return  Center(child:Image.network("https://cdn-icons-png.flaticon.com/512/4644/4644293.png",
            height: 70,width: 70,));
        }
      },
    );
  }*//*


  void videoReportBottomSheetUI(String? tblAdsId) {
    Get.bottomSheet(Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  headingText(
                      title: "Report",
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: const Color(0xff262626)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(2, 3),
                                    blurRadius: 4,
                                    color: Colors.grey.withOpacity(0.8))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.network(
                              "https://img.icons8.com/ios-glyphs/30/null/delete-sign.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addPadding(0, 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "Select a problem to report",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingFullText(
                      title:
                      "We won’t let the person know who reported them.if someone is in immediate danger, call local emergency services. Don’t wait",
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      color: const Color(0xff434343)),
                ),
              ),

              addPadding(0, 10),

              *//*Wrap(
                direction: Axis.horizontal,
                children: videoRtContentModelList.map((e){
                  Color? color,color1;
                  if(isSelectedValue.value==e.reportContent){
                    color=const Color(0xffED5762);
                    color1=ColorConstants.APPPRIMARYWHITECOLOR;
                  }else{
                    color1=const Color(0xff434343);
                    color=Colors.grey[100];
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      addPadding(5, 15),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: (){
                            isSelectedValue.value=e.reportContent;
                            reportValueId.value=e.tblReportContentId;
                          },
                          child: SACellRoundContainer(
                              height: 40,
                              color: color,
                              child: Padding(
                                padding: const EdgeInsets.only(left:12.0,right: 12),
                                child: Center(
                                  child: headingText(title: e.reportContent,fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color:color1),
                                ),
                              ), radius: 30, borderWidth: 0,
                              borderWidthColor: Colors.transparent),
                        ),
                      ),
                      addPadding(5, 15),
                    ],
                  );
                }).toList(),),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GradientRedButton2(text: "SUBMIT", onPressed: (){
                  var hashMap={"tbl_user_id":viewLoginDetail!.data.first.tblUserId,"tbl_report_content_id":reportValueId.value.toString(),
                    "tbl_ads_id":tblAdsId!};
                  submitVideoReportAPI(hashMap).then((value){
                    if(value.status){
                      toastMessage(value.message.toString());
                      Get.back();
                    }else{
                      showErrorBottomSheet(value.message.toString());
                    }
                  });
                }),
              )*//*
            ],
          ),
        )
      ],
    )));
  }
}*/
