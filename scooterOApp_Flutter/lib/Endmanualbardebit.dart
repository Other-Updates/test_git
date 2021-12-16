import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scotto/barcode_scan.dart';
import 'package:scotto/rideprepaidscreen.dart';
import 'package:scotto/riderentprescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndManualBardebit extends StatefulWidget {
  @override
  final tripDetails;
  EndManualBardebit(this.tripDetails);
  _EndManualBardebitState createState() =>
      _EndManualBardebitState(this.tripDetails);
}

class _EndManualBardebitState extends State<EndManualBardebit> {
  final tripDetails;
  _EndManualBardebitState(this.tripDetails);
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController entercodeController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  var _GENERIC_ENTER_QR = ' ',
      _GENERIC_ENTER_QR_CODE = '',
      _GENERIC_END_RIDE = '',
      _GENERIC_OK = '',
      _GENERIC_PARK_SCOOTER_SAFE = '',
      _GENERIC_PARK_SCOOTER_SAFE_MSG = '';
  var customerDetails, scooterODetails;

  var tripNumber,
      scooterId,
      paymentId,
      subscriptionId,
      status,
      rideStart,
      rideMins,
      rideDistance,
      rideEnd,
      total_ride_amt,
      unlockCharge,
      subTotal,
      vatCharge,
      grandTotal,
      scooterTripEndDetails;

  String customerId = '';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customerId = data;
      });
    } catch (ex) {
      print(ex);
    }
  }

  endRide() async {
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({
      "id": "",
      "scootoro_id": tripDetails['scooter_id'],
      "trip_number": tripDetails['trip_number'],
      "distance": "2.2",
      "customer_id": customerId,
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
                    RidePrepaidScreen(tripDetails)),
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
                                RidePrepaidScreen(tripDetails)),
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
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RideRentPreScreen(tripDetails)),
                          (Route<dynamic> route) => false);
                    },
                  )),
            ])));
      },
    );
  }

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_ENTER_QR =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_ENTER_QR');
      _GENERIC_ENTER_QR_CODE = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_ENTER_QR_CODE");
      _GENERIC_END_RIDE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_END_RIDE");
      _GENERIC_PARK_SCOOTER_SAFE = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_PARK_SCOOTER_SAFE");
      _GENERIC_OK = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OK");
      _GENERIC_PARK_SCOOTER_SAFE_MSG = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_PARK_SCOOTER_SAFE_MSG");
    });
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
    getTextFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => BarCode())),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          _GENERIC_ENTER_QR,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff00DD00),
      ),
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                colorFilter: ColorFilter.mode(
                    Color(0xffF1FDF0).withOpacity(1.0), BlendMode.dstATop),
                fit: BoxFit.cover)),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(14, 15, 14, 0),
              child: TextField(
                controller: entercodeController,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: _GENERIC_ENTER_QR_CODE,
                  //  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Montserrat'),
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
                ),
              ),
            ),
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(14, 15, 14, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Color(0xff00DD00),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _GENERIC_END_RIDE,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => endRide(),
                )),
          ],
        ),
      ),
    );
  }
}
