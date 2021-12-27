import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/SplashScreen.dart';

class SettingsPage extends StatefulWidget {
  var degree, speed, pressure;
  SettingsPage({Key? key, required this.degree, required this.speed, required this.pressure}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState(degree, speed, pressure);
}

class _SettingsPageState extends State<SettingsPage> {
  var degree, speed, pressure;


  _SettingsPageState(this.degree, this.speed, this.pressure);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(226, 235, 255, 1),
        child: Padding(
            padding: const EdgeInsets.only(top: 37),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BackButton(onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashPage('Мир')));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Настройки",
                            style: GoogleFonts.manrope(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Единицы измерения",
                    style: GoogleFonts.manrope(
                        color: Color.fromRGBO(130, 130, 130, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 152,
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
                          color: Color.fromRGBO(226, 235, 255, 1),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Температура",
                                        style: GoogleFonts.manrope(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    width: 122,
                                    height: 25,
                                    child: NeumorphicToggle(
                                      children: [
                                        ToggleElement(
                                          foreground: Center(child: Text('°C')),
                                          background: Center(child: Text('°C')),
                                        ),
                                        ToggleElement(
                                          foreground: Center(child: Text('°F')),
                                          background: Center(child: Text('°F')),
                                        )
                                      ],
                                      thumb: Container(),
                                      selectedIndex: degree,
                                      onChanged: (value) async {
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.setInt('degree', value);
                                        setState(() {
                                          degree = value;
                                        });
                                      },
                                    ),
                                  )],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  height: 1,
                                  width: 365,
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Сила ветра",
                                    style: GoogleFonts.manrope(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    width: 122,
                                    height: 25,
                                    child: NeumorphicToggle(
                                      children: [
                                        ToggleElement(
                                          foreground: Center(child: Text('м/с')),
                                          background: Center(child: Text('м/с')),
                                        ),
                                        ToggleElement(
                                          foreground: Center(child: Text('км/ч')),
                                          background: Center(child: Text('км/ч')),
                                        )
                                      ],
                                      thumb: Container(),
                                      selectedIndex: speed,
                                      onChanged: (value) async {
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.setInt('speed', value);
                                        setState(() {
                                          speed = value;
                                        });
                                      },
                                    ),
                                  )],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  height: 1,
                                  width: 365,
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Давление",
                                    style: GoogleFonts.manrope(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    width: 122,
                                    height: 25,
                                    child: NeumorphicToggle(
                                      children: [
                                        ToggleElement(
                                          foreground: Center(child: Text('мм.рт.ст.')),
                                          background: Center(child: Text('мм.рт.ст.')),
                                        ),
                                        ToggleElement(
                                          foreground: Center(child: Text('гПа')),
                                          background: Center(child: Text('гПа')),
                                        )
                                      ],
                                      thumb: Container(),
                                      selectedIndex: pressure,
                                      onChanged: (value) async {
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.setInt('pressure', value);
                                        setState(() {
                                          pressure = value;
                                        });
                                      },
                                    ),
                                  )],
                              ),
                            ],
                          ),
                        ),
                    )
                  ),
                ),
              ],
            ),
        )
      )
    );
  }
}
