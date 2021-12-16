import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import 'package:scotto/Endmanualbardebit.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/rideprepaidscreen.dart';
import 'package:scotto/riderentprescreen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';

class EndBarDebit extends StatefulWidget {
  @override
  final trip_details;
  EndBarDebit(this.trip_details);
  _EndBarDebitState createState() => _EndBarDebitState(this.trip_details);
}

class _EndBarDebitState extends State<EndBarDebit> with TickerProviderStateMixin {
  final trip_details;
  _EndBarDebitState(this.trip_details);

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;

  var customer_details, scootoroDetails;
  var trip_number,
      scooter_id,
      payment_id,
      subscription_id,
      status,
      ride_start,
      ride_mins,
      ride_distance,
      ride_end,
      total_ride_amt,
      unlock_charge,
      sub_total,
      vat_charge,
      grand_total,
      scootertripenddetails;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  var _GENERIC_ENTER_QR = ' ',
      _GENERIC_SCAN_RIDE = '',
      _GENERIC_END_RIDE = '',
      _GENERIC_OK = '',
      _GENERIC_PARK_SCOOTER_SAFE = '',
      _GENERIC_PARK_SCOOTER_SAFE_MSG = '';

  getLanguage() async {
    _sharedPreferences = await _prefs;

    setState(() {
      _GENERIC_ENTER_QR =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_ENTER_QR');
      _GENERIC_SCAN_RIDE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_SCAN_RIDE");
      _GENERIC_END_RIDE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_END_RIDE");
      _GENERIC_PARK_SCOOTER_SAFE = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_PARK_SCOOTER_SAFE");
      _GENERIC_OK = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OK");
      _GENERIC_PARK_SCOOTER_SAFE_MSG = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_PARK_SCOOTER_SAFE_MSG");
    });
  }

  String customer_id = '';
  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;
      });
    } catch (ex) {
      print(ex);
    }
  }

  endRide() async {
    await getTextFromFile();

    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({
      "id": customer_id,
      "scootoro_id": trip_details['scooter_id'],
      "trip_number": trip_details['trip_number'],
      "distance": "2.2",
      "customer_id": customer_id,
      "scoo_lat": "2.76374863784",
      "scoo_long": "2.0699408594"
    });
    final response = await http.post(baseurl + 'api_ride_end',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    RidePrepaidScreen(trip_details)),
            (Route<dynamic> route) => false);
        _showMyDialog();
      } else if (jsonResponse['status'] == 'Error') {
        print(jsonResponse['message']);
        //   _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      //   _showMessageInScaffold('Contact Admin!!');
    }
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              GestureDetector(
                  child: Container(
                      padding: EdgeInsets.only(left: 15, top: 5),
                      alignment: Alignment.topRight,
                      child: new Icon(
                        Icons.close,
                        color: Color(0xff9A9090),
                        size: 24.0,
                      )),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RidePrepaidScreen(trip_details)),
                        (Route<dynamic> route) => false);
                  }),
              Container(
                child: Text(_GENERIC_PARK_SCOOTER_SAFE,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
              Container(
                alignment: Alignment.centerRight,
                height: 170,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/img_endride.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(_GENERIC_PARK_SCOOTER_SAFE_MSG,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Color(0xff9A9090),
                    )),
              ),
              Container(
                  height: 55,
                  padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Color(0xff00DD00),
                    child: Text('${_GENERIC_OK}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RideRentPreScreen(trip_details)));
                    },
                  )),
            ])
                ));
      },
    );
  }

//  Getting scooter details
  bool _isTorchOn = false;

  String _captureText = '';

  @override
  void initState() {
    super.initState();
    getLanguage();

    _captureController.onCapture((data) {
      print('onCapture----$data');
      setState(() {
        _captureText = data;
      });
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
            },
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
            ),
          ),
          title: Text(
            _GENERIC_SCAN_RIDE,
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff00DD00),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 800,
              child: QRCaptureView(
                controller: _captureController,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 56),
              child: AspectRatio(
                aspectRatio: 264 / 258.0,
                child: Stack(
                  alignment: _animation.value,
                  /* children: <Widget>[
  Image.asset('images/sao@3x.png'),
  Image.asset('images/tiao@3x.png')
  ],*/
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildToolBar1(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildToolBar(),
            ),
            Container(
              child: Text('$_captureText'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              _captureController.pause();
              _captureController.resume();
            },
            child: new Icon(
              Icons.filter_center_focus,
              color: Colors.white,
            ),
            //child: Text('pause'),
          ),
          FlatButton(
            onPressed: () {
              if (_isTorchOn) {
                _captureController.torchMode = CaptureTorchMode.off;
              } else {
                _captureController.torchMode = CaptureTorchMode.on;
              }
              _isTorchOn = !_isTorchOn;
            },
            child: new Icon(
              Icons.flash_on,
              color: Colors.white,
            ),
          ),
          /* FlatButton(
  onPressed: () {
  _captureController.resume();
  },
  child: Text('resume',style: TextStyle(color: Colors.white),),
  ),*/
        ]);
  }

  Widget _buildToolBar1() {
    return Container(
        height: 55,
        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
        child: ListView(children: [
          RaisedButton(
            textColor: Colors.white,
            color: Color(0xff00DD00),
            child: Text(_GENERIC_ENTER_QR,
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            ),
            onPressed: () {
              // login();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      EndManualBardebit(trip_details),
                ),
                (route) => false,
              );
            },
          )
        ]));
  }
}
