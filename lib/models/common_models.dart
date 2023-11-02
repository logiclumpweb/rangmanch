//import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:cached_video_player/cached_video_player.dart';

import 'ReelVideoListModel.dart';

class DecorItem{
  final String icon;
  final String title;

  DecorItem({required this.icon, required this.title});
}

class BeautyItemInfo{
  //final ARGBeauty type;
  final String icon;
  final double defaultVal;
  double value;

  BeautyItemInfo({ required this.icon, required this.defaultVal, required this.value, });

}

class PlayerModel{
  final VideoDatum model;
  CachedVideoPlayerController? cacheController;
  bool isInitialized;

  PlayerModel({required this.model, required this.cacheController, required this.isInitialized});
}