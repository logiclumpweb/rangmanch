import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_chat_controller.dart';
import 'package:get/get.dart';

import '../controllers/s_a_dashboard_controller.dart';
import '../controllers/s_a_hash_controller.dart';
import '../controllers/s_a_profile_controller.dart';

class SADashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SADashboardController>(
      SADashboardController(),
    );
    Get.put<SAChatController>(
      SAChatController(),
    );
    Get.put<ProfileController>(
      ProfileController(),
    );
    Get.put<SAhashtagController>(
      SAhashtagController(),
    );
  }
}
