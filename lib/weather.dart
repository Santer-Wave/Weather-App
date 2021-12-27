import 'dart:convert';

import 'package:http/http.dart' as http;
import 'response.dart';


class Settings {
  final List<String> favorites;
  final List<String> history;

  Settings(this.favorites, this.history);
}

class WeatherData {
  static Future<WeatherResponse?> getWeather(String city) async {
    final queryParams = {
      'q': city,
      'appid': 'd1b4d2b199181d3f5bcc5db5a950153c',
      'units': 'metric',
      'lang': 'ru'
    };
    final uri = Uri.https('api.openweathermap.org', 'data/2.5/weather', queryParams);
    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    if (response.statusCode == 200)
    return WeatherResponse.fromJson(json);
    return null;
  }
}

class WeatherDataHourly {
  static Future<WeatherResponseHourly> getWeather(String city) async {
    final queryParams = {
      'q': city,
      'appid': 'd1b4d2b199181d3f5bcc5db5a950153c',
      'units': 'metric',
      'lang': 'ru'
    };
    final uri = Uri.https('api.openweathermap.org', 'data/2.5/forecast', queryParams);
    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    return WeatherResponseHourly.fromJson(json);
  }
}

class WeatherDataWeekly {
  static Future<WeatherResponseWeekly> getWeather(num lat, num lon) async {
    final queryParams = {
      'lat': lat,
      'lon': lon,
      'exclude': 'minutely,currently,hourly,alerts',
      'appid': 'd1b4d2b199181d3f5bcc5db5a950153c',
      'units': 'metric',
    };
    final uri = Uri.https('api.openweathermap.org', 'data/2.5/onecall', queryParams);
    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    return WeatherResponseWeekly.fromJson(json);
  }
}

