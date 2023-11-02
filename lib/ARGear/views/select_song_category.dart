import 'package:champcash/models/TrendingSong.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ar_gear_controller.dart';

class SelectSongCategoryView extends GetView<ArGearController> {
  final String soundCategoryId;
  const SelectSongCategoryView(this.soundCategoryId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.downloadCategorySong(soundCategoryId);
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Select Song',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [Expanded(child: trendingUI())],
        ),
      ),
    );
  }

  Widget trendingUI() {
    return Obx(() => controller.categorySongs.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              Song song = controller.categorySongs.elementAt(index);
              return Obx(() => ListTile(
                    leading: IconButton(
                        onPressed: () {
                          if (controller.playIndex.value == index &&
                              controller.isPlaying.value) {
                            controller.player.pause();
                          } else {
                            controller.playIndex.value = index;
                            controller.player.setUrl(song.sound).then((value) {
                              controller.player.play();
                            });
                          }
                        },
                        icon: Icon((controller.playIndex.value == index &&
                                controller.isPlaying.value)
                            ? Icons.pause_circle
                            : Icons.play_circle_filled_rounded)),
                    title: Text(song.soundName),
                    trailing: controller.playIndex.value == index
                        ? ElevatedButton(
                            onPressed: () {
                              controller.selectedSong.value = song;
                              controller.downloadFile(song.sound);
                              controller.player.pause();
                              Get.back(result: {'data': song});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text('Use'),
                          )
                        : null,
                  ));
            },
            itemCount: controller.categorySongs.length,
          ));
  }
}
