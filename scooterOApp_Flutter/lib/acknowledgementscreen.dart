import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class AcknowledgementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: Otpack());
  }
}

class Otpack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Otpack> {
  var _GENERIC_RIDE_COMPLETE_MSG = ' ';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_RIDE_COMPLETE_MSG = Language.getLocalLanguage(
          _sharedPreferences, 'GENERIC_RIDE_COMPLETE_MSG');
    });
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      color: Color(0xffE6FFE6),
      child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 20),
                alignment: Alignment.topLeft,
                child: new Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 23.0,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              height: 220,
              width: 220,
              child: Image.asset('assets/images/update_profile_success.jpg',
                  fit: BoxFit.fill),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
              child: Text(
                _GENERIC_RIDE_COMPLETE_MSG,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: Color(0xff676767),
                    fontFamily: 'Montserrat',
                    fontSize: 14.5),
              ),
            ),
          ]),
    )));
  }
}
