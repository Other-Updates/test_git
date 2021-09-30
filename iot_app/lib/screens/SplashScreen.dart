import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:iot_app/Animation/Signup.dart';
import 'package:iot_app/screens/OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => OnboardingScreen())));
    return Scaffold(
        body: Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/images/kitchen.jpg'),
          //         colorFilter: ColorFilter.mode(
          //             Colors.black.withOpacity(0.), BlendMode.color),
          //         fit: BoxFit.cover)),
          decoration: new BoxDecoration(
              color: const Color(0xff000000),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: AssetImage('assets/images/kitchen.jpg'),
              )),
          child: Stack(children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/appLogo.jpg',
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.width * 0.30,
                          fit: BoxFit.fill),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            ('Welcome to'),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
                          child: Text(
                            'The IOT App',
                            // style: GoogleFonts.InriaSerif(
                            //     fontStyle: FontStyle.italic),

                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'InriaSerif',
                                color: Color(0xffEFCC00)),
                          )),
                    ]))
          ])),
    ));
  }
}
