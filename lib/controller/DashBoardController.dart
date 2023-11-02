


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

import '../Apis/api.dart';
import '../shared/extras.dart';
import '../models/ReelVideoListModel.dart';

class DashBoardController extends GetxController{
  final bottomNavIndex=0.obs;
  final isVisibilityFullView=true.obs,isVisibilityListViewView=false.obs,
      isVisibilityLocationView=false.obs,isVisibilityAppBarUI=true.obs,isSelectedValue="".obs,reportValueId=00.obs;
  //RxList<RLDatum>reelVideoModelList=<RLDatum>[].obs;
  final currentAddressValue="".obs,isMoreLoading=false.obs;
  final pageNumberVal=1.obs,pageSizeValue=10.obs,noOfNotificationValue="0".obs;

 /* Position? currentPosition;
  RxList<ACDatum> adsCategoriesModelList=<ACDatum>[].obs;
  RxList<RCTDatum> videoRtContentModelList=<RCTDatum>[].obs;*/






  /*updateIndex(int pos){
    bottomNavIndex.value=pos;
    if(bottomNavIndex.value!=0){
      isVisibilityAppBarUI.value=false;
    }else{
      isVisibilityAppBarUI.value=true;
    }
    getNotificationCountAPI().then((value){
      if(value.status){
        noOfNotificationValue.value=value.data;
      }else{
        showErrorBottomSheet(value.message.toString());
      }
    });
  }*/


/*  @override
  void onInit() {
    super.onInit();
    getCurrentPosition().then((value){
      onInit1();
      adsCategoryAPIs();
      videoRprtContentAPIs();
    });

  }*/



 /* void adsCategoryAPIs() {
    adsCategoryAPI().then((value){
        if(value.status){
          AdsCategoriesModel model=value.data;
          List<ACDatum>list=model.data;
          adsCategoriesModelList.value=list;
        }else{
          showErrorBottomSheet(value.message.toString());
        }
    });
 //   getProfileDetailAPIs();
  }*/

/*  Future<void> onInit1()async{
    var hashMap={"tbl_user_id":"12",
    "pagesize":"1"};
    print(hashMap);
    reelVideoListAPI(hashMap).then((value){
      if(value.status){
        ReelVideoListModel model=value.data;
        List<RLDatum>list=model.data;
        reelVideoModelList.value=list;
      }else{
        showErrorBottomSheet(value.message.toString());
      }
    });
  }*/



    Future<Uint8List>getVideoThumbnail(String url) async{
      String? fileName = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight:
        350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      print("Hii2222");
      final file = File(fileName!);
      Uint8List u= file.readAsBytesSync();
      return u;
    }


  Widget thumbnailWidget(String url) {
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
  }

/* Future<bool>handleLocationPermission()async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      showErrorBottomSheet("Location services are disabled. Please enable the services");
      return false;
    }
    permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission==LocationPermission.denied) {
        showErrorBottomSheet( "Location permissions are denied");
        return false;
      }
    }
    if(permission==LocationPermission.deniedForever){
      showErrorBottomSheet("Location permissions are permanently denied, we cannot request permissions.");
    }
    return true;
  }*/
/*  Future<void>getCurrentPosition()async{
    final hasPermission=await handleLocationPermission();
    if(!hasPermission)return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position){
      currentPosition=position;
      getAddressFromLatLng(currentPosition!);
    });
  }
  Future<void>getAddressFromLatLng(Position position)async{
    await placemarkFromCoordinates(currentPosition!.latitude,currentPosition!.longitude).then((List<Placemark> placeMarks){

      Placemark place = placeMarks[0];
      currentAddressValue.value =
      '${place.subLocality}, ${place.locality}';


    }).catchError((e){
      print(e);
    });
  }*/
 /*Future<void> getProfileDetailAPIs() async {
    APIResponse response = await getProfileDetailAPI(
        {"tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString()});
    if (response.status) {
      ProfileDetailModel model = response.data;
      viewProfileDetail = model;
    } else {
      showErrorBottomSheet(response.message.toString());
    }
  }

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
                              cancelIconUrl,
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

              Wrap(
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
              )
            ],
          ),
        )
      ],
    )));
  }

  videoRprtContentAPIs(){
    videoRprtContentListAPI().then((value){
      if(value.status){
          ReportContentModel model=value.data;
          List<RCTDatum>list=model.data;
          videoRtContentModelList.value=list;
      }else{
        showErrorBottomSheet(value.message.toString());
      }
    });
  }*/

}