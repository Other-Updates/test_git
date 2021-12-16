import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/manual_barcode.dart';
import 'package:scotto/paymentmethodscreen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';

class BarCode extends StatefulWidget {
  @override
  _BarCodeState createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> with TickerProviderStateMixin {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;
  var _GENERIC_ENTER_QR = ' ',
      _GENERIC_SCAN_RIDE = '',
      _GENERIC_UNLOCK_SCOOTER = '';
  var customer_details, scootoroDetails;
  var serial_number = '',
      battery_life = '',
      scooter_id = '',
      scootoroAllDetails;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_ENTER_QR =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_ENTER_QR');
      _GENERIC_SCAN_RIDE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_SCAN_RIDE");
      _GENERIC_UNLOCK_SCOOTER = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_UNLOCK_SCOOTER");
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

  checkQrcode(scooterId) async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog(" Getting scooter details");
        });
    var cus = customer_id;
    var data = json.encode({
      "qr_code": scooterId,
      "customer_id": cus,
    });
    final response = await http.post(baseurl + 'scan_qr_code',
        headers: {'authorization': basicAuth}, body: data);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        var scootoroDetails = jsonResponse['scootoro_details'];

        setState(() {
          scootoroAllDetails = scootoroDetails;
          scooter_id = scootoroDetails['scooter_id'];
          serial_number = scootoroDetails['serial_number'];
          battery_life = scootoroDetails['battery_life'];
        });

        showModalBottomSheet1();
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        _showMessageInScaffold(Color(0xff00DD00), jsonResponse['message']);
      }
    } else {
      Navigator.pop(context);
      _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
    }
  }

//  Getting scooter details
  bool _isTorchOn = false;
  String _captureText = '';

  @override
  void initState() {
    super.initState();
    getLanguage();
    _captureController.onCapture((data) {
      setState(() {
        _captureText = data;
        checkQrcode(data);
      });
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {})
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

/*
  unlockScooter(scooterId) async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Getting scooter details");
        });
    */
/*  if (entercodeController.text == "") {
      _showMessageInScaffold(Color(0xff00DD00),"Enter QR code");
    }*/ /*

    var cus = customer_id;
    var data = json.encode({
      "qr_code": scooterId,
      "customer_id": cus,
    });
    final response = await http.post(baseurl + 'scan_qr_code',
        headers: {'authorization': basicAuth}, body: data);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 'Success') {
        var scootoroDetails = jsonResponse['scootoro_details'];
        setState(() {
          scootoroAllDetails = scootoroDetails;
          // scooter_id = scootoroDetails ['scooter_id'];
          serial_number = scootoroDetails['serial_number'];
          battery_life = scootoroDetails['battery_life'];
        });
        showModalBottomSheet1();
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        _showMessageInScaffold(Color(0xff00DD00), jsonResponse['message']);
      }
    } else {
      Navigator.pop(context);
      _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
    }
  }
*/

  void _showMessageInScaffold(Color color, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
      behavior: SnackBarBehavior.floating,
    ));
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
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white, // add custom icons also
            ),
          ),
          title: Text(
            _GENERIC_SCAN_RIDE,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff00DD00),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
          Expanded(
              child: Container(
                  alignment: Alignment.topLeft,
                  child: FlatButton(
                    onPressed: () {
                      _captureController.pause();
                      _captureController.resume();
                    },
                    child: new Icon(
                      Icons.filter_center_focus,
                      color: Colors.white,
                    ),
                    //child: Text('pause'),
                  ))),
          Container(
              alignment: Alignment.topRight,
              child: FlatButton(
                onPressed: () {
                  if (_isTorchOn) {
                    _captureController.torchMode = CaptureTorchMode.off;
                    Icons.flash_off;
                  } else {
                    _captureController.torchMode = CaptureTorchMode.on;
                    Icons.flash_on;
                  }
                  _isTorchOn = !_isTorchOn;
                },
                child: new Icon(
                  Icons.flash_on,
                  color: Colors.white,
                ),
              )),
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
        height: 95,
        padding: EdgeInsets.fromLTRB(15, 8, 15, 15),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ManualBarcodeScreen(),
                  ));
            },
          )
        ]));
  }

  Future showModalBottomSheet1() async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              //  height: MediaQuery.of(context).size.height * 220.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              height: 270.0,
              child: new ListView(children: [
                Container(
                    height: 200,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                              height: 180,
                              width: 150,
                              //   height: MediaQuery.of(context).size.height ,
                              //  width:MediaQuery.of(context).size.width
                              child: Image.asset(
                                  'assets/images/img_scooter.png',
                                  fit: BoxFit.fill),
                            ),
                          ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                                padding: EdgeInsets.only(top: 20.0, left: 10.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Image.asset(
                                          'assets/images/ic_scooter.png',
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.fill),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: new Row(children: <Widget>[
                                        Container(
                                          child: Text(
                                            'ScooterO',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${serial_number}',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(top: 70.0),
                                      child: Image.asset(
                                          'assets/images/ic_battery.png',
                                          width: 20,
                                          height: 25,
                                          fit: BoxFit.fill),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: new Row(children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Battery',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${battery_life}',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                )),
                            //   height: MediaQuery.of(context).size.height ,
                            //  width:MediaQuery.of(context).size.width
                          ),
                          flex: 2,
                        ),
                      ],
                    )),
                Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xff00DD00),
                      child: Text(
                        _GENERIC_UNLOCK_SCOOTER,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContextcontext) =>
                                  PaymentMethodScreen(scootoroAllDetails))),
                    )),
              ]));
        });
  }
}
