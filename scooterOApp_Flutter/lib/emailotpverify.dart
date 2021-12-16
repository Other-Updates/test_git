import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scotto/Emailacknowledge.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'constants.dart';
import 'package:scotto/changemobilenumber.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EmailOtpverify extends StatefulWidget {
  EmailOtpverify(String customer_details);

  @override
  EmailOtpverifyState createState() => EmailOtpverifyState();
}

class EmailOtpverifyState extends State<EmailOtpverify>
    with SingleTickerProviderStateMixin {
  String customer_details;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController otpcontroller = TextEditingController();
  TextEditingController pinnumber1controller = TextEditingController();
  TextEditingController pinnumber2controller = TextEditingController();
  TextEditingController pinnumber3controller = TextEditingController();
  TextEditingController pinnumber4controller = TextEditingController();

  var _GENERIC_OTP_VERIFY = ' ',
      _GENERIC_VERIFY = '',
      _GENERIC_OR = '',
      _GENERIC_CHANGE_MOBILE_NUMBER = ' ',
      _GENERIC_OTP_RESEND = '';

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
        _GENERIC_OTP_RESEND,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        resend(); //signup screen
      },
    ));
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

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_OTP_VERIFY =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_OTP_VERIFY');
      _GENERIC_VERIFY =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_VERIFY");
      _GENERIC_OR = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OR");
      _GENERIC_CHANGE_MOBILE_NUMBER = Language.getLocalLanguage(
          _sharedPreferences, 'GENERIC_CHANGE_MOBILE_NUMBER');
      _GENERIC_OTP_RESEND =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_OTP_RESEND");
    });
  }

  otpVerification() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Verifying OTP..");
        });

    String basicAuth = "Basic YWRtaW46MTIzNA==";
    var data = json.encode({
      "id": mobile_test,
      "type": "change email",
      "data": "",
      "mobile_number": "",
      "otp_code": pinnumber1controller.text +
          pinnumber2controller.text +
          pinnumber3controller.text +
          pinnumber4controller.text
    });
    final response = await http.post(baseurl + 'api_generate_otp',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 'Success') {
        StorageUtil.getItem("login_customer_detail_id");
        StorageUtil.getItem("login_customer_detail_mobile_number");
        StorageUtil.getItem("login_customer_detail_email");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Emailacknowledge()));
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

  resend() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Please wait resending OTP..");
        });
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({"customer_id": mobile_test});
    print("datamossdsddel======" + data);
    final response = await http.post(baseurl + 'api_send_otp',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 'Success') {
        Navigator.pop(context);
        print(jsonResponse['message']);
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
    getLanguage();
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
                          _GENERIC_OTP_VERIFY,
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

                    /*       onPressed: () {
              setState(() {
                if (_fourthDigit != null) {
                  _fourthDigit = null;
                } else if (_thirdDigit != null) {
                  _thirdDigit = null;
                } else if (_secondDigit != null) {
                  _secondDigit = null;
                } else if (_firstDigit != null) {
                  _firstDigit = null;
                }
              });
            }*/

                    /*      Container(
                   child: OTPTextField(
                     length: 5,
                     width: MediaQuery.of(context).size.width,
                     textFieldAlignment: MainAxisAlignment.spaceAround,
                     fieldWidth: 50,
                     fieldStyle: FieldStyle.underline,
                     style: TextStyle(
                         fontSize: 17
                     ),
                     onChanged: (pin) {
                       print("Changed: " + pin);
                     },
                     onCompleted: (pin) {
                       print("Completed: " + pin);
                     },
                   )   ),
*/
                    //  SizedBox(height: SizeConfig.screenHeight ),

                    /*  GestureDetector(
                onTap: () {
                  // OTP code resend
                },
                child: Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                )  ),*/

                    /*                SizedBox(height: 8,),
              Container(
              //  padding: EdgeInsets.only(left: 50),
                     // SizedBox(height: 8,),
                  //SizedBox(height: 8,),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          otpBoxBuilder(),
                          SizedBox(width: 5,),
                          otpBoxBuilder(),
                          SizedBox(width: 5,),
                          otpBoxBuilder(),
                          SizedBox(width: 5,),
                          otpBoxBuilder(),
                        ],
                      )   ),
*/

                    Container(
                        height: 75,
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xff00DD00),
                          child: Text(_GENERIC_VERIFY),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            otpVerification();
                            //   print(nameController.text);
                            //  print(passwordController.text);
                            /*  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OtpVerification()
                                  )
                              );*/
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
                                _GENERIC_OR,
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
                            _GENERIC_CHANGE_MOBILE_NUMBER,
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChangeMobilenumberScreen(
                                        customer_details))); //signup screen
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
            //    style: TextStyle(color: kPrimaryColor),
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
