import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rexsi_fita_fe_mobile_test/Models/Music.dart';

class HttpGetSongsProvider with ChangeNotifier {
  List<Music> _data = [];
  List<Music> get data => _data;

  int get totalData => _data.length;

  Future connectAPI(String artist) async {
    Uri url = Uri.parse("https://itunes.apple.com/search?term=" +
        artist.replaceAll(' ', '+') +
        "&entity=musicTrack");
    print(url);

    var response = await http.get(url);
    try {
      var jsonData = json.decode(response.body);
      _data = List<Map>.from((jsonData as Map<String, dynamic>)['results'])
          .map((e) => Music(
              e['trackId'],
              e['artistName'],
              e['artworkUrl100'],
              e['artworkUrl60'],
              e['previewUrl'],
              e['trackName'],
              e['trackTimeMillis']))
          .toList();
    } catch (e) {
      print(e);
      _data = [];
    }

    notifyListeners();
  }
}
