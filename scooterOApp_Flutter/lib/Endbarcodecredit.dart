import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:qrcode/qrcode.dart';
import 'package:scotto/endmanualbarcredit.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';

class EndBarCredit extends StatefulWidget {
  @override
  final trip_details;
  EndBarCredit(this.trip_details);
  _EndBarCreditState createState() => _EndBarCreditState(this.trip_details);
}

class _EndBarCreditState extends State<EndBarCredit> with TickerProviderStateMixin {
  final trip_details;
  _EndBarCreditState(this.trip_details);

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;
  var _GENERIC_ENTER_QR = ' ',_GENERIC_SCAN_RIDE = '',_GENERIC_UNLOCK_SCOOTER = '';
  var customer_details,scootoroDetails;
  var trip_number,scooter_id,payment_id,subscription_id,status,ride_start,ride_mins,ride_distance,ride_end,total_ride_amt,unlock_charge,sub_total,vat_charge,grand_total,scootertripenddetails;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;

    setState(() {
      _GENERIC_ENTER_QR = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_ENTER_QR');
      _GENERIC_SCAN_RIDE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_SCAN_RIDE");

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
    var data =json.encode( {"id":customer_id,"scootoro_id":trip_details['scooter_id'],"trip_number":trip_details['trip_number'],"distance":"2.2","customer_id": customer_id,"scoo_lat":"2.76374863784","scoo_long":"2.0699408594"});
    final response = await http.post(baseurl + 'api_ride_end', headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var  jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "Success"){

        //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ), (Route<dynamic> route) => false);
      }else if(jsonResponse['status'] == 'Error'){
        print(jsonResponse['message']);
        //   _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      //   _showMessageInScaffold('Contact Admin!!');
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
        setState(() {
        });
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>HomeScreen()
                  )
              );
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,// add custom icons also
            ),
          ),
          title: Text(_GENERIC_SCAN_RIDE,style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor:Color(0xff00DD00),
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
              alignment:Alignment.topCenter,
              child:_buildToolBar(),

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
            child: new Icon(Icons.filter_center_focus,color: Colors.white,),
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

            child: new Icon(Icons.flash_on,color: Colors.white,),
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
        padding: EdgeInsets.fromLTRB(15,8, 15, 0),
        child:ListView(
          children: [
          RaisedButton(
          textColor: Colors.white,
          color: Color(0xff00DD00),
          child: Text( _GENERIC_ENTER_QR ,style:TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0),),
          onPressed:() {
            // login();
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>EndManualbarCredit(trip_details),));

          },)]));
  }





}