import 'package:champcash/app_controller.dart';
import 'package:champcash/Data/global_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

class SAVideoPlayerNew extends StatefulWidget {
  final int index;
  final String url;
  final String videoThumb;
  final Function(int)?actions;
  final bool showProgress;
  const SAVideoPlayerNew({super.key, required this.url,  this.actions, this.index=0,  this.showProgress=false, required this.videoThumb});

  @override
  _SAVideoPlayerNewState createState() => _SAVideoPlayerNewState();
}

class _SAVideoPlayerNewState extends State<SAVideoPlayerNew> {
  final appController = Get.find<AppController>();
   VideoPlayerController? _controller;
  Uint8List? uint8List;
  bool isPlaying = false;

  Size? size;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
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
      if(event==-1){
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
    return Stack(
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
    );
  }

  Widget loadingVideo(showProgress) =>  Align(
    alignment: Alignment.bottomCenter,
    child: showProgress?const Center(child: CircularProgressIndicator()):const LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
      color: Colors.white, backgroundColor: Colors.white,),
  );

}
