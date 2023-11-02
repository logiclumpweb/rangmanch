
import 'dart:async';
import 'package:champcash/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../Apis/api/api_imp.dart';
import '../../../Apis/api/base_api.dart';
import '../../../models/ReelVideoListModel.dart';
import '../../../models/common_models.dart';

class HomeController extends AppController {

  // final videoListModel = Rxn<VideoListModel>();

  final logger = Logger();
  final videoPlayerStack = RxList<PlayerModel>();

  final isPlaying = true.obs;
  final pageController = PageController();
  final pageNumber = 1.obs;
  final pageLoading = false.obs;

  final videoList = RxList<VideoDatum>();
  final currPlayerModel = Rxn<PlayerModel>();
  final activePlayers = RxList<PlayerModel>();
  final prevPlayers = RxList<PlayerModel>();
  final activePage = 0.obs;

  final bufferPageNumber = 1.obs;
  final int bufferSize = 5;

  @override
  void onInit() {
    super.onInit();
    getVideoList(pageNumber.value);
    pageController.addListener(() {
      if(pageController.position.pixels==pageController.position.maxScrollExtent){
        pageNumber.value +=1;
        getVideoList(pageNumber.value);
      }
    });
  }

  Future<void>getVideoList(page)async{
    pageLoading.value = true;
    ApiResponse apiResponse = await ApiImpl().getVideoListAPI({"user_id": "231", "pagenumber": page});
    if(apiResponse.status){
      if(pageNumber.value==1){
        VideoListModel mModel = apiResponse.data;
        videoList.value = mModel.data;
      }else{
        VideoListModel mModel = apiResponse.data;
        videoList.addAll(mModel.data);
        print('Length -------------------------------------${videoList.length}');
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}






//
// import 'dart:async';
//
// import 'package:cached_video_player/cached_video_player.dart';
// import 'package:champcash/app_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
//
// import '../../../Apis/api/api_imp.dart';
// import '../../../Apis/api/base_api.dart';
// import '../../../models/ReelVideoListModel.dart';
// import '../../../models/common_models.dart';
//
// class HomeController extends AppController {
//
//   // final videoListModel = Rxn<VideoListModel>();
//
//   final logger = Logger();
//   final videoPlayerStack = RxList<PlayerModel>();
//
//   final isPlaying = true.obs;
//   final pageController = PageController();
//   final pageNumber = 1.obs;
//   final pageLoading = false.obs;
//
//   final videoList = RxList<VideoDatum>();
//   final currPlayerModel = Rxn<PlayerModel>();
//   final activePlayers = RxList<PlayerModel>();
//   final prevPlayers = RxList<PlayerModel>();
//   final activePage = 0.obs;
//
//   final bufferPageNumber = 1.obs;
//   final int bufferSize = 5;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getVideoList(pageNumber.value);
//     pageController.addListener(() {
//
//       if(pageController.position.pixels==pageController.position.maxScrollExtent){
//         pageNumber.value +=1;
//         getVideoList(pageNumber.value);
//       }
//     });
//   }
//
//   Future<void>getVideoList(page)async{
//     pageLoading.value = true;
//     ApiResponse apiResponse = await ApiImpl().getVideoListAPI({"user_id": "231", "pagenumber": page});
//     if(apiResponse.status){
//       if(pageNumber.value==1){
//         VideoListModel mModel = apiResponse.data;
//         videoList.value = mModel.data;
//         // createVideoThumbnails(mModel.data);
//         // initializedPlayer(videoList);
//       }else{
//         VideoListModel mModel = apiResponse.data;
//         videoList.addAll(mModel.data);
//         // createVideoThumbnails(mModel.data);
//         // initializedPlayer(videoList);
//         print('Length -------------------------------------${videoList.length}');
//       }
//     }
//   }
//
//   initializedPlayer(buffVideoList, {bufferSize=5})async{
//     pageLoading.value = true;
//     for(int i=0; i< buffVideoList.length; i++){
//       VideoDatum element = buffVideoList.elementAt(i);
//       try{
//         CachedVideoPlayerController cache = CachedVideoPlayerController.network(element.video);
//         await cache.initialize();
//         await cache.setLooping(true);
//         videoPlayerStack.add(PlayerModel(model: element, cacheController: cache, isInitialized: true));
//       }catch(e){
//         logger.d(e);
//       }
//     }
//     pageLoading.value = false;
//   }
//
//   manageBuffer(int page)async{
//
//     if(pageController.position.userScrollDirection==ScrollDirection.reverse){
//       int upIndex = page-bufferSize;
//       int dnIndex = page+bufferSize;
//       if(upIndex>=0){
//         await videoPlayerStack.elementAt(upIndex).cacheController?.dispose();
//         videoPlayerStack.elementAt(upIndex).cacheController=null;
//         videoPlayerStack.elementAt(upIndex).isInitialized = false;
//       }
//       if(dnIndex<videoPlayerStack.length){
//
//         CachedVideoPlayerController cache = CachedVideoPlayerController.network(videoPlayerStack.elementAt(dnIndex).model.video);
//         await cache.initialize();
//         await cache.setLooping(true);
//         videoPlayerStack.elementAt(upIndex).cacheController = cache;
//
//         // await videoPlayerStack.elementAt(dnIndex).cacheController?.initialize();
//         // await videoPlayerStack.elementAt(dnIndex).cacheController?.setLooping(true);
//         videoPlayerStack.elementAt(dnIndex).isInitialized = true;
//       }
//     }
//
//
//     if(pageController.position.userScrollDirection==ScrollDirection.forward){
//       int upIndex = page-bufferSize;
//       int dnIndex = page+bufferSize;
//       if(upIndex>=0){
//
//         CachedVideoPlayerController cache = CachedVideoPlayerController.network(videoPlayerStack.elementAt(upIndex).model.video);
//         await cache.initialize();
//         await cache.setLooping(true);
//         videoPlayerStack.elementAt(upIndex).cacheController = cache;
//         videoPlayerStack.elementAt(upIndex).isInitialized = true;
//       }
//       if(dnIndex<videoPlayerStack.length){
//
//         await videoPlayerStack.elementAt(dnIndex).cacheController?.dispose();
//         videoPlayerStack.elementAt(dnIndex).cacheController=null;
//         videoPlayerStack.elementAt(dnIndex).isInitialized = false;
//       }
//     }
//
//     activePlayers.value = videoPlayerStack.where((e) => e.isInitialized==true).toList();
//
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
// }
//
//
