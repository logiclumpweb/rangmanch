import 'dart:io';

import 'package:champcash/DashBoardView.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/NotificationService.dart';
import 'package:champcash/app/modules/SADashboard/views/VideoTrimmerScreen.dart';
import 'package:champcash/app_binding.dart';
import 'package:champcash/Auth/login.dart';
import 'package:champcash/shared/extras.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'Routes/AppPages.dart';
import 'Routes/AppRoutes.dart';
import 'dart:math' as math;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(const MyApp());
  // runApp(CompressMyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.initialiseNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Handle the notification when the app is in the foreground${message.notification!.title.toString()}");
      createLocalNotification.showNotification(
          id: 0,
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
          payload: "");
    });

    /*FirebaseMessaging.onMessage.listen((message) {

      // if (Platform.isIOS) {
      //   Get.snackbar(message.notification!.title.toString(),
      //       message.notification!.body.toString());
      // }
      createLocalNotification.showNotification(
          id: 0,
          title: "message.notification!.title.toString()",
          body: "message.notification!.body.toString()",
          payload: "");
    });*/
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Rangmanch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Splash(title: 'Rangmanch'),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
      initialBinding: AppBinding(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key, required String title}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final cont = Get.find<SplashController>();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    animation = Tween<double>(begin: 50, end: 250).animate(animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        body: SizedBox(
          child: Center(
            child: Image.asset(
              height: animation.value,
              width: animation.value,
              "assets/logo.png",
            ).paddingAll(55),
          ),
          /*AnimatedBuilder(
            animation: animationController,
            builder: (_, child) {
              return Transform.rotate(
                angle: animationController.value * 2 * math.pi,
                child: child,
              );
            },
            child: SizedBox(
                height: 110,
                width: double.infinity,
                child: Image.asset("assets/logo.png").paddingAll(55)),
          ),*/
        ));
  }
}

void _luanch() {
  Future.delayed(const Duration(milliseconds: 1700), () {
    getUserInfo().then((value) {
      if (value != null) {
        userLoginModel = value;
        if (userLoginModel != null) {
          Get.offAndToNamed(Routes.S_A_DASHBOARD);
        }
      } else {
        Get.off(const Login());
      }
    });
  });
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    //  Future.delayed(const Duration(seconds: 3), () {
    _luanch();
    //});
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
