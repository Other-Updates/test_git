import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/forgotpasswordackscreen.dart';

import 'constants.dart';
import 'package:scotto/changemobilenumber.dart';
import 'package:http/http.dart' as http;

class ForgotOtp extends StatefulWidget {
  @override
  final customer_id;
  ForgotOtp(this.customer_id);
  _ForgotOtpState createState() => _ForgotOtpState(this.customer_id);
}

class _ForgotOtpState extends State<ForgotOtp>
    with SingleTickerProviderStateMixin {
  final customer_id;
  _ForgotOtpState(this.customer_id);

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  bool loader = false;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController pinnumber1controller = TextEditingController();
  TextEditingController pinnumber2controller = TextEditingController();
  TextEditingController pinnumber3controller = TextEditingController();
  TextEditingController pinnumber4controller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();

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
              "The code will expired in ",
              style: TextStyle(fontSize: 16),
            ),
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
    ));
  }

  otpverify() async {
    // await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Verifying OTP..");
        });
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({
      "id": this.customer_id,
      "type": "forget password",
      "data": "",
      "mobile_number": "",
      "otp_code": pinnumber1controller.text +
          pinnumber2controller.text +
          pinnumber3controller.text +
          pinnumber4controller.text
    });
    print(data);
    final response = await http.post(baseurl + 'api_generate_otp',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 'Success') {
        loader = false;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => forgotpasswordackscreen()),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.of(context).pop();
        print(jsonResponse['message']);
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      Navigator.of(context).pop();
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  resend() async {
    // await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Please wait resending OTP..");
        });
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({"customer_id": this.customer_id});
    print(data);
    final response = await http.post(baseurl + 'api_send_otp',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 'Success') {
        Navigator.of(context).pop();
        _showMessageInScaffold(jsonResponse['message']);
        print(jsonResponse['message']);
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.of(context).pop();
        print(jsonResponse['message']);
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

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  @override
  void initState() {
    super.initState();
    //getTextFromFile();
    totalTimeInSeconds = time;
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
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
                        fit: BoxFit.cover)),
                child: ListView(
                  children: <Widget>[
                    Container(
                        padding:
                            EdgeInsets.only(top: 150.0, bottom: 10, left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'OTP Verification',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
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
                                          FocusScope.of(context)
                                              .requestFocus(f2);
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
                                          borderSide: BorderSide(
                                              color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide: BorderSide(
                                              color: Color(0xff00DD00),
                                              width: 0.8),
                                        ),
                                      ),
                                    )),
                                flex: 4,
                              ),
                              new Flexible(
                                child: Container(
                                  height: 60,
                                  width: 80,
                                  padding: EdgeInsets.only(right: 25.0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus,
                                    controller: pinnumber2controller,
                                    focusNode: f2,
                                    onChanged: (String newVal) {
                                      if (newVal.length == 1) {
                                        f2.unfocus();
                                        FocusScope.of(context).requestFocus(f3);
                                      }
                                    },
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
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
                                        borderSide: BorderSide(
                                            color: Color(0xff00DD00),
                                            width: 0.8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Color(0xff00DD00),
                                            width: 0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 4,
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
                                        FocusScope.of(context).nextFocus,
                                    keyboardType: TextInputType.number,
                                    controller: pinnumber3controller,
                                    focusNode: f3,
                                    onChanged: (String newVal) {
                                      if (newVal.length == 1) {
                                        f3.unfocus();
                                        FocusScope.of(context).requestFocus(f4);
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
                                        borderSide: BorderSide(
                                            color: Color(0xff00DD00),
                                            width: 0.8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Color(0xff00DD00),
                                            width: 0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 4,
                              ),
                              new Flexible(
                                child: Container(
                                  height: 60,
                                  width: 55,

                                  //  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).unfocus(),
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
                                        borderSide: BorderSide(
                                            color: Color(0xff00DD00),
                                            width: 0.8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Color(0xff00DD00),
                                            width: 0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 4,
                              ),
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChangeMobilenumberScreen(
                                        customer_id))); //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ],
                ))));
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 50.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
          ),
        ),
      ],
    );
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
