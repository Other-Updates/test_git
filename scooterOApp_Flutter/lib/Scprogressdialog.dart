import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Scprogressdialog extends StatelessWidget {
  String message;
  Scprogressdialog(this.message);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(80),
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80))),
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
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/anim_scooter_1.gif'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(message,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center),
                  color: Colors.transparent),
            ]));
  }
}
