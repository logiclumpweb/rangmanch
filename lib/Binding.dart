
import 'package:get/instance_manager.dart';


import 'controller/DashBoardController.dart';


class DashBoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DashBoardController>(()=>DashBoardController());
  }
}