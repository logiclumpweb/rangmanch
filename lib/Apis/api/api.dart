import 'base_api.dart';

abstract class API{


  Future<ApiResponse> getVideoListAPI(Map body);

  Future<ApiResponse> getStickersAPI(Map body);

}