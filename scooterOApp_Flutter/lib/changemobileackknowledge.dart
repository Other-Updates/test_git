import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scotto/change_mobileno.dart';
import 'package:scotto/changemobilenumber.dart';
import 'package:scotto/contactsupportscreen.dart';
import 'package:scotto/settings_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Changemobileacknowledge extends StatefulWidget {

  @override
  ChangemobileacknowledgeState createState() => ChangemobileacknowledgeState();

}

class ChangemobileacknowledgeState extends State<Changemobileacknowledge> {
  String customer_details;
  var _GENERIC_MOBILE_NUMBER_CHANGED_MSG = ' ',GENERIC_TRY_AGAIN = ' ',GENERIC_OR = ' ',GENERIC_CONTACT_SUPPORT = ' ',GENERIC_CHANGE_MOBILE_NUMBER=' ';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_MOBILE_NUMBER_CHANGED_MSG = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_MOBILE_NUMBER_CHANGED_MSG');
      GENERIC_TRY_AGAIN = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_TRY_AGAIN');
      GENERIC_OR = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_OR');
      GENERIC_CONTACT_SUPPORT = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_CONTACT_SUPPORT');
      GENERIC_CHANGE_MOBILE_NUMBER = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_CHANGE_MOBILE_NUMBER');


    });
  }
  @override
  void initState() {
    super.initState();
    getLanguage();
  }



  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 8),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen())));
    return Scaffold(
        body: Center(
            child: Container(
              color: Color(0xffE6FFE6),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child:Container(
                        padding: EdgeInsets.only(left:15,top: 20),
                        alignment: Alignment.topLeft,
                        child: new Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 23.0,
                        ),),
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(top:20),
                      alignment: Alignment.center,
                      height: 180,
                      width:  180,
                      child: Image.asset('assets/images/otpsuccess.png', fit: BoxFit.fill),),


                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 30),
                      child: Text(
                        _GENERIC_MOBILE_NUMBER_CHANGED_MSG ,
                        textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: Color(0xff676767),
                            fontFamily: 'Montserrat',
                            fontSize: 14.5),
                      ),
                    ),

                    Container(

                        width: 110,
                        padding: EdgeInsets.fromLTRB(90, 15, 90, 0),

                        child: RaisedButton(

                          textColor: Colors.white,
                          color: Color(0xff00DD00),
                          child: Text(GENERIC_TRY_AGAIN),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          onPressed: () {

                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChangeMobileno(),
                                )
                            );

                          },
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 0.5, bottom: 0.5),
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor: Color(0xff00DD00),
                              child: Text(
                                GENERIC_OR,
                                style: TextStyle(fontSize: 15),
                              ),

                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )),

                    Container(
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor: Color(0xff00DD00),
                              child: Text(
                                  GENERIC_CHANGE_MOBILE_NUMBER,
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ChangeMobilenumberScreen(customer_details)
                                    )
                                ); //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 0.5, bottom: 0.5),
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor: Color(0xff00DD00),
                              child: Text(
                                GENERIC_OR,
                                style: TextStyle(fontSize: 15),
                              ),

                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )),

                    Container(
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor: Color(0xff00DD00),
                              child: Text(
                                GENERIC_CONTACT_SUPPORT,
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ContactSupportScreen(),
                                    )
                                ); //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ))
                  ]),

            )));
  }


}

