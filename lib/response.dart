import 'dart:developer';

class Temperature {
  final double temperature;

  Temperature({required this.temperature});

  factory Temperature.fromJson(Map<String, dynamic> json){
    final temperature = json['temp'];
    return Temperature(temperature: temperature);
  }
}

class Weather {

}

class WeatherResponse extends Weather{
  final String cityName;
  final double temperature;
  final double feelsLike;
  final num lat;
  final num lon;
  final num humidity;
  final num pressure;
  final num wind;


  WeatherResponse({required this.cityName, required this.temperature, required this.feelsLike,
    required this.humidity, required this.pressure, required this.wind, required this.lat, required this.lon});

  static fromJson(Map<String, dynamic> json){
    log(json.toString());
    return WeatherResponse(
        cityName: json['name'],
        temperature: json['main']['temp'],
        feelsLike: json['main']['feels_like'],
        humidity: json['main']['humidity'],
        pressure: json['main']['pressure'],
        wind: json['wind']['speed'],
        lat: json['coord']['lat'],
        lon: json['coord']['lon']);
  }
}

class WeatherResponseHourly extends Weather{
  final List<double> temperature;
  final List<String> weatherState;
  final List<DateTime> time;

  WeatherResponseHourly({required this.temperature, required this.weatherState, required this.time});

  static conv(int time){
    return DateTime.fromMillisecondsSinceEpoch(time*1000);
  }

  static fromJson(Map<String, dynamic> json){
    return WeatherResponseHourly(
        temperature: [json['list'][0]['main']['temp'], json['list'][2]['main']['temp'], json['list'][4]['main']['temp'], json['list'][6]['main']['temp']],
        weatherState: [json['list'][0]['weather'][0]['main'], json['list'][2]['weather'][0]['main'], json['list'][4]['weather'][0]['main'], json['list'][6]['weather'][0]['main']],
        time: [conv(json['list'][0]['dt']), conv(json['list'][2]['dt']), conv(json['list'][4]['dt']), conv(json['list'][6]['dt'])]);
  }
}

class WeatherResponseWeekly extends Weather{
  final List<DateTime> time;
  final List<String> weatherState;
  final List<double> temperature;
  final List<num> humidity;
  final List<num> pressure;
  final List<num> speed;

  WeatherResponseWeekly({required this.time, required this.weatherState, required this.temperature,
  required this.humidity, required this.pressure, required this.speed});

  static conv(int time){
    return DateTime.fromMillisecondsSinceEpoch(time*1000);
  }

  static fromJson(Map<String, dynamic> json){
    return WeatherResponseWeekly(
      time: [conv(json['daily'][0]['dt']), conv(json['daily'][1]['dt']), conv(json['daily'][2]['dt']), conv(json['daily'][3]['dt']), conv(json['daily'][4]['dt']), conv(json['daily'][5]['dt']), conv(json['daily'][6]['dt'])],
      weatherState: [json['daily'][0]['weather']['main'], json['daily'][1]['weather']['main'], json['daily'][2]['weather']['main'], json['daily'][3]['weather']['main'], json['daily'][4]['weather']['main'], json['daily'][5]['weather']['main'], json['daily'][6]['weather']['main']],
      temperature: [json['daily'][0]['temp']['day'], json['daily'][1]['temp']['day'], json['daily'][2]['temp']['day'], json['daily'][3]['temp']['day'], json['daily'][4]['temp']['day'], json['daily'][5]['temp']['day'], json['daily'][6]['temp']['day']],
      humidity: [json['daily'][0]['humidity'], json['daily'][1]['humidity'], json['daily'][2]['humidity'], json['daily'][3]['humidity'], json['daily'][4]['humidity'], json['daily'][5]['humidity'], json['daily'][6]['humidity']],
      pressure: [json['daily'][0]['pressure'], json['daily'][1]['pressure'], json['daily'][2]['pressure'], json['daily'][3]['pressure'], json['daily'][4]['pressure'], json['daily'][5]['pressure'], json['daily'][6]['pressure']],
      speed: [json['daily'][0]['wind_speed'], json['daily'][1]['wind_speed'], json['daily'][2]['wind_speed'], json['daily'][3]['wind_speed'], json['daily'][4]['wind_speed'], json['daily'][5]['wind_speed'], json['daily'][6]['wind_speed']],
    );
  }
}
