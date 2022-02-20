import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rexsi_fita_fe_mobile_test/Models/Music.dart';
import 'package:rexsi_fita_fe_mobile_test/Provider/audioProvider.dart';
import 'package:rexsi_fita_fe_mobile_test/Provider/getSongsProvider.dart';
import 'package:rexsi_fita_fe_mobile_test/Services/Audio.dart';

class Player extends StatelessWidget {
  final AudioServices audioServices;
  Player(this.audioServices);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.only(top: size.height * 0.79, left: size.width * 0.025),
      width: size.width * 0.95,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          stops: [
            0.11,
            0.90,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFd53026).withOpacity(0.94),
            Color(0xFFe67632).withOpacity(0.94),
          ],
        ),
        // color: Colors.grey.shade200.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 5,
              left: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<AudioProvider>(
                    builder: (context, audioProvider, child) {
                  return CachedNetworkImage(
                    imageUrl: audioProvider.recentMusic.songCover60,
                    imageBuilder: (context, image) {
                      return Container(
                          margin: EdgeInsets.only(right: 5),
                          width: size.width * 0.08,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: image, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                          ));
                    },
                    placeholder: (context, data) {
                      return Container(
                          margin: EdgeInsets.only(right: 5),
                          width: size.width * 0.08,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ));
                    },
                  );
                }),
                Container(
                  width: size.width * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<AudioProvider>(
                          builder: (context, audioProvider, child) {
                        return FittedBox(
                          child: Text(
                            audioProvider.recentMusic.songTitle,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                      Consumer<AudioProvider>(
                          builder: (context, audioProvider, child) {
                        return FittedBox(
                          child: Text(
                            audioProvider.recentMusic.artistName,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 1,
            ),
            child: Consumer2<List<Duration>?, AudioProvider>(
              builder: (context, dataDuration, audioProvider, child) {
                audioProvider.maxPositionMusic =
                    dataDuration != null ? dataDuration[0] : Duration();
                audioProvider.nowPositionMusic =
                    dataDuration != null ? dataDuration[1] : Duration();

                return Slider(
                  value:
                      audioProvider.nowPositionMusic.inMilliseconds.toDouble(),
                  max: audioProvider.maxPositionMusic.inMilliseconds.toDouble(),
                  activeColor: Color.fromARGB(255, 255, 255, 255),
                  inactiveColor: Color(0xffFFA6A6),
                  onChanged: (newValue) async {
                    await audioProvider.seek(audioServices,
                        Duration(milliseconds: newValue.toInt()));
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer2<AudioProvider, HttpGetSongsProvider>(
                  builder: (context, audioProvider, songProvider, child) {
                return GestureDetector(
                  onTap: () async {
                    late Music nextMusic;
                    if (songProvider.data
                        .where((element) =>
                            element.id == audioProvider.recentMusic.id)
                        .isEmpty) {
                      nextMusic = songProvider.data[0];
                    } else {
                      int indexMusic = songProvider.data
                          .asMap()
                          .map((key, value) => value.id == audioProvider.musicId
                              ? MapEntry(key, value)
                              : MapEntry(key, null))
                          .entries
                          .toList()
                          .where((element) => element.value != null)
                          .toList()
                          .first
                          .key;
                      nextMusic = 0 == indexMusic
                          ? songProvider.data[songProvider.data.length - 1]
                          : songProvider.data[indexMusic - 1];
                    }
                    await audioProvider.play(audioServices, nextMusic);
                  },
                  child: Icon(
                    Icons.skip_previous_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                );
              }),
              Consumer<AudioProvider>(builder: (context, audioProvider, child) {
                return GestureDetector(
                  onTap: () async {
                    if (audioProvider.statusPlay)
                      await audioProvider.pause(audioServices);
                    else
                      await audioProvider.resume(audioServices);
                  },
                  child: audioProvider.statusPlay
                      ? Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.pause,
                            size: 35,
                            color: Color(0xffD42D26),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 35,
                            color: Color(0xffD42D26),
                          ),
                        ),
                );
              }),
              Consumer2<AudioProvider, HttpGetSongsProvider>(
                  builder: (context, audioProvider, songProvider, child) {
                return GestureDetector(
                  onTap: () async {
                    late Music nextMusic;
                    if (songProvider.data
                        .where((element) => element.id == audioProvider.musicId)
                        .isEmpty) {
                      nextMusic = songProvider.data[0];
                    } else {
                      int indexMusic = songProvider.data
                          .asMap()
                          .map((key, value) => value.id == audioProvider.musicId
                              ? MapEntry(key, value)
                              : MapEntry(key, null))
                          .entries
                          .toList()
                          .where((element) => element.value != null)
                          .toList()
                          .first
                          .key;
                      nextMusic = (songProvider.data.length - 1) == indexMusic
                          ? songProvider.data[0]
                          : songProvider.data[indexMusic + 1];
                    }
                    await audioProvider.play(audioServices, nextMusic);
                  },
                  child: Icon(
                    Icons.skip_next_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
