import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/Tutorialsscreen.dart';
import 'package:scotto/constants.dart';
import 'package:scotto/home_screen.dart';
import 'dart:convert';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:scotto/login_screen.dart';

class ChooseLanguage extends StatefulWidget {
  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String radioValue = '';

  getLanguageContents(language) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Fetching contents please wait");
        });

    var data = json.encode({"language": language});
    final response = await http.post(baseurl + 'api_get_all_contents',
        headers: {'authorization': basicAuth}, body: data);
    // print(response);
    final SharedPreferences prefs = await _prefs;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["status"] == "success") {
        StorageUtil.setItem("current_language", language);
        StorageUtil.setItem(
            "language_contents", jsonEncode(jsonResponse["data"]));
        bool tutorialScreen =
            prefs.getBool("tutorial_screen") != null ? true : false;
        /*  if(tutorialScreen){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>LoginScreen(),), (route) => false,);
        }else{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>OnboardingScreen(),), (route) => false,);
        }
*/
        checkLoginStatus();
        // _GENERIC_SPLASH  = await  StorageUtil.getItem("GENERIC_SPLASH");
        // StorageUtil.getLocalLanguage("GENERIC_SPLASH").then((data){
        //   print(data);
        //   setState(() {
        //     _GENERIC_SPLASH = data;
        //   });
        // });

        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>RechargeScreen(),), (route) => false,);
      }
    }
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login =
        prefs.getString("login_customer_detail_id") != null ? true : false;
    bool language = prefs.getString("language_contents") != null ? true : false;
    bool tutorialScreen =
        prefs.getBool("tutorial_screen") != null ? true : false;

    _mockCheckForSession().then((status) {
      if (!login && !tutorialScreen) {
        _navigateToOnboard();
      } else if (login) {
        _navigateToHome();
      } else {
        _navigateToLogin();
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    return true;
  }

  void _navigateToOnboard() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => OnboardingScreen()));
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  getCurrentLanguage() async {
    StorageUtil.getItem("current_language").then((data) {
      setState(() {
        radioValue = data;
      });
    });
  }

  void handleRadioValueChanged(String value) {
    setState(() {
      radioValue = value;
      getLanguageContents(value);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* appBar: AppBar(
          backgroundColor: Color(0xff00DD00),
          title: Text(_GENERIC_SPLASH),
        ),*/
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        colorFilter: ColorFilter.mode(
                            Color(0xff00DD00), BlendMode.color),
                        fit: BoxFit.cover)),
                child: ListView(children: <Widget>[
                  GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(left: 20, top: 15),
                          alignment: Alignment.topLeft,
                          child: new Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 24.0,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  Container(
                      padding: EdgeInsets.only(
                          left: 32.0, right: 32.0, top: 120.0, bottom: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Center(
                        child: Image.asset('assets/images/logo.png',
                            width: 140, height: 90, fit: BoxFit.fill),
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          left: 32.0, right: 32.0, top: 20.0, bottom: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose Language',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 18),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        color: Colors.white,
                        child: new Column(children: [
                          Card(
                              //    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: new Column(children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: new Row(
                                        //      mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: new Text(
                                                'English',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xff00DD00),
                                                ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Flexible(
                                            child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                //    padding: EdgeInsets.only(left: 80.0),
                                                child: new Radio(
                                                  autofocus: true,
                                                  value: 'en',
                                                  groupValue: radioValue,
                                                  hoverColor: Color(0xff00DD00),
                                                  focusColor: Color(0xff00DD00),
                                                  activeColor:
                                                      Color(0xff00DD00),
                                                  onChanged: (String value) {
                                                    handleRadioValueChanged(
                                                        value);
                                                  },
                                                )),
                                            flex: 2,
                                          ),
                                        ])),
                              ])),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Card(
                              //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: new Column(children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: new Row(
                                        //      mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: new Text(
                                                'عَرَبِيّ',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xff00DD00),
                                                    fontSize: 22.0),
                                                //    "${questionBank[_counter.toString()]["ans2"]}")
                                                //  ],
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              //    padding: EdgeInsets.only(left: 80.0),
                                              child: new Radio(
                                                autofocus: true,
                                                value: 'ar',
                                                groupValue: radioValue,
                                                hoverColor: Color(0xff00DD00),
                                                focusColor: Color(0xff00DD00),
                                                activeColor: Color(0xff00DD00),
                                                onChanged: (String value) {
                                                  handleRadioValueChanged(
                                                      value);
                                                },
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ])),
                              ])),
                          /*                            Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child:new Row(
                                      //      mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[

                                          new FlatButton(
                                              child: new Text(
                                                'English',textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                              ),
                                              onPressed:(){

                                              }
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(left:130.0),
                                              child:new Radio(
                                                autofocus: true,
                                                value: 'en',
                                                groupValue: radioValue,
                                                hoverColor: Color(0xff00DD00),
                                                focusColor: Color(0xff00DD00),
                                                activeColor: Color(0xff00DD00),
                                                onChanged: (String value) {
                                                  handleRadioValueChanged(value);

                                                },

                                              ) ) ]   )),
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: new Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new FlatButton(
                                              child:new Text(
                                                'عَرَبِيّ',textAlign: TextAlign.left,style: TextStyle(color:Color(0xff00DD00),fontSize: 22.0),
                                                //    "${questionBank[_counter.toString()]["ans2"]}")
                                                //  ],
                                              ), onPressed:(){

                                          }  ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(left:130.0),
                                            child: new Radio(
                                              autofocus: true,
                                              value: 'ar',
                                              groupValue: radioValue,
                                              hoverColor: Color(0xff00DD00),
                                              focusColor: Color(0xff00DD00),
                                              activeColor: Color(0xff00DD00),
                                              onChanged: (String value) {
                                                handleRadioValueChanged(value);
                                              },),),

                                        ]  ) ),*/
                        ]),
                      ))
                ]))));
  }
}
