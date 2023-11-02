import 'dart:typed_data';

import 'package:champcash/models/UserUplodedVideoListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:video_player/video_player.dart';
import '../Data/global_constant.dart';
import '../app_controller.dart';


class myVideoPlayer extends StatefulWidget {
  final int index;
  final String url;
  final String videoThumb;
  final Function(int)?actions;
  final bool showProgress;
  const myVideoPlayer({super.key, required this.url,  this.actions, this.index=0,  this.showProgress=false, required this.videoThumb});

  @override
  _myVideoPlayerState createState() => _myVideoPlayerState();
}

class _myVideoPlayerState extends State<myVideoPlayer> {
  final appController = Get.find<AppController>();
  VideoPlayerController? _controller;
  Uint8List? uint8List;
  bool isPlaying = true;

  Size? size;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _controller?.play();
          if(widget.index==0|| isPlaying) {
            _controller?.play();
          }
          _controller?.setLooping(true);
          Size mSize = MediaQuery.of(context).size;
          Size sizeTemp = _controller?.value.size??MediaQuery.of(context).size;
          double width = sizeTemp.width;
          double height = sizeTemp.height;

          double ratio = mSize.width/sizeTemp.width;
          width = mSize.width;
          height = sizeTemp.height*ratio;
          size = Size(width, height);
        });
      });

    videoStatusUpdate.stream.listen((event) {
      if(event==PAUSE){
        try{
          if(_controller?.value.isInitialized??false){
            _controller?.pause();
            widget.actions != null?widget.actions!(1):null;
          }
        }catch(e){
          print(e.toString());
        }
      }else if(widget.index==event){
        if(_controller?.value.isInitialized??false){
          _controller?.play();
        }
        isPlaying=true;
      }else{
        if(_controller?.value.isInitialized??false){
          _controller?.pause();
        }
      }

      if(event==PLAY){
        if(_controller?.value.isInitialized??false){
          _controller?.pause();
        }
        isPlaying=false;
      }

    });

  }

  @override
  void dispose() {
    _controller?.dispose().then((value) => _controller=null);
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;
    return SafeArea(

      child: Container(color: Colors.black,
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          children: [
             // Padding(
             //   padding: const EdgeInsets.only(left: 10.0,top: 5),
             //   child: Align(alignment: Alignment.centerLeft,child: GestureDetector(onTap: (){
             //     Get.back();
             //   },child: Container(color: Colors.black,height: 20,width: 35,child: Icon(Icons.arrow_back,size: 25,color: Colors.white,)))),
             // ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset('assets/logo.png'),
                  ),

                  Image.network(widget.videoThumb,
                    width: double.infinity, height: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),

                  Center(
                    child: SizedBox(
                      width: size!.width,
                      height: size!.height,
                      child: _controller?.value.isInitialized??false
                          ? GestureDetector(
                        onTap: () {
                          if (_controller?.value.isPlaying??false) {
                            _controller?.pause();
                            widget.actions != null?widget.actions!(1):null;
                          } else {
                            _controller?.play();
                            widget.actions != null?widget.actions!(0):null;
                          }
                        },
                        child: Center(
                          child: VideoPlayer(
                            _controller!,
                          ),
                        ),
                      )
                          : loadingVideo(widget.showProgress),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingVideo(showProgress) =>  Align(
    alignment: Alignment.bottomCenter,
    child: showProgress?const Center(child: CircularProgressIndicator()):const LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
      color: Colors.white, backgroundColor: Colors.white,),
  );

}
