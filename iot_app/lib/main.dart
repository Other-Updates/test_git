import 'package:flutter/material.dart';
import 'package:iot_app/Animation/LoginScreen.dart';
import 'package:iot_app/Animation/Signup.dart';
import 'package:iot_app/screens/SplashScreen.dart';
import 'package:iot_app/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iot App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'InriaSerif',
        scaffoldBackgroundColor: Colors.white,
        buttonColor: Color(0xff5E9F7B),
        backgroundColor: Color(0xff8EA096),
      ),
      home: SplashScreen(),
    );
  }
}
