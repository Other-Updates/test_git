import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:scotto/emailotpverify.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ChangeEmailid extends StatefulWidget {

  @override
  ChangeEmailidState createState() => ChangeEmailidState();

}

class ChangeEmailidState extends State<ChangeEmailid> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController changeemailController = TextEditingController();

  var _GENERIC_CHANGE_EMAIL_ID = ' ',_GENERIC_ENTER_PRESENT_EMAIL = '', _GENERIC_GENERATE_OTP ='' ;



  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_CHANGE_EMAIL_ID = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_CHANGE_EMAIL_ID');
      _GENERIC_ENTER_PRESENT_EMAIL = Language.getLocalLanguage(_sharedPreferences, "GENERIC_ENTER_PRESENT_EMAIL");
      _GENERIC_GENERATE_OTP = Language.getLocalLanguage(_sharedPreferences, "GENERIC_GENERATE_OTP");

    });

  }



  String mobile_test = '';
  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        mobile_test = data;
      });
    } catch (ex) {
      print(ex);
    }
  }



  changeemail() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return Scprogressdialog("Updating email address..");
        }

    );
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      Navigator.pop(context);
      return;
    }
    if(changeemailController.text == "") {
      Navigator.pop(context);
      _showMessageInScaffold("Please enter Email Id");
    }
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data =json.encode( {"data":changeemailController.text,"id":mobile_test,"mobile_number":"","type":"change email"});
   print("datamodel======"+data);
    final response = await http.post(baseurl + 'api_generate_otp', headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var  jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "Success"){
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EmailOtpverify('customer_details')));
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);
        print(jsonResponse['message']);
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
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
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color:Colors.white,// add custom icons also
          ),
        ),
        title: Text( _GENERIC_CHANGE_EMAIL_ID ,style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 18.0,
            fontFamily: 'Montserrat',
            color: Colors.white),),
        centerTitle: true,
        backgroundColor:Color(0xff00DD00),

      ),
      body: new Container(
        color: Color(0xffF1FDF0),
        child: new ListView(
          children: <Widget>[
        Form(
        key: _formKey,
          child: Container(
            //  height: 65,
              padding: EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: TextFormField(
                validator: (value){
                  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  // Null check
                  if(value.isEmpty){
                    return 'please enter your email';
                  }
                  else if(!regex.hasMatch(value)){
                    return 'Enter valid email address';
                  }
                  // success condition

                  return null;
                },

                keyboardType: TextInputType.emailAddress,
                controller: changeemailController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                  hintText: _GENERIC_ENTER_PRESENT_EMAIL ,
                  prefixIcon: Icon(Icons.email_outlined,color: Color(0xff00DD00),size: 20),
                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                  ),
                  //   labelText: 'Enter Email Id',
                  /*enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),*/

                ),
              ),
          )  ),

            Container(
                height: 50,
                margin:EdgeInsets.fromLTRB(14,15, 14, 0),
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

                  child: Text( _GENERIC_GENERATE_OTP ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                  onPressed: () {
                    changeemail();

                  },
                )),


          ],
        ),
      ),
    );


  }
}