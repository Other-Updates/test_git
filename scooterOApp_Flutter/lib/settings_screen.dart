import 'package:flutter/material.dart';
import 'package:scotto/choose_language.dart';
import 'package:scotto/change_email.dart';
import 'package:scotto/change_mobileno.dart';
import 'package:scotto/change_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  var _GENERIC_CHANGE_MOBILE_NUMBER = ' ',_GENERIC_CHANGE_EMAIL_ID = '',_GENERIC_SETTINGS ='',_GENERIC_CHANGE_PASSWORD ='',_GENERIC_CHOOSE_LANGUGAE =''  ;



  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_SETTINGS = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_SETTINGS');
      _GENERIC_CHANGE_MOBILE_NUMBER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CHANGE_MOBILE_NUMBER");
      _GENERIC_CHANGE_EMAIL_ID = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CHANGE_EMAIL_ID");
      _GENERIC_CHANGE_PASSWORD = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CHANGE_PASSWORD");
      _GENERIC_CHOOSE_LANGUGAE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CHOOSE_LANGUGAE");
    });

  }

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _key,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,// add custom icons also
            ),
          ),
          title: Text( _GENERIC_SETTINGS ,style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20.0,
              fontFamily: 'Montserrat',
              color: Colors.white),),
          centerTitle: true,
          backgroundColor:Color(0xff00DD00),

        ),
        body: new Container(
          color: Color(0xffE6FFE6),
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(
                                  left: 20.0,top: 15.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    //backgroundColor: Colors.green,
                                    //   radius: 15.0,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                      new Icon(
                                        Icons.phone_iphone_rounded,
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,

                                    children: <Widget>[
                                      FlatButton(
                                        child:Text(
                                          _GENERIC_CHANGE_MOBILE_NUMBER ,
                                          style: TextStyle(
                                            fontSize: 16.0,color: Color(0xff3D3D3D), fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => ChangeMobileno ()
                                              )
                                          );   //signup screen
                                        },
                                      )
                                    ],
                                  ),

                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),

                          Container(
                              padding: EdgeInsets.only(
                                  left: 20.0, top: 5.0),

                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    //backgroundColor: Colors.green,
                                    //   radius: 15.0,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.mail_outline,
                                        size: 25.0,
                                      ),
                                    ],

                                  ),

                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,

                                    children: <Widget>[
                                      FlatButton(
                                        child:Text(
                                          _GENERIC_CHANGE_EMAIL_ID ,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff3D3D3D), fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => ChangeEmailid()
                                              )
                                          );   //signup screen
                                        },
                                      )
                                    ],
                                  ),

                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 20.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.lock_open,
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,

                                    children: <Widget>[
                                      FlatButton(
                                        child:Text(
                                          _GENERIC_CHANGE_PASSWORD ,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff3D3D3D), fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => ChangePassword ()
                                              )
                                          );   //signup screen
                                        },
                                      )
                                    ],
                                  ),

                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 20.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.language,
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,

                                    children: <Widget>[
                                      FlatButton(
                                        child:Text(
                                          _GENERIC_CHOOSE_LANGUGAE ,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff3D3D3D), fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => ChooseLanguage()
                                              )
                                          );   //signup screen
                                        },
                                      )
                                    ],
                                  ),

                                ],
                              )),


                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}