// import 'dart:async';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
// import 'package:champcash/ARGear/views/use_songs.dart';
// import 'package:champcash/ARGear/views/video_preview.dart';
// import 'package:champcash/Data/global_constant.dart';
// import 'package:champcash/Routes/AppRoutes.dart';
// import 'package:champcash/shared/SAImageView.dart';
// import 'package:champcash/shared/extras.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
//
// class MakeReelVideoScreen extends StatefulWidget {
//   final bool isPop;
//   const MakeReelVideoScreen({Key? key, this.isPop = false}) : super(key: key);
//
//   @override
//   State<MakeReelVideoScreen> createState() => _MakeReelVideoScreenState();
// }
//
// class _MakeReelVideoScreenState extends State<MakeReelVideoScreen> {
//   late CameraController cameraController;
//   bool isLoading = true;
//   bool isRecording = false,
//       isVisibleSubmitUI = false,
//       isVisibleAddMoreUI = false;
//   late XFile file;
//   List<String> adsVideosList = [];
//   GetStorage store = GetStorage();
//   Timer? _timer;
//   final arController = Get.put(ArGearController());
//   @override
//   void initState() {
//     super.initState();
//     availableCameras().then((cameras) {
//       final front = cameras.firstWhere(
//           (camera) => camera.lensDirection == CameraLensDirection.back);
//       initCamera(front);
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     cameraController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? Container(
//               color: ColorConstants.APPPRIMARYBLACKCOLOR,
//               child: Center(
//                 child: CircularProgressIndicator(
//                   color: ColorConstants.APPPRIMARYWHITECOLOR,
//                   strokeWidth: 6,
//                 ),
//               ),
//             )
//           : SizedBox(
//               height: double.infinity,
//               child: Stack(
//                 fit: StackFit.expand,
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   ClipRect(
//                     child: OverflowBox(
//                       alignment: Alignment.center,
//                       child: FittedBox(
//                         fit: BoxFit.cover,
//                         child: SizedBox(
//                           height: 1,
//                           child: AspectRatio(
//                             aspectRatio: 1 / cameraController.value.aspectRatio,
//                             child: CameraPreview(cameraController),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 12.0, right: 12.0, top: 50),
//                         child: Row(
//                           children: [
//                             IconButton(
//                                 onPressed: () => Get.back(),
//                                 icon: const Icon(
//                                   Icons.cancel,
//                                   color: Colors.white,
//                                   size: 44,
//                                 )),
//
//                             IconButton(
//                                 onPressed: () => Get.to(UseSongs()),
//                                 icon: const Icon(
//                                   Icons.music_note_sharp,
//                                   color: Colors.white,
//                                   size: 44,
//                                 )),
//
//                             const Spacer(), // GestureDetector(
//                           ],
//                         ),
//                       ),
//                       const Expanded(child: SizedBox()),
//                       SizedBox(
//                         height: 100,
//                         width: double.infinity,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: IconButton(
//                                   onPressed: () {
//                                     // cameraController.value.
//                                     _toggleCameraLens();
//                                   },
//                                   icon: Icon(
//                                     Icons.flip_camera_ios_outlined,
//                                     size: 30,
//                                     color: ColorConstants.APPPRIMARYWHITECOLOR,
//                                   )),
//                             ),
//                             Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 if (isRecording)
//                                   SizedBox(
//                                     height: 120,
//                                     width: 120,
//                                     child: SnapChatProgressButton(
//                                       size: 100,
//                                       color: Colors.deepOrangeAccent,
//                                       backgroundColor: Colors.transparent,
//                                     ),
//                                   ),
//                                 GestureDetector(
//                                   onLongPress: () {
//                                     if (arController.selectedSong != null) {
//                                       arController.player
//                                           .setUrl(arController
//                                                   .selectedSong.value?.sound ??
//                                               '')
//                                           .then((value) {
//                                         arController.player.play();
//                                       });
//                                     }
//                                     recordVideo();
//                                   },
//                                   onLongPressEnd: (val) {
//                                     isRecording = true;
//                                     _timer?.cancel();
//                                     recordVideo();
//                                   },
//                                   child: Container(
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                         color:
//                                             isRecording ? Colors.white60 : null,
//                                         border: Border.all(
//                                             color: Colors.white,
//                                             width: isRecording ? 0 : 5),
//                                         shape: BoxShape.circle),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Expanded(
//                                 child: IconButton(
//                                     onPressed: () async {
//                                       FilePickerResult? fileResult =
//                                           await FilePicker.platform.pickFiles(
//                                               allowMultiple: true,
//                                               type: FileType.custom,
//                                               allowedExtensions: ["mp4"]);
//                                       if (fileResult != null) {
//                                         List<File> fPathList = fileResult.paths
//                                             .map((e) => File(e!))
//                                             .toList();
//                                         print(
//                                             "FILLEEEE${fPathList.first.path}");
//                                         Get.offNamed(Routes.AR_GEAR,
//                                             arguments: {
//                                               "FilePath":
//                                                   fileResult.files.first.path
//                                             });
//                                       }
//                                     },
//                                     icon: AssetImageView(
//                                       img: "assets/gallery1.png",
//                                       color:
//                                           ColorConstants.APPPRIMARYWHITECOLOR,
//                                     )))
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 40,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
//
//   void initCamera(CameraDescription description) async {
//     final cameras = await availableCameras();
//     final front = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.back);
//     // cameraController = CameraController(front, ResolutionPreset.max,enableAudio: false);
//     cameraController = CameraController(description, ResolutionPreset.medium,
//         enableAudio: false);
//     await cameraController.initialize();
//     setState(() {
//       isLoading = false;
//     });
//   }
//
// //data/user/0/com.app.rangmanch/app_flutter/output5607260.mp4
//   recordVideo() async {
//     if (isRecording) {
//       setState(() {
//         isRecording = false;
//         isVisibleSubmitUI = true;
//         isVisibleAddMoreUI = true;
//       });
//
//       file = await cameraController.stopVideoRecording();
//       print("INITOOOOOOOOO");
//       //arController.filePath.value = await arController.mergeAudio(
//      //     File(file.path), File(arController.downloadedPath.value));
//       print("MERRGGEEPPP${arController.filePath.value}");
//       // print("UUUUUUJJJJ");
//       Get.offNamed(Routes.AR_GEAR, arguments: {"FilePath": file.path});
//
//       // if (widget.isPop) {
//       //   Get.back(result: {'path': file.path});
//       // } else {
//       //   // Get.off(MakeAdsView(
//       //   //   filePath: file.path,
//       //   // ));
//       // }
//     } else {
//       try {
//         isVisibleSubmitUI = false;
//         await cameraController.prepareForVideoRecording();
//         await cameraController.startVideoRecording();
//         setState(() => isRecording = true);
//         print("INITOOOOOOOOO)))))))");
//         _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
//           isRecording = true;
//           _timer?.cancel();
//           recordVideo();
//         });
//       } catch (e) {
//         EasyLoading.showToast('Camera recording is failed\n${e.toString()}');
//       }
//     }
//   }
//
//   void _toggleCameraLens() async {
//     // get current lens direction (front / rear)
//     final availableCam = await availableCameras();
//     final lensDirection = cameraController.description.lensDirection;
//     CameraDescription? newDescription;
//     if (lensDirection == CameraLensDirection.front) {
//       newDescription = availableCam.firstWhere((description) =>
//           description.lensDirection == CameraLensDirection.back);
//     } else {
//       newDescription = availableCam.firstWhere((description) =>
//           description.lensDirection == CameraLensDirection.front);
//     }
//
//     if (newDescription != null) {
//       initCamera(newDescription);
//     } else {
//       print('Asked camera not available');
//     }
//   }
// }
//
import 'package:champcash/Data/global_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnapChatProgressButton extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Color color;
  final String time;
  const SnapChatProgressButton({
    super.key,
    required this.size,
    this.backgroundColor = Colors.grey,
    this.color = Colors.blue,
    required this.time,
  });

  @override
  State<SnapChatProgressButton> createState() => _SnapChatProgressButtonState();
}

class _SnapChatProgressButtonState extends State<SnapChatProgressButton>
    with SingleTickerProviderStateMixin {
  late Animation animation;

//  animationController =
  // AnimationController(vsync: this, duration: const Duration(seconds: 11))..repeat(reverse: true);
  //animation = Tween(begin: 0.0, end: 360.0).animate(animationController);
  // animationController.addListener(() {
  // if (mounted) setState(() {});
  // });

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(seconds: int.parse(widget.time)),
      vsync: this,
    )..repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 360.0).animate(animationController);
    animationController.addListener(() {
      if (mounted) setState(() {});
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomPaint(
          painter: SnapChatCanvas(
              progress: animation.value,
              backgroundColor: widget.backgroundColor,
              color: widget.color),
          size: Size(widget.size, widget.size),
        )
      ],
    );
  }
}

class SnapChatCanvas extends CustomPainter {
  late final double progress;
  late final Color backgroundColor;
  late final Color color;
  SnapChatCanvas(
      {required this.progress,
      this.backgroundColor = Colors.deepOrangeAccent,
      this.color = Colors.blue});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint();
    paint
      ..color = backgroundColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    paint.strokeWidth = size.width / 15;
    canvas.drawArc(Offset(0.0, 0.0) & Size(size.width, size.width),
        -90.0 * 0.0174533, progress * 0.0174533, false, paint..color = color);
  }

  @override
  bool shouldRepaint(SnapChatCanvas oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.progress != progress;
  }
}
