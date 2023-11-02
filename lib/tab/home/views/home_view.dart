import 'package:champcash/Data/global_constant.dart';
import 'package:champcash/models/ReelVideoListModel.dart';
import 'package:champcash/tab/home/views/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../Routes/AppRoutes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.isRegistered<HomeController>()?Get.find<HomeController>():Get.put(HomeController());
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => controller.videoList.isEmpty?const Center(child: CircularProgressIndicator(),)
              :Column(children: [
                Expanded(child:
                PageView.builder(
                controller: controller.pageController,
                allowImplicitScrolling: true,
                onPageChanged: (page){
                  Logger().d('Page-----------$page');
                  videoStatusUpdate.add(page);
                },
              itemBuilder: (context, index){
                VideoDatum model = controller.videoList.elementAt(index);
                return Stack(
                  children: [
                    SAVideoPlayerNew(url: model.video, index: index,videoThumb: model.videoThumb,),

                    Positioned(
                        left: 8, right: 8, bottom: 24,
                        child: Column(children: [
                          Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(model.userImage, width: 60, height: 60, fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),
                                      border: Border.all(color: Colors.white, width: 2)),
                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(model.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                          ],)
                        ],))
                  ],
                );
              }, itemCount: controller.videoList.length, scrollDirection: Axis.vertical,),),
          ],)),

          Positioned(
              top: 40, right: 0,
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.AR_GEAR),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration:  BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.orange,),
                ),
              )),
        ],
      ),
    );
  }
}

// import 'package:champcash/global_constant.dart';
// import 'package:champcash/models/ReelVideoListModel.dart';
// import 'package:champcash/shared/SHVideoPlayerNew.dart';
// import 'package:champcash/tab/home/views/videoPlayer.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import '../../../Routes/AppRoutes.dart';
// import '../controllers/home_controller.dart';
// import 'SHPlayer.dart';
//
// class HomeView extends GetView<HomeController> {
//   const HomeView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     Get.isRegistered<HomeController>()?Get.find<HomeController>():Get.put(HomeController());
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Obx(() => controller.videoPlayerStack.isEmpty?const Center(child: CircularProgressIndicator(),)
//           Obx(() => controller.videoList.isEmpty?const Center(child: CircularProgressIndicator(),)
//           :Column(children: [
//             Expanded(child: PageView.builder(
//               controller: controller.pageController,
//               allowImplicitScrolling: true,
//               onPageChanged: (page){
//                 Logger().d('Page-----------$page');
//                 videoStatusUpdate.add(page);
//               },
//               itemBuilder: (context, index){
//                 VideoDatum model = controller.videoList.elementAt(index);
//                 return Stack(
//                   children: [
//                     SAVideoPlayerNew(url: model.video, index: index,videoThumb: model.videoThumb,),
//
//                     Positioned(
//                         left: 8, right: 8, bottom: 24,
//                         child: Column(children: [
//                           Row(children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(60),
//                               child: Image.network(model.userImage, width: 60, height: 60, fit: BoxFit.fill,
//                                 errorBuilder: (context, error, stackTrace) => Container(
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),
//                                       border: Border.all(color: Colors.white, width: 2)),
//                                 ),),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(model.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
//                             ),
//                           ],)
//                         ],))
//                   ],
//                 );
//
//               }, itemCount: controller.videoList.length, scrollDirection: Axis.vertical,),),
//
//           ],)),
//
//           //Positioned(child: Obx(() => Text('${controller.videoPlayerStack.length}', style: Theme.of(context).textTheme.titleLarge,))),
//
//           Positioned(
//               top: 40, right: 0,
//               child: GestureDetector(
//                 onTap: () => Get.toNamed(Routes.AR_GEAR),
//                 child: Container(
//                   height: 40,
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration:  BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         bottomLeft: Radius.circular(20),
//                       )
//                   ),
//                   child: const Icon(Icons.camera_alt, color: Colors.orange,),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
//
//
