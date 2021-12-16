import 'dart:io';
import 'package:coolincool/LoginScreen.dart';
import 'package:coolincool/Screens/AddDistributorScreen.dart';
import 'package:coolincool/Screens/AddsalesOrder.dart';
import 'package:coolincool/Screens/ConfirmPlaceEditOrderScreen.dart';
import 'package:coolincool/Screens/DashboardScreen.dart';
import 'package:coolincool/Screens/DistributorScreen.dart';
import 'package:coolincool/Screens/EditDistributorScreen.dart';
import 'package:coolincool/Screens/EditSalesOrder.dart';
import 'package:coolincool/Screens/HomeScreen.dart';
import 'package:coolincool/Screens/ProfileScreen.dart';
import 'package:coolincool/Screens/SalesOrderScreen.dart';
import 'package:coolincool/SplashScreen.dart';
import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(// navigation bar color
    statusBarColor: Palette.PrimaryColor,
   statusBarIconBrightness: Brightness.light// status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool In Cool Masala',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      debugShowCheckedModeBanner: false,
      initialRoute: Routes.LOGIN_SCREEN,
      routes: {
        Routes.LOGIN_SCREEN: (context) => LoginScreen(),
        Routes.HOME_SCREEN: (context) => HomeScreen(),
        Routes.ADDDISTRIBUTORSCREEN: (context) => AddDistributorScreen(),
        Routes.EDITDISTRIBUTORSCREEN: (context) => EditDistributorScreen(),
        Routes.ADDSALESORDERSCREEN: (context) => AddSalesOrderScreen(),
        Routes.EDITSALESORDERSCREEN: (context) => EditSalesOrderScreen(),
        Routes.CONFIRMPLACEEDITORDERSCREEN: (context) => ConfirmPlaceEditOrderScreen(),
        Routes.PROFILESCREEN: (context) => ProfileScreen(),
        Routes.DASHBOARDSCREEN: (context) => DashboardScreen(),
        Routes.SALESORDERSCREEN: (context) => SalesOrderScreen(),
        Routes.DISTRIBUTORSCREEN: (context) => DistributorScreen(),
      },
     );
  }
}
