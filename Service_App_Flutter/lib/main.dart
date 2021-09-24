import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/screens/SplashScreen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        splashColor: Color(0xff004080),
      ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Color(0xff004080), // transparent status bar
              systemNavigationBarColor: Colors.black, // navigation bar color
              statusBarIconBrightness: Brightness.dark, // status bar icons' color
              systemNavigationBarIconBrightness:
              Brightness.dark, //navigation bar icons' color
            ),
            child:SplashScreen()
        )
    );
  }
}

