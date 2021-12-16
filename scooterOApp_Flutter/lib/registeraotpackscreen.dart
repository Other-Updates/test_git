import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';




class RegisterOtpackScreen extends StatefulWidget {
  @override
  RegisterOtpackScreenState createState() => RegisterOtpackScreenState();
  }
  class RegisterOtpackScreenState extends State<RegisterOtpackScreen> {
  var _GENERIC_OTP_VERIFIED = ' ';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
  _GENERIC_OTP_VERIFIED =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_OTP_VERIFIED');


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
        Duration(seconds: 8),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen())));
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
                              builder: (BuildContext context) => HomeScreen()
                          )
                      ),
                    }),
                    Container(
                        padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 100.0, bottom: 20.0),
                        alignment: Alignment.centerLeft,
                        child: Center(
                          child: Image.asset('assets/images/otpsuccess.png', width: 160, height: 180, fit: BoxFit.fill),
                        )
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 32.0, right: 32.0),
                      child: Text(
                        _GENERIC_OTP_VERIFIED ,
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
