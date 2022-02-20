import 'package:flutter/material.dart';
import 'package:rexsi_fita_fe_mobile_test/Models/Music.dart';
import 'package:rexsi_fita_fe_mobile_test/Services/Audio.dart';

class AudioProvider extends ChangeNotifier {
  bool statusPlay = false;
  bool statusPause = false;
  int musicId = 0;
  late Music recentMusic;
  late Duration maxPositionMusic;
  late Duration nowPositionMusic;

  Future play(AudioServices audioServices, Music music) async {
    this.statusPlay = true;
    this.musicId = music.id;
    this.recentMusic = music;
    await audioServices.play(music.previewSongUrl);
    notifyListeners();
  }

  Future pause(AudioServices audioServices) async {
    this.statusPause = true;
    this.statusPlay = false;
    await audioServices.pause();
    notifyListeners();
  }

  Future resume(AudioServices audioServices) async {
    this.statusPlay = true;
    this.statusPause = false;
    await audioServices.resume();
    notifyListeners();
  }

  Future seek(AudioServices audioServices, Duration position) async {
    await audioServices.seek(position);
    this.nowPositionMusic = position;
    notifyListeners();
  }
}
