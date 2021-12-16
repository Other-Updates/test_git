import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/forgotpassotp_verification.dart';
import 'constants.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/registration_screen.dart';
import 'package:scotto/choose_language.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/constants.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgetNumberController = TextEditingController();

  bool _isLoading = false;

  void _onLoading() {
    setState(() {
      _isLoading = true;
      new Future.delayed(new Duration(seconds: 3), login);
    });
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  var _GENERIC_LOGIN = ' ',
      _GENERIC_FORGET_GENERATE_OTP = '',
      _GENERIC_ENTER_MOBILE_NUMBER = '',
      _GENERIC_CHOOSE_LANGUGAE = '',
      _GENERIC_PASSWORD = '',
      _GENERIC_FORGET_PASSWORD = '',
      _GENERIC_OR = '',
      _GENERIC_NEW_USER_REGISTER = '';

  getLanguage() async {
    _sharedPreferences = await _prefs;

    setState(() {
      _GENERIC_LOGIN =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_LOGIN');
      _GENERIC_ENTER_MOBILE_NUMBER = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_ENTER_MOBILE_NUMBER");
      _GENERIC_CHOOSE_LANGUGAE = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_CHOOSE_LANGUGAE");
      _GENERIC_PASSWORD =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PASSWORD");
      _GENERIC_FORGET_PASSWORD = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_FORGET_PASSWORD");
      _GENERIC_OR = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OR");
      _GENERIC_NEW_USER_REGISTER = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_NEW_USER_REGISTER");
      _GENERIC_FORGET_GENERATE_OTP = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_FORGET_GENERATE_OTP");
    });
  }

  login() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    if (phoneNumberController.text == "") {
      _showMessageInScaffold("Please enter mobile number");
    } else if (passwordController.text == "") {
      _showMessageInScaffold("Please enter password");
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Please wait while logging in ...");
        });

    var data = json.encode({
      "mobile_number": phoneNumberController.text,
      "password": passwordController.text,
      "isGoogle": "",
      "googleid ": ""
    });
    final response = await http.post(baseurl + 'api_customer_login',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var customer_details = jsonResponse['data']['customer_details'];
        var setting_details = jsonResponse['data']['settings'];
        StorageUtil.setItem("login_customer_detail_id", customer_details['id']);
        StorageUtil.setItem("login_customer_detail_mobile_number",
            customer_details['mobile_number']);
        StorageUtil.setItem(
            "login_customer_detail_name", customer_details['name']);
        StorageUtil.setItem(
            "login_customer_detail_dob", customer_details['dob']);
        StorageUtil.setItem(
            "login_customer_detail_mobile_gender", customer_details['gender']);
        StorageUtil.setItem("login_customer_detail_plain_password",
            customer_details['plain_password']);
        StorageUtil.setItem(
            "login_customer_detail_email", customer_details['email']);
        StorageUtil.setItem(
            "login_setting_detail_vatt", setting_details['vatt']);
        StorageUtil.setItem(
            "login_setting_detail_copy_right", setting_details['copy_right']);
        StorageUtil.setItem("login_setting_detail_site_address",
            setting_details['site_address']);
        StorageUtil.setItem(
            "login_setting_detail_email", setting_details['contact_email']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      Navigator.pop(context);
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  forgetPassword() async {
    final isValid = _formKey1.currentState.validate();
    if (!isValid) {
      return;
    }
    if (forgetNumberController.text == "") {
      _showMessageInScaffold("Please enter mobile number");
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog(
              "Please wait while verifying mobile number..");
        });

    String basicAuth = "Basic YWRtaW46MTIzNA==";
    var data = json.encode({
      "type": "forget password",
      "data": "",
      "mobile_number": forgetNumberController.text
    });
    print(data);
    final response = await http.post(baseurl + 'api_generate_otp',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var customerId = jsonResponse['id'];
        print(customerId);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ForgotOtp(customerId)));
        forgetNumberController.clear();
      } else if (jsonResponse['status'] == 'Error') {
        print(jsonResponse['message']);
        _showMessageInScaffold('Invalid phone number');
        Navigator.pop(context);
      }
    } else {
      _showMessageInScaffold('Invalid phone number');
      Navigator.pop(context);
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
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        colorFilter: ColorFilter.mode(
                            Color(0xffE6FFE6).withOpacity(1.0),
                            BlendMode.dstATop),
                        fit: BoxFit.cover)),
                child: ListView(
                  children: <Widget>[
                    Container(
                        padding:
                            EdgeInsets.only(top: 200.0, bottom: 10, left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${_GENERIC_LOGIN}',
                          style: TextStyle(
                              color: Color(0xff676767),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 22),
                        )),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                              child: TextFormField(
                                // obscureText: true,
                                maxLength: 10,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter mobile number';
                                  } else if (value.length < 10) {
                                    return "Your phone number must be in 10 digits";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 15, 5, 0),
                                  border: InputBorder.none,
                                  counterText: "",
                                  hintText: _GENERIC_ENTER_MOBILE_NUMBER,
                                  prefixIcon: Icon(Icons.phone_outlined,
                                      color: Color(0xff00DD00), size: 20),
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
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
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 15, 5, 0),
                                  hintText: _GENERIC_PASSWORD,
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: Color(0xff00DD00), size: 20),
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
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
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xff00DD00),
                          child: Text('${_GENERIC_LOGIN}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold)),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            login();
                          },
                        )),
                    Container(
                        child: new Row(
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            textColor: Color(0xffB1B1B1),
                            child: Text(
                              _GENERIC_CHOOSE_LANGUGAE,
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Montserrat'),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ChooseLanguage())); //signup screen
                            },
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: FlatButton(
                            textColor: Color(0xffB1B1B1),
                            child: Text(
                              _GENERIC_FORGET_PASSWORD,
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Montserrat'),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    18, 25, 12, 0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    _GENERIC_FORGET_PASSWORD,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xff676767),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Form(
                                              key: _formKey1,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    18, 8, 18, 0),
                                                child: TextFormField(
                                                  maxLength: 10,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter mobile number';
                                                    } else if (value.length <
                                                        10) {
                                                      return "Your phone number must be in 10 digits";
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      forgetNumberController,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 15, 5, 0),
                                                    border: InputBorder.none,
                                                    counterText: "",
                                                    hintText:
                                                        _GENERIC_ENTER_MOBILE_NUMBER,
                                                    prefixIcon: Icon(
                                                        Icons.phone_outlined,
                                                        color:
                                                            Color(0xff00DD00),
                                                        size: 20),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Montserrat'),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Color(0xff00DD00),
                                                          width: 0.8),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Color(0xff00DD00),
                                                          width: 0.8),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Color(0xff00DD00),
                                                          width: 0.8),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Color(0xff00DD00),
                                                          width: 0.8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 10, 20, 18),
                                                child: RaisedButton(
                                                  textColor: Colors.white,
                                                  color: Color(0xff00DD00),
                                                  child: Text(
                                                    _GENERIC_FORGET_GENERATE_OTP,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(8.0),
                                                  ),
                                                  onPressed: () {
                                                    forgetPassword();
                                                  },
                                                )),
                                          ],
                                        ));
                                  });
                            },
                          ),
                          flex: 2,
                        )
                      ],
                    )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        FlatButton(
                          textColor: Color(0xff00DD00),
                          child: Text(
                            _GENERIC_OR,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xffB1B1B1),
                            ),
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
                            _GENERIC_NEW_USER_REGISTER,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RegistrationScreen()));
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ],
                ))));
  }
}

/*
class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;
  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
*/
