import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotto/splash_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ScooterO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          //visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: SplashScreen(),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Color(0xff00DD00), // transparent status bar
              systemNavigationBarColor: Colors.white, // navigation bar color
              statusBarIconBrightness:
                  Brightness.dark, // status bar icons' color
              systemNavigationBarIconBrightness:
                  Brightness.dark, //navigation bar icons' color
            ),
            child: SplashScreen()));
  }
}

/*
import 'package:flutter/material.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MyApp());


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool login = prefs.getString("login_customer_detail_id") != null ?true:false;
  // print(prefs.getString("login_customer_detail_id"));
  // runApp(MaterialApp(home: login? HomeScreen() : SplashScreen()));
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home:  SplashScreen() ));
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//         theme: ThemeData(
//           primaryColor: Color(0xff00DD00),
//
//
//         ),
//         debugShowCheckedModeBanner: false,
//         home: SplashScreen()
//     );
//   }
// }

*/
