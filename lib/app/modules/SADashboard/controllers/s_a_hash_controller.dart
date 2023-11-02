import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/models/tag_wise_videlList_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Apis/api.dart';
import '../../../../Data/UserData.dart';
import '../../../../models/VideoTagListModel.dart';
import '../../../../models/user_searchlist_model.dart';
import '../../../../shared/extras.dart';

class SAhashtagController extends GetxController {
  var hashTagList = RxList<TagList>();
  var userTagList = RxList<UserList>();
  var searchUserList = RxList<searchDatum>();
  final editUserSeachController = TextEditingController().obs,
      isSearchDataFound = false.obs;
  dynamic args = Get.arguments;
  var tagVideosList = RxList<tVideoDatum>();
  var lastTagVideosList = RxList<tVideoDatum>();
  final dController = Get.find<SADashboardController>();

  @override
  void onInit() {
    super.onInit();
    hashTagVideos();
  }

  void hashTagVideos() {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
    };
    print(hashMap);
    getvideoTagList(hashMap).then((value) {
      print("bchdfdfgefgfgf");
      if (value.status) {
        VideoTagListModel videoTagListModel = value.data;
        hashTagList.value = videoTagListModel.tagList;
        userTagList.value = videoTagListModel.userList;
        if (hashTagList.isNotEmpty || userTagList.isNotEmpty) {
          allHashTagVideos(hashTagList[2].hashTagName);
          allHashTagVideos1(hashTagList[5].hashTagName);
        }
      }
    });
  }

  void getSearchResult(String keyworld) {
    var hashMap = {
      "keyword": keyworld.trim(),
    };
    print(hashMap.toString() + "checllll");
    getsearch_List(hashMap).then((value) {
      if (value.status) {
        isSearchDataFound.value = true;
        UserSearchlistModel userSearchlistModel = value.data;
        searchUserList.value = userSearchlistModel.data;
      } else {
        isSearchDataFound.value = false;
        //showErrorBottomSheet(value.message);
      }
    });
  }

  void allHashTagVideos(String st) {
    var hashMap = {
      "hash_tag": st,
    };
    print("HASHHSH${hashMap}");
    getsearchWiseVideo_List(hashMap).then((value) {
      if (value.status) {
        TagWiseVideolListModel videoTagListModel = value.data;
        tagVideosList.value = videoTagListModel.data;
      }
    });
  }

  void allHashTagVideos1(String st) {
    var hashMap = {
      "hash_tag": st,
    };
    print("HASHHSH${hashMap}");
    getsearchWiseVideo_List(hashMap).then((value) {
      print("bchdfdfgefgfgf");
      if (value.status) {
        TagWiseVideolListModel videoTagListModel = value.data;
        lastTagVideosList.value = videoTagListModel.data;
      }
    });
  }
}
