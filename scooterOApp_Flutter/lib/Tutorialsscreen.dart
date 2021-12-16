import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotto/login_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 5;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  var _GENERIC_REGISTRATION = ' ',
      _GENERIC_REGISTER_CONTENT = ' ',
      _GENERIC_VERIFICATION = ' ',
      _GENERIC_VERIFICATION_CONTENT = ' ',
      GENERIC_PAYMENTS = ' ',
      GENERIC_PAYMENTS_CONTENT = " ",
      GENERIC_UNLOCK_SCOOTERS = " ",
      GENERIC_UNLOCK_SCOOTERS_CONTENT = " ",
      GENERIC_RIDE_TIME = " ",
      GENERIC_RIDE_TIME_CONTENT = " ";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_REGISTRATION =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_REGISTRATION');
      _GENERIC_REGISTER_CONTENT = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_REGISTER_CONTENT");
      _GENERIC_VERIFICATION =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_VERIFICATION');
      _GENERIC_VERIFICATION_CONTENT = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_VERIFICATION_CONTENT");
      GENERIC_PAYMENTS =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_PAYMENTS');
      GENERIC_PAYMENTS_CONTENT = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_PAYMENTS_CONTENT");
      GENERIC_UNLOCK_SCOOTERS = Language.getLocalLanguage(
          _sharedPreferences, 'GENERIC_UNLOCK_SCOOTERS');
      GENERIC_UNLOCK_SCOOTERS_CONTENT = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_UNLOCK_SCOOTERS_CONTENT");
      GENERIC_RIDE_TIME =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_RIDE_TIME');
      GENERIC_RIDE_TIME_CONTENT = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_RIDE_TIME_CONTENT");
    });
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  goToLoginScreen() async {
    StorageUtil.setBoolItem("tutorial_screen", true);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContextcontext) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 6.0,
      width: isActive ? 6.0 : 6.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.6, 0, 0],
              colors: [
                Color(0xff00DD00),
                Color(0xff00DD00),
                Color(0xff00DD00),
                Color(0xff00DD00),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: ListView(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Color(0xffF1FDF0),
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () => goToLoginScreen(),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff00DD00),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 550.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              color: Color(0xffF1FDF0),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  'assets/images/bg_registration.png',
                                ),
                                height: 350.0,
                                width: 300.0,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: 0.0,
                                    top: 25.0,
                                    bottom: 10.0),
                                child: Text(
                                  _GENERIC_REGISTRATION,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: Text(
                                  _GENERIC_REGISTER_CONTENT,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 17.0),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              color: Color(0xffF1FDF0),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  'assets/images/bg_verification.png',
                                ),
                                height: 350.0,
                                width: 300.0,
                              ),
                            ),
                            Container(
                                //  width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: 0.0,
                                    top: 25.0,
                                    bottom: 10.0),
                                child: Text(
                                  _GENERIC_VERIFICATION,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: Text(
                                  _GENERIC_VERIFICATION_CONTENT,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 17.0),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              color: Color(0xffF1FDF0),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  'assets/images/bg_payments.png',
                                ),
                                height: 350.0,
                                width: 300.0,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: 0.0,
                                    top: 25.0,
                                    bottom: 10.0),
                                child: Text(
                                  GENERIC_PAYMENTS,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: Text(
                                  GENERIC_PAYMENTS_CONTENT,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 17.0),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              color: Color(0xffF1FDF0),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  'assets/images/bg_unlock.png',
                                ),
                                height: 350.0,
                                width: 300.0,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: 0.0,
                                    top: 25.0,
                                    bottom: 10.0),
                                child: Text(
                                  GENERIC_UNLOCK_SCOOTERS,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: Text(
                                  GENERIC_UNLOCK_SCOOTERS_CONTENT,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 17.0),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              color: Color(0xffF1FDF0),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  'assets/images/bg_ride.png',
                                ),
                                height: 350.0,
                                width: 300.0,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: 0.0,
                                    top: 25.0,
                                    bottom: 10.0),
                                child: Text(
                                  GENERIC_RIDE_TIME,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: Text(
                                  GENERIC_RIDE_TIME_CONTENT,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 17.0),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                (_currentPage != _numPages - 1)
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              color: Color(0xff00DD00),
              height: 55,
              alignment: Alignment.center,
              child: RaisedButton(
                textColor: Color(0xff00DD00),
                color: Colors.white,
                child: Text('Get started',
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                onPressed: () => goToLoginScreen(),
              ))
          : Text(''),
    );
  }
}
