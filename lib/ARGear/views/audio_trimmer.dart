import 'dart:io';

import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/shared/extras.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AudioTrimmerView extends StatefulWidget {
  final File file;

  const AudioTrimmerView(this.file, {Key? key}) : super(key: key);
  @override
  State<AudioTrimmerView> createState() => _AudioTrimmerViewState();
}

class _AudioTrimmerViewState extends State<AudioTrimmerView> {
  final Trimmer _trimmer = Trimmer();
  final controller = Get.find<ArGearController>();
  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadAudio();
  }

  void _loadAudio() async {
    setState(() {
      isLoading = true;
    });
    await _trimmer.loadAudio(audioFile: widget.file);
    setState(() {
      isLoading = false;
    });
  }

  _saveAudio() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedAudio(
      startValue: _startValue,
      endValue: _endValue,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (outputPath) async {
        debugPrint('OUTPUT PATH: $outputPath');
        File f = File(outputPath!);
        var filename =
            "${DateTime.now().millisecondsSinceEpoch.toString()}.mp3"; //Uri.parse(url).pathSegments.last;
        final directory = await getExternalStorageDirectory();
        // print("DOWNLOADEDPATH${directory!.path}");
        File fileDef = File('${directory!.path}/$filename');
        await fileDef.create(recursive: true);
        Uint8List bytes = await f.readAsBytes();
        await fileDef.writeAsBytes(bytes);

        _progressVisibility = false;
        Get.back(result: fileDef.path);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: SizedBox.expand(
        //backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.cancel_outlined,
                              size: 22,
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                            )),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            _saveAudio();
                          },
                          child: Text(
                            "Done",
                            style: textStyleW700(
                                fontSize: 20,
                                color: ColorConstants.APPPRIMARYWHITECOLOR),
                          ),
                        )
                      ],
                    ).paddingOnly(left: 15, right: 15, top: 30),
                    Visibility(
                        visible: _progressVisibility,
                        child: const LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orangeAccent),
                          color: Colors.white,
                          backgroundColor: Colors.white,
                        )),

                    //AudioViewer(trimmer: _trimmer),
                    const Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 36.0,
                              color: ColorConstants.APPPRIMARYWHITECOLOR
                                  .withOpacity(0.80),
                            ),
                            onPressed: () async {
                              bool playbackState =
                                  await _trimmer.audioPlaybackControl(
                                startValue: _startValue,
                                endValue: _endValue,
                              );
                              setState(() => _isPlaying = playbackState);
                            },
                          ),
                        ),
                        TrimViewer(
                          trimmer: _trimmer,
                          viewerHeight: 45,
                          viewerWidth: MediaQuery.of(context).size.width / 1.3,
                          backgroundColor: Colors.grey.withOpacity(0.08),
                          barColor: ColorConstants.APPPRIMARYWHITECOLOR
                              .withOpacity(0.50),
                          allowAudioSelection: true,
                          editorProperties: TrimEditorProperties(
                            circleSize: 10,
                            borderPaintColor: ColorConstants.APPPRIMARYGREYCOLOR
                                .withOpacity(0.50),
                            borderWidth: 4,
                            borderRadius: 5,
                            circlePaintColor: ColorConstants.APPPRIMARYGREYCOLOR
                                .withOpacity(0.99),
                          ),
                          areaProperties:
                              TrimAreaProperties.edgeBlur(blurEdges: false),
                          onChangeStart: (value) => _startValue = value,
                          onChangeEnd: (value) => _endValue = value,
                          onChangePlaybackState: (value) {
                            if (mounted) {
                              setState(() => _isPlaying = value);
                            }
                          },
                        ).paddingOnly(bottom: 20, right: 10),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
