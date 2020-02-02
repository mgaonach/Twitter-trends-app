import 'dart:convert';

import 'package:twitter/twitter.dart';
import 'package:http/http.dart' as http;

get twitter => Twitter(
      'geUnSFpKNPqWgGp5B7lbdUJsY', //consumer key
      'uCW9sDQrYLa5zATAEArgNAm6axY8Vf8WJBU6uPmGEAu1PUYe6k', //consumer token
      '',
      '',
    );

class Trend {
  String name;
  int volume;

  Trend(this.name, this.volume);

  factory Trend.fromJson(dynamic json) {
    return Trend(json['name'], json['tweet_volume']);
  }

  @override
  String toString() {
    return 'Trend{name: $name, volume: $volume}';
  }
}

Future<http.Response> _requestTrends() async {
  var response = await twitter.request("GET", "trends/place.json?id=1");
  twitter.close();
  return response;
}

Future<List<Trend>> getTrends() async {
  http.Response response = await _requestTrends();
  var json = jsonDecode(response.body);
  var list = json[0]['trends'] as List;
  List<Trend> res = list.map((t) => Trend.fromJson(t)).toList();
  return res;
}

Future<List<Trend>> getTrendsTop10() async {
  List<Trend> trends = await getTrends();
  trends = trends.where((element) => element.volume != null).toList();
  trends = trends.take(10).toList();
  return trends;
}

