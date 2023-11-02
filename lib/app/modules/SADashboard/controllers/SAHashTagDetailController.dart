import 'package:get/get.dart';

import '../../../../Apis/api.dart';
import '../../../../Data/UserData.dart';
import '../../../../models/tag_wise_videlList_model.dart';
import '../../../../shared/extras.dart';

class SAhashtagDetailController extends GetxController {
  var tagVideosList = RxList<tVideoDatum>();

  dynamic args = Get.arguments;

  var hashTag = "";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onInit1();
  }

  @override
  void onInit1() {
    super.onInit();
    print("HHHHFSS");
    hashTag = args[0]["hashTagName"];
    print(hashTag);
    hashTagVideos();
  }

  void hashTagVideos() {
    var hashMap = {
      "hash_tag": hashTag,
    };
    print(hashMap);
    getsearchWiseVideo_List(hashMap).then((value) {
      print("bchdfdfgefgfgf");
      if (value.status) {
        TagWiseVideolListModel videoTagListModel = value.data;
        tagVideosList.value = videoTagListModel.data;
        print(value.message);
      } else {
        toastMessage(value.message);
        Get.back();
      }
    });
  }
}

class HashTagDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<SAhashtagDetailController>(
      SAhashtagDetailController(),
    );
    // TODO: implement dependencies
  }
}
