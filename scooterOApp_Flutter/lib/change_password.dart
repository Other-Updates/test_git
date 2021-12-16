import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  var _GENERIC_CHANGE_MOBILE_NUMBER = ' ',
      _GENERIC_ENTER_PRESENT_NUMBER = '',
      _GENERIC_GENERATE_OTP = '';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_GENERATE_OTP =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_GENERATE_OTP');
      _GENERIC_CHANGE_MOBILE_NUMBER = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_CHANGE_MOBILE_NUMBER");
      _GENERIC_ENTER_PRESENT_NUMBER = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_ENTER_PRESENT_NUMBER");
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

  changepassword() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog(" Please wait while changing password...");
        });
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      Navigator.pop(context);
      return;
    }
    if (oldpasswordController.text == "") {
      Navigator.pop(context);
      _showMessageInScaffold("Please enter correct password");
    } else if (newpasswordController.text == "") {
      Navigator.pop(context);
      _showMessageInScaffold("Please enter new password");
    } else if (confirmpasswordController.text == "") {
      Navigator.pop(context);
      _showMessageInScaffold("Please enter confirm password");
    } else if (confirmpasswordController.text != newpasswordController.text) {
      _showMessageInScaffold("confirm password doesn't match");
    }
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    var data = json.encode({
      "id": customer_id,
      "old_password": oldpasswordController.text,
      "new_password": newpasswordController.text
    });
    final response = await http.post(baseurl + 'api_change_new_password',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 'Success') {
        Navigator.pop(context);
        StorageUtil.getItem("login_customer_detail_id");
        StorageUtil.getItem("login_customer_detail_plain_password");
        StorageUtil.setItem(
            "login_customer_detail_new_password", "new_password");
        _showMessageInScaffold(jsonResponse['message']);
        Navigator.pop(context);
        // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        print(jsonResponse['message']);
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      Navigator.pop(context);
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
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen()));
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white, // add custom icons also
          ),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              fontFamily: 'Montserrat',
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff00DD00),
      ),
      body: new Container(
        color: Color(0xffF1FDF0),
        child: new ListView(
          children: <Widget>[
            Container(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: TextFormField(
                          key: ValueKey('password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter old password';
                            }
                            return null;
                          },
                          controller: oldpasswordController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                            hintText: 'Enter current password',
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Color(0xff00DD00), size: 20),
                            hintStyle: TextStyle(
                                color: Colors.grey, fontFamily: 'Montserrat'),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            //  labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: TextFormField(
                          key: ValueKey('password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter new password';
                            }
                            return null;
                          },
                          controller: newpasswordController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                            hintText: 'Enter new password',
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Color(0xff00DD00), size: 20),
                            hintStyle: TextStyle(
                                color: Colors.grey, fontFamily: 'Montserrat'),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            //  labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: TextFormField(
                          key: ValueKey('password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter confirm password';
                            }
                            return null;
                          },
                          controller: confirmpasswordController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                            hintText: 'Confirm new password',
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Color(0xff00DD00), size: 20),
                            hintStyle: TextStyle(
                                color: Colors.grey, fontFamily: 'Montserrat'),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            //  labelText: 'Password',
                          ),
                        ),
                      ),
                    ]))),
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(14, 15, 14, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  //  border: EdgeInsets.fromLTRB(10,8, 10, 0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Color(0xff00DD00),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  onPressed: () {
                    changepassword();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
