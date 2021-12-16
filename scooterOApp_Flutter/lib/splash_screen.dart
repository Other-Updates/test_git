import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:scotto/home_screen.dart';
import 'package:scotto/login_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scotto/choose_language.dart';
import 'package:local_auth/local_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasFingerPrintSupport = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBuimetricType = List<BiometricType>();

  Future<void> _getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    // 7. this method fetches all the available biometric supports of the device
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
          await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBuimetricType = availableBuimetricType;
    });
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate With ScooterO", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
    });
  }

  var _GENERIC_SPLASH = ' ';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_SPLASH =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_SPLASH');
    });
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login =
        prefs.getString("login_customer_detail_id") != null ? true : false;
    bool language = prefs.getString("language_contents") != null ? true : false;
    bool tutorialScreen =
        prefs.getBool("tutorial_screen") != null ? true : false;

    _mockCheckForSession().then((status) {
      if (!login && !language) {
        _navigateToLanguage();
      } else if (login) {
        _navigateToHome();
      } else {
        _navigateToLogin();
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    return true;
  }

  void _navigateToLanguage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => ChooseLanguage()));
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    getLanguage();
    _getBiometricsSupport();
    _getAvailableSupport();
    _authenticateMe();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return Scaffold(
        body: Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  colorFilter:
                      ColorFilter.mode(Color(0xff00DD00), BlendMode.color),
                  fit: BoxFit.cover)),
          child: Stack(children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.width * 0.50,
                  fit: BoxFit.fill),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          child: Text(
                        (_GENERIC_SPLASH),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      )),
                      Container(
                          padding: EdgeInsets.only(bottom: 10.0, top: 3.0),
                          child: Text(
                            'V1.0.6',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                color: Colors.white),
                          )),
                    ])),
          ])),
    ));
  }
}
