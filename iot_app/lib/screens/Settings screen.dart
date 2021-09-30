import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_app/screens/AboutUs.dart';
import 'package:iot_app/screens/Help.dart';
import 'package:iot_app/screens/PrivacyPolicy.dart';
import 'package:iot_app/screens/TermsConditions.dart';

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

  @override
  void initState() {
    super.initState();
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
              Icons.arrow_back,
              color: Color(0xffEFCC00), // add custom icons also
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: new Container(
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
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 20.0, top: 15.0),
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
                                        child: Text(
                                          'Terms & conditions',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xff3D3D3D),
                                            fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          TermsConditions()));
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
                            endIndent: 10,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 20.0, top: 5.0),
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
                                        Icons.privacy_tip_outlined,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Privacy policies',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xff3D3D3D),
                                            fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PrivacyPolicy()));
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
                            endIndent: 10,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 20.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.help_center_outlined,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Help',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xff3D3D3D),
                                            fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HelpScreen()));
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
                            endIndent: 10,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 20.0, top: 5.0),
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
                                        child: Text(
                                          'About us',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xff3D3D3D),
                                            fontFamily: 'Montserrat',
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          AboutUS()));
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
