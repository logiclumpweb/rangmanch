// To parse this JSON data, do
//
//     final trendingSongs = trendingSongsFromJson(jsonString);

import 'dart:convert';

TrendingSongs trendingSongsFromJson(String str) => TrendingSongs.fromJson(json.decode(str));

String trendingSongsToJson(TrendingSongs data) => json.encode(data.toJson());

class TrendingSongs {
  TrendingSongs({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  List<Song> data;

  factory TrendingSongs.fromJson(Map<String, dynamic> json) => TrendingSongs(
    message: json["message"],
    status: json["status"],
    data: List<Song>.from(json["data"].map((x) => Song.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Song {
  Song({
    required this.tblSoundId,
    required this.soundName,
    required this.sound,
  });

  String tblSoundId;
  String soundName;
  String sound;

  factory Song.fromJson(Map<String, dynamic> json) => Song(
    tblSoundId: json["tbl_sound_id"],
    soundName: json["sound_name"],
    sound: json["sound"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_sound_id": tblSoundId,
    "sound_name": soundName,
    "sound": sound,
  };
}
