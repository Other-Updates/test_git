import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:scotto/mobilenumberotpverify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeMobileno extends StatefulWidget {
  @override
  ChangeMobilenoState createState() => ChangeMobilenoState();
}

class ChangeMobilenoState extends State<ChangeMobileno> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController changemobilenoController = TextEditingController();

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

  var customer_details, scootoroDetails;

  String customer_id = '';

  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;
        print(data);
      });
    } catch (ex) {
      print(ex);
    }
  }

  changenumber() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Updating mobile number..");
        });

    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      Navigator.of(context).pop();
      return;
    }
    if (changemobilenoController.text == "") {
      Navigator.of(context).pop();
      _showMessageInScaffold("Please enter  mobile number");
    }

    String basicAuth = "Basic YWRtaW46MTIzNA==";

    var data = json.encode({
      "id": customer_id,
      "type": "change mobile",
      "data": changemobilenoController.text,
      "mobile_number": ""
    });
    print(data);
    final response = await http.post(baseurl + 'api_generate_otp',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        /* StorageUtil.getItem("login_customer_detail_id");
        StorageUtil.getItem("login_customer_detail_mobile_number");
        StorageUtil.getItem("login_customer_detail_email");*/
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                MobilenumberotpVerify('customer_details')));
      } else if (jsonResponse['status'] == 'Error') {
        print(jsonResponse['message']);
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
    getLanguage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white, // add custom icons also
          ),
        ),
        title: Text(
          _GENERIC_CHANGE_MOBILE_NUMBER,
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
            Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                // height: 55,
                padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: TextFormField(
                  maxLength: 10,
                  maxLines: 1,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (value.length < 10) {
                      return "Your phone number must be in 10 digits";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  controller: changemobilenoController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                    border: InputBorder.none,
                    counterText: "",
                    hintText: _GENERIC_ENTER_PRESENT_NUMBER,
                    prefixIcon: Icon(Icons.phone_outlined,
                        color: Color(0xff00DD00), size: 20),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                        fontSize: 20.0),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(color: Color(0xff00DD00), width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(color: Color(0xff00DD00), width: 0.8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(color: Color(0xff00DD00), width: 0.8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(color: Color(0xff00DD00), width: 0.8),
                    ),
                  ),
                ),
              ),
            ),
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
                    _GENERIC_GENERATE_OTP,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  onPressed: () {
                    changenumber();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
