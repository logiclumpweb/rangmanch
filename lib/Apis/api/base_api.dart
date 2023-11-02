import 'dart:convert';
import 'package:champcash/ARGear/config.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

//http://35.154.245.222/
const String apiHost = 'http://rangmanch.live/web_services';
var timeoutDuration = 90;

String bearerToken = '';
Map<String, String> headers = {
  "Content-Type": "application/json;charset=UTF-8",
  "accept": "application/json",
  "Access-Control-Allow-Origin": "*",
  'Charset': 'utf-8'
};

Future<ApiResponse> postRequestAPI(method, body,
    {Map<String, String>? header, loading = false}) async {
  try {
    String url = '$apiHost/$method';
    if (kDebugMode) {
      print('$url\n${jsonEncode(body)}');
    }
    final response =
        await postRequest(url, body, header: header, loading: loading);
    ApiResponse apiResponse = responseDioFilter(response);

    if (apiResponse.status) {
      return ApiResponse(
          status: true, data: apiResponse.data, message: SUCCESS);
    } else {
      return apiResponse;
    }
  } catch (e) {
    return ApiResponse(status: false, data: null, message: e.toString());
  }
}

Future<ApiResponse> getRequestAPI(method) async {
  try {
    String url = '$apiHost/$method';
    final response = await getRequest(url);
    ApiResponse apiResponse = responseFilter(response);
    if (apiResponse.status) {
      return ApiResponse(
          status: true, data: apiResponse.data, message: SUCCESS);
    } else {
      return apiResponse;
    }
  } catch (e) {
    return ApiResponse(status: false, data: null, message: e.toString());
  }
}

Future<ApiResponse> getRequestStickersAPI() async {
  try {
    String url = '${Config.apiUrl}/api/v3/${Config.apiKey}?dev=true';
    final response = await getRequest(url);
    ApiResponse apiResponse = responseFilter(response);
    if (apiResponse.status) {
      return ApiResponse(
          status: true, data: apiResponse.data, message: SUCCESS);
    } else {
      return apiResponse;
    }
  } catch (e) {
    return ApiResponse(status: false, data: null, message: e.toString());
  }
}

dynamic responseFilter(http.Response response) {
  try {
    switch (response.statusCode) {
      case 200:
        return ApiResponse(status: true, data: response.body, message: SUCCESS);
      case 408:
        return ApiResponse(
            status: false, data: response.body, message: 'Request time out');
      default:
        return ApiResponse(status: false, data: response.body, message: ERROR);
    }
  } catch (e) {
    return ApiResponse(status: false, data: null, message: e.toString());
  }
}

dynamic responseDioFilter(Response response) {
  try {
    switch (response.statusCode) {
      case 200:
        print("PRIINNIITNTT${response.data.toString()}");
        return ApiResponse(
            status: true, data: response.toString(), message: SUCCESS);
      case 408:
        return ApiResponse(
            status: false,
            data: response.toString(),
            message: 'Request time out');
      default:
        return ApiResponse(
            status: false, data: response.toString(), message: ERROR);
    }
  } catch (e) {
    return ApiResponse(status: false, data: null, message: e.toString());
  }
}

Future<http.Response> getRequest(url) async {
  if (kDebugMode) {
    print(url);
  }

  final response = await http
      .get(Uri.parse(url), headers: headers)
      .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
    return http.Response('Request time out', 408);
  });
  return response;
}

Future<Response> postRequest(url, body, {loading = true, header}) async {
//print("FFFFFRRROMMM$body   ${json.encode(body)}");
  //final formData = FormData({"user_id": "1"});
  if (loading) {
    EasyLoading.show();
  }
  // final response = await http
  //     .post(Uri.parse(url), body: formData, headers: header ?? headers)
  //     .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
  //   EasyLoading.dismiss();
  //   return http.Response('Error', 408);
  // });
  //String url = "http://3.108.89.87/web_services/new_video_list_api_phase2.php";
  final formData = FormData.fromMap({"user_id": userLoginModel!.data.userId});

  final response = await Dio().post(url, data: formData);
  EasyLoading.dismiss();
  return response;
}

const String SUCCESS = 'success';
const String ERROR = 'failure';

class ApiResponse {
  bool status;
  String? message;
  dynamic data;
  ApiResponse(
      {required this.status, required this.message, required this.data});

  factory ApiResponse.success(data) {
    return ApiResponse(status: true, message: '', data: data);
  }

  factory ApiResponse.failed(message) {
    return ApiResponse(status: false, message: message, data: null);
  }
}
