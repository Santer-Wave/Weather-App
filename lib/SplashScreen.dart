import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'weather.dart';
import 'response.dart';
import 'main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SplashPage extends StatelessWidget {
  String city;


  SplashPage(this.city);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final temp = prefs.getString('lastCity');
      log(temp.toString());
      if(temp != null){
        city = temp;
      } else city = 'Saint Petersburg';
      WeatherResponse? response = await WeatherData.getWeather(city.toString());
      WeatherResponseHourly responseHourly = await WeatherDataHourly.getWeather(city.toString());
      /*WeatherResponseWeekly responseWeekly = await WeatherDataWeekly.getWeather(response.lat, response.lon);*/
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home', response: response!, responseHourly: responseHourly))
      );
    });

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(226, 235, 255, 1),
        child: Center(
          heightFactor: 42,
          widthFactor: 42,
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
      ),
      ),
    );
  }
}