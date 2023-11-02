import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/ReelVideoListModel.dart';

class SHVideoPlayerNew extends StatefulWidget {
  final VideoDatum videoDatum;
  final StreamController<int> onChange;
  const SHVideoPlayerNew({Key? key, required this.videoDatum, required this.onChange,}) : super(key: key);

  @override
  State<SHVideoPlayerNew> createState() => _SHVideoPlayerNewState();
}

class _SHVideoPlayerNewState extends State<SHVideoPlayerNew> {
  bool isControllerDisposed = false;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  bool isPlayerInit = false;
  @override
  void initState() {
    super.initState();

    initializedPlayer();

    _controller.addListener(checkVideo);


    widget.onChange.stream.listen((event) async{
      if(event == 0){
        initializedPlayer();
      }
      if(event == 1){
        if(isControllerDisposed){
          isControllerDisposed = false;
          initializedPlayer().then((value) => _controller.play());
        }else{
          _controller.play();
        }

      }

      if(event == 2){
        _controller.pause();
      }

      if(event == 3){
        _controller.dispose();
      }

    });
  }

  Future<void>initializedPlayer()async{
    _controller = VideoPlayerController.network(widget.videoDatum.video);
    await _controller.initialize();
    isPlayerInit = true;
    if(mounted) {
      setState(() {});
    }


    _chewieController = ChewieController(
      videoPlayerController: _controller,
      // aspectRatio: 1 / 1,
      placeholder: Text('Hello'),
      autoPlay: true,
      autoInitialize: true,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );


    return;
      // ..initialize().then((_) {
      //   isPlayerInit = true;
      //   if(mounted) {
      //     setState(() {});
      //   }
      // });
  }

  @override
  void dispose() {
    _controller.dispose();
    isControllerDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isPlayerInit?SizedBox(
      // child: VideoPlayer(_controller),
      child: Chewie(
        controller: _chewieController,
      )
    ):const SizedBox();
  }

  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(_controller.value.position == const Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if(_controller.value.position == _controller.value.duration) {
      print('video Ended');
    }

  }
}
