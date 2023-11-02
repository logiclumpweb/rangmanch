import 'dart:convert';

import 'package:champcash/ARGear/config.dart';

import '../../models/ReelVideoListModel.dart';
import '../../models/UserUplodedVideoListModel.dart';
import '../../models/sticker_response.dart';
import 'api.dart';
import 'api_path.dart';
import 'base_api.dart';
import 'package:http/http.dart' as http;

class ApiImpl extends API {
  @override
  Future<ApiResponse> getStickersAPI(Map body) async {
    // ApiResponse apiResponse = await getRequestAPI('18cc45cf018caf461ed53fcc?dev=true');
    ApiResponse apiResponse = await getRequestStickersAPI();
    if (apiResponse.status) {
      StickerResponse response = stickerResponseFromJson(apiResponse.data);
      return ApiResponse.success(response);
    }
    return ApiResponse.failed(apiResponse.message);
  }

  @override
  Future<ApiResponse> getVideoListAPI(body) async {
    ApiResponse apiResponse = await postRequestAPI(reelVideoUrl, body);
    print("PPPROIINTT${apiResponse.data.toString()}");    print("PPPROIINTT${body}");
    if (apiResponse.data.toString() != "null") {
      if (apiResponse.status) {
        VideoListModel response = videoListModelFromJson(apiResponse.data);
        return ApiResponse.success(response);
      }
    }
    return ApiResponse.failed(apiResponse.message);
  }

  @override
  Future<ApiResponse> user_video_list_api(body) async {
    ApiResponse apiResponse = await postRequestAPI(reelVideoUrl, body);
    if (apiResponse.status) {
      UserUplodedVideoListModel response =
          userUplodedVideoListModelFromJson(apiResponse.data);
      return ApiResponse.success(response);
    }
    return ApiResponse.failed(apiResponse.message);
  }
}
