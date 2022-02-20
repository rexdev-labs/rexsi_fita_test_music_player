import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rexsi_fita_fe_mobile_test/Pages/component/card_music.dart';
import 'package:rexsi_fita_fe_mobile_test/Pages/component/player.dart';
import 'package:rexsi_fita_fe_mobile_test/Provider/audioProvider.dart';
import 'package:rexsi_fita_fe_mobile_test/Provider/getSongsProvider.dart';
import 'package:rexsi_fita_fe_mobile_test/Services/Audio.dart';
import 'package:rxdart/rxdart.dart';
import '../Provider/getSongsProvider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  AudioServices audioServices = AudioServices();
  bool nextMusicProcess = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HttpGetSongsProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider())
      ],
      builder: (context, child) {
        final dataProvider =
            Provider.of<HttpGetSongsProvider>(context, listen: false);
        return StreamProvider<List<Duration>?>(
          initialData: null,
          create: (context) =>
              Rx.combineLatest2<Duration, Duration, List<Duration>>(
                  audioServices.audioPlayer.onDurationChanged,
                  audioServices.audioPlayer.onAudioPositionChanged,
                  (a, b) => [a, b]),
          child: FutureBuilder(
              future: dataProvider.data.isEmpty
                  ? dataProvider.connectAPI("adele")
                  : null,
              builder: (context, data) {
                return Scaffold(
                  backgroundColor: Color(0xff262626),
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: size.width * 1,
                            height: size.height * 0.17,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  stops: [
                                    0.053,
                                    0.90,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xFFff3333),
                                    Color(0xFFEE9944),
                                  ],
                                )),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.9,
                                  height: 40,
                                  margin: EdgeInsets.only(
                                    top: size.height * 0.09,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      dataProvider.connectAPI(value);
                                    },
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 10,
                                        bottom: 10,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Search Artist...",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Color(0xff262626),
                            margin: EdgeInsets.only(top: size.height * 0.17),
                            height: size.height * 0.8,
                            padding: EdgeInsets.only(
                              top: 0,
                            ),
                            child: Consumer<HttpGetSongsProvider>(
                              builder: (context, value, child) {
                                return ListView(
                                    padding: EdgeInsets.all(0),
                                    children: [
                                      ...value.data
                                          .map((music) =>
                                              CardMusic(music, audioServices))
                                          .toList(),
                                      Consumer<AudioProvider>(builder:
                                          (context, audioProvider, child) {
                                        return audioProvider.statusPlay ||
                                                audioProvider.statusPause
                                            ? SizedBox(
                                                height: size.height * 0.2)
                                            : SizedBox();
                                      })
                                    ]);
                              },
                            ),
                          ),
                          Consumer<AudioProvider>(
                              builder: (context, audioProvider, child) {
                            return AnimatedSwitcher(
                              switchInCurve: Curves.easeIn,
                              duration: Duration(milliseconds: 500),
                              child: audioProvider.statusPlay ||
                                      audioProvider.statusPause
                                  ? Player(audioServices)
                                  : SizedBox(),
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
