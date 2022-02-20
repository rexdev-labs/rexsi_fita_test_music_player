import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  AudioPlayer audioPlayer = AudioPlayer();

  Future play(String urls) async {
    await audioPlayer.play(urls);
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  Future resume() async {
    await audioPlayer.resume();
  }

  Future seek(Duration position) async {
    await audioPlayer.seek(position);
  }
}
