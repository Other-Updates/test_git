import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/ChangeMobileotpverifylog.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/login_screen.dart';
import 'package:scotto/registration_screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ChangeMobilenumberScreen extends StatefulWidget {
  String customer_details;
  ChangeMobilenumberScreen(customer_details);
  @override
  ChangeMobilenumberScreenState createState() => ChangeMobilenumberScreenState();
  }
  class ChangeMobilenumberScreenState extends State<ChangeMobilenumberScreen> {


  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController changemobilenoController = TextEditingController();

  var _GENERIC_CHANGE_MOBILE_NUMBER = ' ',_GENERIC_ENTER_MOBILE_NUMBER = '', _GENERIC_GENERATE_OTP ='', _GENERIC_ALREADY_HAVE_ACCOUNT = ' ',_GENERIC_OR = '', _GENERIC_NEW_USER_REGISTER ='' ;



  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_CHANGE_MOBILE_NUMBER = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_CHANGE_MOBILE_NUMBER');
      _GENERIC_ENTER_MOBILE_NUMBER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_ENTER_MOBILE_NUMBER");
      _GENERIC_GENERATE_OTP = Language.getLocalLanguage(_sharedPreferences, "GENERIC_GENERATE_OTP");
      _GENERIC_ALREADY_HAVE_ACCOUNT = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_ALREADY_HAVE_ACCOUNT');
      _GENERIC_OR = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OR");
      _GENERIC_NEW_USER_REGISTER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_NEW_USER_REGISTER");


    });

  }

  String customer_id = '';


   getTextFromFile() async {
    try {

      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;

      });
    } catch (ex) {
      print(ex);
    }
  }

  changenumber() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return Scprogressdialog("Updating mobile number..");
        }

    );
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data =json.encode( {"id":customer_id,"type":"change mobile","data":changemobilenoController,"mobile_number":""});
    final response = await http.post(baseurl+'api_generate_otp', headers: {'authorization': basicAuth}, body: data);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200) {
      var  jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse ['status'] == 'Success') {
        _showMessageInScaffold( jsonResponse['message']);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChangeMobileotpverifylog("customer_details")));
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.of(context).pop();
      _showMessageInScaffold(jsonResponse['message']);
    }
  } else {
      Navigator.of(context).pop();
  _showMessageInScaffold('Contact Admin!!');
  }
  }

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getTextFromFile();
    getLanguage();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        colorFilter: ColorFilter.mode(Color(0xffF1FDF0).withOpacity(1.0), BlendMode.dstATop),

                        fit: BoxFit.cover)
                ),



                child: ListView(

                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 150.0,bottom: 10,left: 10.0),
                        alignment: Alignment.centerLeft,

                        child: Text(
                          _GENERIC_CHANGE_MOBILE_NUMBER ,
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: changemobilenoController,
                        decoration: InputDecoration(
                          hintText: _GENERIC_ENTER_MOBILE_NUMBER ,
                          prefixIcon: Icon(Icons.phone_outlined,color: Color(0xff00DD00),size: 20),
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                          ),

                          //    labelText: 'Enter mobile number',
                        ),
                      ),
                    ),


                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10,8, 10, 0),
                        child: RaisedButton(

                          textColor: Colors.white,
                          color: Color(0xff00DD00),
                          child: Text(_GENERIC_GENERATE_OTP),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            changenumber();

                          },
                        )),

                    Container(
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor: Color(0xff00DD00),
                              child: Text(
                                _GENERIC_ALREADY_HAVE_ACCOUNT ,
                                style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => LoginScreen()
                                    )
                                );   //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )),
                    Container(
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor:Color(0xff00DD00),
                              child: Text(
                                _GENERIC_OR ,
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
                                _GENERIC_NEW_USER_REGISTER ,
                                style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => RegistrationScreen()
                                    )
                                );   //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ))
                  ],
                ) )) );
  }
}
