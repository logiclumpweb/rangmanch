import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/common_models.dart';
import '../controllers/home_controller.dart';

class SHPlayer extends GetView<HomeController> {
  final PlayerModel playerModel;
  const SHPlayer(this.playerModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(controller.isPlaying.value) {
      playerModel.cacheController?.play();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if(playerModel.cacheController!=null)
        GestureDetector(child: CachedVideoPlayer(playerModel.cacheController!),
        onTap: (){
          if(controller.isPlaying.value){
            controller.isPlaying.value = false;
            playerModel.cacheController?.pause();
          }else{
            controller.isPlaying.value = true;
            playerModel.cacheController?.play();
          }
        }),

        Obx(() => controller.isPlaying.value?const SizedBox():Center(
          child: FloatingActionButton(
            heroTag: 'heroTag_${Random().nextInt(1000000000)}',
            onPressed: (){
              playerModel.cacheController?.play();
            controller.isPlaying.value = true;
          },
          backgroundColor: Colors.white54, child: const Icon(Icons.play_arrow)),
        ),),

        Positioned(
            left: 8, right: 8, bottom: 24,
            child: Column(children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(playerModel.model.userImage, width: 60, height: 60, fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.white, width: 2)),
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(playerModel.model.username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              ],)

            ],))

      ],
    );
  }
}

/*
import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/common_models.dart';
import '../controllers/home_controller.dart';

class SHPlayer extends StatefulWidget {
  final PlayerModel playerModel;
  const SHPlayer(this.playerModel, {Key? key}) : super(key: key);

  @override
  State<SHPlayer> createState() => _SHPlayerState();
}

class _SHPlayerState extends State<SHPlayer> {

  @override
  void initState() {
    super.initState();

    initializedPlayer();

    // widget.playerModel.cacheController?.initialize().then((value) =>
    //     widget.playerModel.cacheController?.setLooping(true).then((value) =>
    //         widget.playerModel.cacheController?.play()));

  }


  @override
  void dispose() {
    widget.playerModel.cacheController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    // initializedPlayer();

    // if(controller.isPlaying.value) {
    //   widget.playerModel.cacheController?.play();
    // }

    return Stack(
      alignment: Alignment.center,
      children: [
        if(widget.playerModel.cacheController!=null)
          GestureDetector(child: CachedVideoPlayer(widget.playerModel.cacheController!),
              onTap: (){
                if(controller.isPlaying.value){
                  controller.isPlaying.value = false;
                  widget.playerModel.cacheController?.pause();
                }else{
                  controller.isPlaying.value = true;
                  widget.playerModel.cacheController?.play();
                }

              }),

        Obx(() => controller.isPlaying.value?const SizedBox():Center(
          child: FloatingActionButton(
              heroTag: 'heroTag_${Random().nextInt(1000000000)}',
              onPressed: (){
                widget.playerModel.cacheController?.play();
                controller.isPlaying.value = true;
              },
              backgroundColor: Colors.white54, child: const Icon(Icons.play_arrow)),
        ),),

        Positioned(
            left: 8, right: 8, bottom: 24,
            child: Column(children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(widget.playerModel.model.userImage, width: 60, height: 60, fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),
                          border: Border.all(color: Colors.white, width: 2)),
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.playerModel.model.username,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              ],)

            ],))

      ],
    );
  }

  initializedPlayer()async{
    // if(widget.playerModel.cacheController==null){
      CachedVideoPlayerController cache = CachedVideoPlayerController.network(widget.playerModel.model.video);
      await cache.initialize();
      cache.setLooping(true);
      widget.playerModel.cacheController = cache;
      // cache.play();
      if(mounted) {
        setState(() {});
      }
    // }
  }
}
*/


/*class SHPlayer extends GetView<HomeController> {

  final PlayerModel playerModel;
  const SHPlayer(this.playerModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    initializedPlayer();

    if(controller.isPlaying.value) {
      playerModel.cacheController?.play();
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        if(playerModel.cacheController!=null)
        GestureDetector(child: CachedVideoPlayer(playerModel.cacheController!),
        onTap: (){
          if(controller.isPlaying.value){
            controller.isPlaying.value = false;
            playerModel.cacheController?.pause();
          }else{
            controller.isPlaying.value = true;
            playerModel.cacheController?.play();
          }

        }),

        Obx(() => controller.isPlaying.value?const SizedBox():Center(
          child: FloatingActionButton(
            heroTag: 'heroTag_${Random().nextInt(1000000000)}',
            onPressed: (){
              playerModel.cacheController?.play();
            controller.isPlaying.value = true;
          },
          backgroundColor: Colors.white54, child: const Icon(Icons.play_arrow)),
        ),),

        Positioned(
            left: 8, right: 8, bottom: 24,
            child: Column(children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(playerModel.model.userImage, width: 60, height: 60, fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.white, width: 2)),
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(playerModel.model.username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              ],)

            ],))

      ],
    );
  }

  initializedPlayer()async{
    if(playerModel.cacheController==null){
      CachedVideoPlayerController cache = CachedVideoPlayerController.network(playerModel.model.video);
      await cache.initialize();
      cache.setLooping(true);
      playerModel.cacheController = cache;
    }
  }
}*/
