import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rexsi_fita_fe_mobile_test/Models/Music.dart';
import 'package:rexsi_fita_fe_mobile_test/Provider/audioProvider.dart';
import 'package:rexsi_fita_fe_mobile_test/Services/Audio.dart';

class CardMusic extends StatelessWidget {
  final AudioServices audioServices;
  final Music music;
  CardMusic(this.music, this.audioServices);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, child) {
      return GestureDetector(
        onTap: () async {
          if (music.id == audioProvider.musicId) {
            audioProvider.statusPlay
                ? await audioProvider.pause(audioServices)
                : await audioProvider.play(audioServices, music);
          } else {
            await audioProvider.play(audioServices, music);
          }
        },
        child: ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: CachedNetworkImage(
              imageUrl: music.songCover60,
              imageBuilder: (context, image) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: image, fit: BoxFit.cover)),
                );
              },
            ),
          ),
          title: Text(
            music.songTitle,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            music.artistName,
            style: TextStyle(
              color: Color.fromARGB(255, 186, 186, 186),
              fontSize: 10,
            ),
          ),
          trailing: Icon(
            audioProvider.statusPlay && audioProvider.musicId == music.id
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
