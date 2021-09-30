import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_app/Animation/LoginScreen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 5;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

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

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
              image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: AssetImage('assets/images/kitchen.jpg'),
          )
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   stops: [0.1, 0.6, 0, 0],
              //   colors: [
              //     Color(0xff00DD00),
              //     Color(0xff00DD00),
              //     Color(0xff00DD00),
              //     Color(0xff00DD00),
              //   ],
              // ),
              ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: ListView(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  // color: Color(0xffF1FDF0),
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xffEFCC00),
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
                                  'assets/images/bg_verification.png',
                                ),
                                height: 350.0,
                                width: 300.0,
                              ),
                            ),
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
              color: Color(0xffEFCC00),
              height: 55,
              alignment: Alignment.center,
              child: RaisedButton(
                  textColor: Color(0xffEFCC00),
                  color: Colors.white,
                  child: Text('Get started',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
                  }))
          : Text(''),
    );
  }
}
