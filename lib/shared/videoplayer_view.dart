import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'extras.dart';
import '../models/ReelVideoListModel.dart';

class VideoPlayerView extends StatefulWidget {
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




      ],
    );
  }
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


/*  favoriteButtonUI() {
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
  }*/
/*allCategoriesUI() {
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
  }*/
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

/* Future<Uint8List>getVideoThumbnail(String url) async{
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
  }*/

/*Widget thumbnailWidget(String url) {
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
  }*/


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

              /*Wrap(
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
              )*/
            ],
          ),
        )
      ],
    )));
  }
}