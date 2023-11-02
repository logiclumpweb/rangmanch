import 'package:champcash/ARGear/views/select_language.dart';
import 'package:champcash/ARGear/views/use_songs.dart';
import 'package:champcash/ARGear/views/video_preview.dart';
import 'package:champcash/app/modules/SADashboard/bindings/s_a_dashboard_binding.dart';
import 'package:champcash/app/modules/SADashboard/views/VideoTrimmerScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/reelCreateScreen.dart';
import 'package:champcash/app/modules/SADashboard/views/s_a_dashboard_view.dart';
import 'package:get/get.dart';
import '../ARGear/bindings/ar_gear_binding.dart';
import '../ARGear/views/ar_gear_view.dart';
import '../View/hashTagDetailsView.dart';
import '../app/modules/SADashboard/controllers/SAHashTagDetailController.dart';
import '../app/modules/SADashboard/controllers/s_a_hash_controller.dart';
import '../main.dart';
import 'AppRoutes.dart';

class AppPages {
  AppPages(_);

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: Routes.SPLASH,
        page: () => const Splash(
              title: 'Rangmanch',
            ),
        binding: SplashBinding()),
    GetPage(
      name: Routes.AR_GEAR,
      //page: () => const VideoPreview(),
      page: () => UseSongs(),
      binding: ArGearBinding(),
    ),

    GetPage(
      name: Routes.S_A_DASHBOARD,
      page: () => SADashboardView(),
      binding: SADashboardBinding(),
    ),

    GetPage(
      name: Routes.S_A_HASTAGDETAILS,
      page: () => hasgtagView(),
      binding: HashTagDetailBindings(),
    ),

    // GetPage(name: Routes.LOGIN, page:()=>  const LoginView(),binding: LoginBinding()),
    // GetPage(name: Routes.DASHBOARD, page: ()=>DashBoardView(),binding: DashBoardBinding()),
    //  GetPage(name: Routes.AUTH, page:()=> const AuthView(),binding: AuthBindings()) ,
    //  GetPage(name: Routes.MYPROFILE, page:()=> const MyProfileDetailView(),binding: MyProfileBindings()),
    // GetPage(name: Routes.LMANUAL, page:()=> const SetManualLocationView(),binding: MyManualLocationBindings()),
    // GetPage(name: Routes.OTPVERIFY, page:()=> const VerificationView(),binding: VerificationBinding()),
    // GetPage(name: Routes.ADMANUALLACTION, page:()=> const AdManualLocationView(),binding: AdManualLocationBindings()),
    // GetPage(name: Routes.AdDESCRIPE, page:()=> const AdDescriptionView(),binding: AdDescriptionBindings()),
    // GetPage(name: Routes.MYFAVORITE, page:()=> const MyFavoritesView(),binding: MyFavoriteListBindings()),
    // GetPage(name: Routes.CONVERSION, page:()=> const ConversionView(),binding: ConversionBindings()),
  ];
}
