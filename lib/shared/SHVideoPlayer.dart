import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

import '../models/ReelVideoListModel.dart';

class SHVideoPlayer extends StatefulWidget {
  final VideoDatum videoDatum;
  final StreamController<int> onChange;
  const SHVideoPlayer({Key? key, required this.videoDatum, required this.onChange,}) : super(key: key);

  @override
  State<SHVideoPlayer> createState() => _SHVideoPlayerState();
}

class _SHVideoPlayerState extends State<SHVideoPlayer> {

  CachedVideoPlayerController? cachedVideoPlayerController;

  @override
  void initState() {
    super.initState();
    widget.onChange.stream.listen((event) async{
      if(event == 0){
        loadVideoPlayer(widget.videoDatum);
      }
      if(event == 1){
        if(cachedVideoPlayerController==null){
          loadVideoPlayer(widget.videoDatum).then((value){
            if(mounted) {
              setState(() {
              cachedVideoPlayerController?.play();
            });
            }
          });
        }else{
          cachedVideoPlayerController?.play();
        }
      }

      if(event == 2){
        await cachedVideoPlayerController?.pause();
      }

      if(event == 3){
        await cachedVideoPlayerController?.pause();
        await cachedVideoPlayerController?.dispose();
      }

    });
    // loadVideoPlayer(widget.videoDatum);
  }

  Future<void>loadVideoPlayer(VideoDatum element) async {
    String url = element.video;
    cachedVideoPlayerController = CachedVideoPlayerController.network(url)
      ..addListener(() {})
      ..setLooping(true);
    await cachedVideoPlayerController?.initialize();
    if(mounted) {
      setState(() {});
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return cachedVideoPlayerController!=null?SizedBox(
      child: CachedVideoPlayer(cachedVideoPlayerController!),
    ):const SizedBox();
  }
}
