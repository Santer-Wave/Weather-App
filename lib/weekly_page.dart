import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:untitled1/response.dart';

class WeeklyPage extends StatefulWidget {

  WeeklyPage({Key? key}) : super(key: key);

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends State<WeeklyPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(226, 235, 255, 1),
        child: Column(
          children: [
            Row(),
            Container(
              height: 387,
              width: 320,
              child: Swiper(
                itemBuilder: (BuildContext context, int index){
                  return Neumorphic(
                    child: Column(
                      children: [

                      ],
                    ),
                  );
                },
                itemCount: 7,
                pagination: SwiperPagination(),
                control: SwiperControl(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
