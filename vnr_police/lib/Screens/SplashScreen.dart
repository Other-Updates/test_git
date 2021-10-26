import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () async {
      // String nextRoute = await NavigationUtils.getInitialAppRoute();
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.LOGIN_SCREEN, (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 75.0),
              child: AvatarGlow(
                endRadius: 200.0,
                glowColor: HexColor('#0b5394'),
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1000)),
                  child: Image(
                      width: 251.0, //250
                      height: 191.0,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/vnrpolice.png')),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: ScaleAnimatedTextKit(
                  onTap: () {
                    print('Tap Event');
                  },
                  text: [
                    'VNR POLICE',
                  ],
                  textStyle: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Canterbury',
                      color: HexColor('#0b5394'),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                 // alignment: AlignmentDirectional.topStart // or Alignment.topLeft
              ),
            ),
          ],
        ),
      ),
    );
  }
}
