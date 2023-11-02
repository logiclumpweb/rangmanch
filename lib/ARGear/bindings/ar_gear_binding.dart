import 'package:get/get.dart';

import '../controllers/ar_gear_controller.dart';

class ArGearBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArGearController>(
      ArGearController(),
    );
  }
}
