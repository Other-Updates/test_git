import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/registeraotpackscreen.dart';
import 'package:scotto/utils/Language.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;




class RegisterOtpVerification extends StatefulWidget {
  @override
  final customer_id;
  RegisterOtpVerification(this.customer_id);
  _RegisterOtpVerificationState createState() => _RegisterOtpVerificationState(this.customer_id);
  }

  class _RegisterOtpVerificationState extends State<RegisterOtpVerification> with SingleTickerProviderStateMixin {

    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final customer_id;
    _RegisterOtpVerificationState(this.customer_id);

    var _GENERIC_OTP_VERIFIED='';


    final TextEditingController pinnumber1controller = TextEditingController();
    final TextEditingController pinnumber2controller = TextEditingController();
    final TextEditingController pinnumber3controller = TextEditingController();
    final TextEditingController pinnumber4controller = TextEditingController();


    FocusNode f1 = FocusNode();
    FocusNode f2 = FocusNode();
    FocusNode f3 = FocusNode();
    FocusNode f4 = FocusNode();


    final focus = FocusNode();

    Timer timer;
    int totalTimeInSeconds;
    bool _hideResendButton;
    final int time = cOTPTimer;
    AnimationController _controller;

    get _getTimerText {
      return Container(
        height: 32,
        child: new Offstage(
          offstage: !_hideResendButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "The code will expired in ", style: TextStyle(fontSize: 16),),
              new SizedBox(
                width: 5.0,
              ),
              OtpTimer(_controller, 15.0, Colors.black)
            ],
          ),
        ),
      );
    }

    // Returns "Resend" button
    get _getResendButton {
      return Container(
          child: FlatButton(
            textColor: Color(0xff00DD00),
            child: Text(
              'Resend OTP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              resend(); //signup screen
            },
          )
      );
    }

    Future<Null> _startCountdown() async {
      setState(() {
        _hideResendButton = true;
        totalTimeInSeconds = time;
      });
      _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
    }



    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;

    getLanguage() async {
      _sharedPreferences = await _prefs;
      // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
      setState(() {
        _GENERIC_OTP_VERIFIED =
            Language.getLocalLanguage(
                _sharedPreferences, 'GENERIC_OTP_VERIFIED');
      });
    }


    otpverify() async {


      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Scprogressdialog("Verifying OTP..");
          }

      );

      String basicAuth = "Basic YWRtaW46MTIzNA==";

      var data = json.encode({
            "otp_code": pinnumber1controller.text + pinnumber2controller.text +
                pinnumber3controller.text + pinnumber4controller.text,
            "email": "",
            "mobile_number": ""
          });
      print(data);
      final response = await http.post(baseurl + 'api_check_customer_otp',
          headers: {'authorization': basicAuth}, body: data);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse ['status'] == 'Success') {
         /* StorageUtil.getItem("login_customer_detail_id");
          StorageUtil.getItem("login_customer_detail_mobile_number");

          var customer_details = jsonResponse['data']['customer_details'];
          var setting_details = jsonResponse['data']['settings'];
          StorageUtil.setItem(
              "login_customer_detail_id", customer_details['id']);
          StorageUtil.setItem("login_customer_detail_mobile_number",
              customer_details['mobile_number']);
          StorageUtil.setItem(
              "login_customer_detail_name", customer_details['name']);
          StorageUtil.setItem(
              "login_customer_detail_dob", customer_details['dob']);
          StorageUtil.setItem("login_customer_detail_mobile_gender",
              customer_details['gender']);
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
*/
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => RegisterOtpackScreen()));
          //   sharedPreferences.setString("token", jsonResponse['token']);
          _showMessageInScaffold(jsonResponse['message']);
        } else if (jsonResponse['status'] == 'Error') {
          Navigator.of(context).pop();
          print(jsonResponse['message']);
          _showMessageInScaffold(jsonResponse['message']);
        }
        //   sharedPreferences.setString("token", jsonResponse['token']);
      }
      else {
        Navigator.of(context).pop();
        _showMessageInScaffold('Contact Admin!!');
      }
    }


    resend() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Scprogressdialog("Please wait resending OTP..");
          }

      );
      String basicAuth = "Basic YWRtaW46MTIzNA==";
      //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var data = json.encode({"customer_id": this.customer_id});
      final response = await http.post(
          baseurl + 'api_send_otp', headers: {'authorization': basicAuth},
          body: data);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse ['status'] == 'Success') {
          print(jsonResponse['message']);
        }
        //   sharedPreferences.setString("token", jsonResponse['token']);
      }
      else {
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
      totalTimeInSeconds = time;
      _controller =
      AnimationController(vsync:this, duration: Duration(seconds: time))
        ..addStatusListener((status) {
          if (status == AnimationStatus.dismissed) {
            setState(() {
              _hideResendButton = !_hideResendButton;
            });
          }
        });
      _controller.reverse(
          from: _controller.value == 0.0 ? 1.0 : _controller.value);
      _startCountdown();
    }

    @override
    void dispose() {
      super.dispose();
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          key: _scaffoldKey,
          body: Center(

              child: Container(


                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          colorFilter: ColorFilter.mode(
                              Color(0xffF1FDF0).withOpacity(1.0),
                              BlendMode.dstATop),
                          fit: BoxFit.cover)
                  ),


                  child: ListView(

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                              top: 150.0, bottom: 10, left: 10.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'OTP Verification',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          )),

                      // OtpForm(),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 25.0),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                new Flexible(
                                  child: Container(
                                      height: 60,
                                      width: 80,
                                      padding: EdgeInsets.only(right: 25.0),
                                      child: TextField(
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        controller: pinnumber1controller,
                                        focusNode: f1,
                                        onChanged: (String newVal) {
                                          if (newVal.length == 1) {
                                            f1.unfocus();
                                            FocusScope.of(context).requestFocus(
                                                f2);
                                          }
                                        },
                                        maxLength: 1,
                                        textInputAction: TextInputAction.next,
                                        //  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: "",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Montserrat'),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide:
                                            BorderSide(color: Color(0xff00DD00),
                                                width: 0.8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide:
                                            BorderSide(color: Color(0xff00DD00),
                                                width: 0.8),
                                          ),
                                        ),
                                      )), flex: 4,
                                ),
                                new Flexible(
                                  child: Container(
                                    height: 60,
                                    width: 80,
                                    padding: EdgeInsets.only(right: 25.0),
                                    child: TextField(
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) =>
                                      FocusScope
                                          .of(context)
                                          .nextFocus,
                                      controller: pinnumber2controller,
                                      focusNode: f2,
                                      onChanged: (String newVal) {
                                        if (newVal.length == 1) {
                                          f2.unfocus();
                                          FocusScope.of(context).requestFocus(
                                              f3);
                                        }
                                      },
                                      maxLength: 1,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintStyle: TextStyle(color: Colors.grey,
                                            fontFamily: 'Montserrat'),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                          BorderSide(color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                          BorderSide(color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                      ),
                                    ),
                                  ), flex: 4,
                                ),
                                new Flexible(
                                  child: Container(
                                    //     padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    height: 60,
                                    width: 80,
                                    padding: EdgeInsets.only(right: 25.0),
                                    child: TextField(

                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) =>
                                      FocusScope
                                          .of(context)
                                          .nextFocus,
                                      keyboardType: TextInputType.number,
                                      controller: pinnumber3controller,
                                      focusNode: f3,
                                      onChanged: (String newVal) {
                                        if (newVal.length == 1) {
                                          f3.unfocus();
                                          FocusScope.of(context).requestFocus(
                                              f4);
                                        }
                                      },
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Montserrat'),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                          BorderSide(color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                          BorderSide(color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                      ),
                                    ),
                                  ), flex: 4,
                                ),
                                new Flexible(
                                  child: Container(
                                    height: 60,
                                    width: 55,

                                    //  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextField(
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) =>
                                          FocusScope.of(context)
                                              .unfocus(),
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      controller: pinnumber4controller,
                                      maxLength: 1,
                                      focusNode: f4,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Montserrat'),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                          BorderSide(color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                          BorderSide(color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                      ),
                                    ),
                                  ), flex: 4,),
                              ])),

                      Container(
                          height: 75,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),

                          child: RaisedButton(

                            textColor: Colors.white,
                            color: Color(0xff00DD00),
                            child: Text('Verify'),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            onPressed: () {
                              otpverify();

                            },
                          )),
                      _hideResendButton ? _getTimerText : _getResendButton,


                      Container(
                          padding: EdgeInsets.only(top: 0.5, bottom: 0.5),
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                textColor: Color(0xff00DD00),
                                child: Text(
                                  'OR',
                                  style: TextStyle(fontSize: 15),
                                ),

                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )),
/*

                      Container(
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                textColor: Color(0xff00DD00),
                                child: Text(
                                  'Change Mobile Number',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ChangeMobilenumberScreen()
                                      )
                                  ); //signup screen
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ))
*/

                    ],
                  ))));
    }
  }

  class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
  Duration duration = controller.duration * controller.value;
  if (duration.inHours > 0) {
  return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
  Duration duration = controller.duration;
  return duration;
  }

  @override
  Widget build(BuildContext context) {
  return AnimatedBuilder(
  animation: controller,
  builder: (BuildContext context, Widget child) {
  return new Text(
  timerString,
  style: new TextStyle(
  fontSize: fontSize,
  color: timeColor,
  fontWeight: FontWeight.w600),
  );
  });
  }
  }





