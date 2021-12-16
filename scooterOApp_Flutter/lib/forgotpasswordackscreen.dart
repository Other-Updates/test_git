import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:scotto/login_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class forgotpasswordackscreen extends StatefulWidget {
  @override
  _forgotpasswordackscreenState createState() => _forgotpasswordackscreenState();
}

class _forgotpasswordackscreenState extends State<forgotpasswordackscreen> {

  var _GENERIC_PASSWORD_RESET_LINK = ' ';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_PASSWORD_RESET_LINK =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_PASSWORD_RESET_LINK');


    });
  }
  @override
  void initState() {
    super.initState();
    getLanguage();
  }


  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds:10),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen())));
    return Scaffold(
        body: Center(
            child: Container(
              color: Color(0xffE6FFE6),

              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
              GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(left:15,top: 30),
                alignment: Alignment.topLeft,
                child: new Icon(
                          Icons.close,
                  color: Color(0xff9A9090),
                          size: 23.0,
                )  ), onTap: () =>
                    {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()
                          )
                      ),
                    }),
                    Container(
                        padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 100.0, bottom: 20.0),
                        alignment: Alignment.centerLeft,
                        child: Center(
                          child: Image.asset('assets/images/update_profile_success.jpg', width: 160, height: 180, fit: BoxFit.fill),
                        )
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 32.0, right: 32.0),
                      child: Text(
                        _GENERIC_PASSWORD_RESET_LINK ,
                        maxLines: 3,
                        textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xff676767),
                            fontFamily: 'Montserrat',
                            fontSize: 16),


                      ),)

                  ]),


            )));
  }


}
