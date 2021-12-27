import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/SplashScreen.dart';

class FavoritesPage extends StatefulWidget {
  List<String> favorites;

  FavoritesPage({Key? key, required this.favorites}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState(favorites);
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favorites;

  _FavoritesPageState(this.favorites);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color.fromRGBO(226, 235, 255, 1),
          child: Padding(
            padding: const EdgeInsets.only(top: 37),
            child: Column(children: [
              Row(
                children: [
                  BackButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Избранное",
                      style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Container(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView.builder(
                    itemExtent: 70.0,
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: NeumorphicButton(
                          onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('lastCity', favorites[index]);
                              Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => SplashPage(favorites[index].toString())));},
                          style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                              color: Color.fromRGBO(222, 233, 255, 1),
                              lightSource: LightSource.top,
                              depth: -3,
                              shape: NeumorphicShape.convex
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text(favorites[index],
                                style: GoogleFonts.manrope(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: NeumorphicButton(
                                      child: Icon(Icons.close),
                                      onPressed: () async {
                                        final prefs = await SharedPreferences.getInstance();
                                        favorites.removeAt(index);
                                        await prefs.setStringList('favorites', favorites);
                                        Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => FavoritesPage(favorites: favorites), transitionDuration: Duration.zero));
                                      },
                                      style: NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                                          color: Color.fromRGBO(200, 218, 255, 1),
                                          lightSource: LightSource.bottomRight,
                                          depth: 0,
                                          shape: NeumorphicShape.flat
                                      ),
                                    ),
                                  )
                        ],
                      ),
                          ),)
                      ,
                      );
                    },
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
