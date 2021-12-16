import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 75.0),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(1000)),
                child: Image(
                    width: 191.0, //250
                    height: 191.0,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/logo.png')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
