import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/ARGear/views/select_song_category.dart';
import 'package:champcash/models/TrendingSong.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UseSongs extends StatelessWidget {
  UseSongs({Key? key}) : super(key: key);
  final controller = Get.find<ArGearController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.APPPRIMARYWHITECOLOR,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            "Music Library",
            style: TextStyle(color: ColorConstants.APPPRIMARYWHITECOLOR),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.white54,
            labelColor: Colors.orange,
            tabs: <Widget>[
              Tab(text: 'Trending'),
              Tab(text: 'Playlist'),
              Tab(text: 'My Songs'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            trendingUI(),
            playListUI(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.selectAudioFile.value = true;
                  controller.getMP3File();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                child: const Text(
                  "Select from Gallery",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget trendingUI() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Song song = controller.trendingSongs.elementAt(index);
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
                  icon: Icon(
                    (controller.playIndex.value == index &&
                            controller.isPlaying.value)
                        ? Icons.pause_circle
                        : Icons.play_circle_filled_rounded,
                    color: ColorConstants.APPPRIMARYWHITECOLOR,
                  )),
              title: Text(
                song.soundName,
                style: TextStyle(color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
              trailing: controller.playIndex.value == index
                  ? ElevatedButton(
                      onPressed: () async {
                        controller.selectedSong.value = song;
                        controller.downloadedPath.value =
                            await controller.downloadFile(song.sound);
                        controller.player.pause();
                        Get.back(result: controller.downloadedPath.value);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Use'),
                    )
                  : null,
            ));
      },
      itemCount: controller.trendingSongs.length,
    );
  }

  Widget playListUI() {
    return GridView.count(
      crossAxisCount: 2,
      children: controller.songCategory
          .map((element) => MaterialButton(
                onPressed: () {
                  Get.to(SelectSongCategoryView(element.tblSoundCategoryId))
                      ?.then((value) {
                    if (value != null) {
                      Get.back(result: value);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(element.image),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) =>
                            const AssetImage('assets/icon.png'),
                      )),
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(element.name, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
