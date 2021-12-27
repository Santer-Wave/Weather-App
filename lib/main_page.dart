import 'dart:math';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled1/settings_page.dart';
import 'package:untitled1/weekly_page.dart';

import 'favorites_page.dart';
import 'weather.dart';
import 'response.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.response,
      required this.responseHourly})
      : super(key: key);
  final String title;
  final WeatherResponse response;
  final WeatherResponseHourly responseHourly;

  @override
  State<MyHomePage> createState() => _MyHomePageState(response, responseHourly);
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherResponse response;
  final WeatherResponseHourly responseHourly;

  _MyHomePageState(this.response, this.responseHourly);

  String city = 'saint petersburg';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favorites');
    if (favorites == null) {
      return [];
    } else {
      return favorites;
    }
  }

  getDegree() async {
    final prefs = await SharedPreferences.getInstance();
    final int? degree = prefs.getInt('degree');
    if (degree == null) {
    return 0;
    } else {
    return degree;
    }
  }

  getSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    final int? speed = prefs.getInt('speed');
    if (speed == null) {
      return 0;
    } else {
      return speed;
    }
  }

  getPressure() async {
    final prefs = await SharedPreferences.getInstance();
    final int? pressure = prefs.getInt('pressure');
    if (pressure == null) {
      return 0;
    } else {
      return pressure;
    }
  }

  Future<SharedPreferences> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  getTemp(int? degree, double temp) {
    if(degree == null || degree == 0) {
      return temp.round().toString() + '°C';
    } else {
      temp = (temp * 9/5) + 32;
      return temp.round().toString() + '°F';
    }
  }

  _getSpeed(int? speed_settings, num speed){
    if(speed_settings == null || speed_settings == 0){
      return speed.round().toString() + 'м/с';
    } else {
      speed = speed * 3.6;
      return speed.round().toString() + 'км/ч';
    }
  }

  _getPressure(int? pressure_settings, num pressure){
    if(pressure_settings == null || pressure_settings == 0){
      pressure = pressure * 0.75;
      return pressure.round().toString() + 'мм.рт.ст';
    } else {
      return pressure.round().toString() + ' гПа';
    }
  }

  Widget weatherHourlyPlate(BuildContext context, int num, String deg) {
    return Container(
      width: 65,
      height: 122,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(224, 233, 253, 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(3, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 7, 0, 0),
                    child: Text(
                      responseHourly.time[num].hour.toString() + ':00',
                      style: GoogleFonts.manrope(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(6, 7, 0, 0),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(_weatherImageState(
                            responseHourly.weatherState[num], context)),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 5),
                    child: Text(
                      deg,
                      style: GoogleFonts.manrope(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: fetchData(),
      builder: (_,snapshot) {
        if(snapshot.hasData) {
        return Scaffold(
          appBar: null,
          drawer: Container(
            padding: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width * 0.55,
            // color: Color.fromRGBO(226, 235, 255, 1),
            child: Drawer(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 30, bottom: 20),
                    child: Row(
                      children: [
                        Text(
                          "Weather app",
                              style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          final int degree = await getDegree();
                          final int speed = await getSpeed();
                          final int pressure = await getPressure();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(degree: degree, speed: speed, pressure: pressure)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined,
                                size: 24, color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Настройки",
                                    style: GoogleFonts.manrope(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          final List<String> temp = await getFavorites();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage(favorites: temp)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.favorite_outline,
                                size: 24, color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Избранное",
                                    style: GoogleFonts.manrope(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          final List<String> temp = await getFavorites();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage(favorites: temp)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.account_circle_outlined, size: 24, color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("О разработчике",
                                style: GoogleFonts.manrope(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ])),
          ),
          body: SlidingUpPanel(
            maxHeight: 450,
            minHeight: 256,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            collapsed: Container(
                width: /*MediaQuery.of(context).size.width*/ 360,
                height: 256,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(226, 235, 255, 1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 16),
                    child: Center(
                        child: Container(
                      height: 3,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(3, 140, 254, 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        weatherHourlyPlate(context, 0, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[0])),
                        weatherHourlyPlate(context, 1, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[1])),
                        weatherHourlyPlate(context, 2, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[2])),
                        weatherHourlyPlate(context, 3, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[3]))
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => WeeklyPage())),
                    color: const Color.fromRGBO(234, 240, 255, 1),
                    child: Text('Прогноз на неделю',
                        style: GoogleFonts.manrope(
                          color: const Color.fromRGBO(3, 140, 254, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                    shape: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(3, 140, 254, 1), width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                  )
                ])),
            panel: Container(
                width: MediaQuery.of(context).size.width,
                height: 450,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(226, 235, 255, 1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      child: Center(
                          child: Container(
                        height: 3,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(3, 140, 254, 1),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                      )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          weatherHourlyPlate(context, 0, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[0])),
                          weatherHourlyPlate(context, 1, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[1])),
                          weatherHourlyPlate(context, 2, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[2])),
                          weatherHourlyPlate(context, 3, getTemp(snapshot.data!.getInt('degree'), responseHourly.temperature[3]))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 35, right: 35, top: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 65,
                            width: 150,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  color: Color.fromRGBO(224, 233, 253, 1)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.thermostat_outlined, size: 26),
                                    Text(getTemp(snapshot.data!.getInt('degree'), response.feelsLike),
                                        style: GoogleFonts.manrope(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 65,
                            width: 150,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  color: Color.fromRGBO(224, 233, 253, 1)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.water_rounded, size: 26),
                                    Text(response.humidity.round().toString() + '%',
                                        style: GoogleFonts.manrope(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 65,
                            width: 150,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  color: Color.fromRGBO(224, 233, 253, 1)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.air, size: 26),
                                    Text(_getSpeed(snapshot.data!.getInt('speed'), response.wind),
                                        style: GoogleFonts.manrope(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 65,
                            width: 150,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  color: Color.fromRGBO(224, 233, 253, 1)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.speed, size: 26),
                                    Text(_getPressure(snapshot.data!.getInt('pressure'), response.pressure),
                                        style: GoogleFonts.manrope(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            body: Builder(builder: (context) {
              return Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/new_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 39),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: NeumorphicButton(
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                              style: NeumorphicStyle(
                                color: Color.fromRGBO(1, 97, 254, 1),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(100)),
                              ),
                              // padding: EdgeInsets.fromLTRB(0, 39, 25, 0),
                              // icon: Icon(Icons.control_point, color: Colors.tealAccent),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                          Text(
                            "${response.cityName}",
                            style: GoogleFonts.manrope(
                                color: Colors.tealAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: NeumorphicButton(
                                padding: EdgeInsets.all(0),
                                child: Icon(
                                  Icons.control_point,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                style: NeumorphicStyle(
                                  color: Color.fromRGBO(1, 97, 254, 1),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(100)),
                                ),
                                // padding: EdgeInsets.fromLTRB(0, 39, 25, 0),
                                // icon: Icon(Icons.control_point, color: Colors.tealAccent),
                                onPressed: () async {
                                  List<String> temp = await getFavorites();
                                  print(temp);
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => SearchPage(favorites: temp)));
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Text(getTemp(snapshot.data!.getInt('degree'), response.temperature),
                              style: GoogleFonts.manrope(
                                color: Colors.tealAccent,
                                fontSize: 80,
                              )),
                          Text(currentDate(),
                              style: GoogleFonts.manrope(
                                  color: Colors.tealAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      }
        return Container();
      }
    );
  }

  String _weatherImageState(String weather, BuildContext context) {
    switch (weather) {
      case 'Clear':
        return 'assets/main_light/Иконка Солнце.png';
      case 'Thunderstorm':
        return 'assets/main_light/Иконка Молния.png';
      case 'Rain':
        return 'assets/main_light/Иконка дождь 3 капли.png';
      case 'Snow':
        return 'assets/main_light/Иконка дождь 3 капли.png';
      case 'Drizzle':
        return 'assets/main_light/Иконка дождь.png';
      default:
        return 'assets/main_light/Иконка облака.png';
    }
  }

  String currentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM.');
    final String formatted = formatter.format(now);
    return formatted;
  }
}
