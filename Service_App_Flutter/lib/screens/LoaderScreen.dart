import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Scprogressdialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 10),
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/loader.gif'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),

            ]));
  }
}


/*
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/images/loader.gif'),
              fit: BoxFit.fill),
        ),
       ),

      *//* Container(
            height: 30,
            child:TextAds(),
          ),*//*
    );
  }*/

