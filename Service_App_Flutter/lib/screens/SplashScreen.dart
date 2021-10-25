import 'dart:async';

import 'package:flutter/material.dart';
import 'package:service_app/screens/CustomerDashboardScreen.dart';
import 'package:service_app/screens/EmployeeDashboardScreen.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:service_app/screens/mobilelogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool logincus = prefs.getString("login_customer_id") != null ? true : false;
    bool loginemp = prefs.getString("login_employee_id") != null ? true : false;

    _mockCheckForSession().then((status) {
      if (!logincus) {
        _navigateToCus();
      } else if (loginemp) {
        _navigateToEmp();
      } else {
        _navigateToLogin();
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    return true;
  }

  void _navigateToCus() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CustomerDashboardScreen()));
  }

  void _navigateToEmp() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => EmployeeDashboardScreen()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            ));
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset('assets/images/logo.png'),
          height: MediaQuery.of(context).size.width / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    );
  }
}
