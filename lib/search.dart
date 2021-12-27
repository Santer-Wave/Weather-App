import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SplashScreen.dart';
import 'weather.dart';
import 'main_page.dart';

class SearchPage extends StatefulWidget {
  List<String> favorites;
  SearchPage({Key? key, required this.favorites}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchWidgetState(favorites);
}

class _SearchWidgetState extends State<SearchPage> {
  late TextEditingController _controller;
  List<String> favorites;

  _SearchWidgetState(this.favorites);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color.fromRGBO(229, 229, 229, 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 37),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    onPressed: () {
                    Navigator.pop(context);
                    }
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height * 0.35,
                    child: TextField(
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color.fromRGBO(0, 0, 0, 0)
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(0, 0, 0, 0)
                            )
                        ),
                        hintText: 'Введите город'
                      ),
                      controller: _controller,
                      onSubmitted: (city) async {
                        if(favorites.contains(city)){
                        } else {
                          favorites.add(city);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setStringList('favorites', favorites);
                          await prefs.setString('lastCity', city);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SplashPage(city)));
                      }),
                  ),
                  IconButton(onPressed: null, icon: Icon(Icons.cancel))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}