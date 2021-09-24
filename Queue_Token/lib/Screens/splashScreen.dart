import 'package:flutter/material.dart';
import 'package:queue_token/Screens/TokenDashboard.dart';
import 'dart:async';

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
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => TokenDashboard())));
    return Scaffold(
        body: Center(
      child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/doctor_face.jpg'),
                  colorFilter: ColorFilter.mode(
                      Color(0xffADDFDE).withOpacity(0.4), BlendMode.dstATop),
                  fit: BoxFit.fill)),
          child: Stack(children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.width * 0.45,
                  fit: BoxFit.fill),
            ),
          ])),
    ));
  }
}
